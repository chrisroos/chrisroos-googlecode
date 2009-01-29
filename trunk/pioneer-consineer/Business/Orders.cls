VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Orders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Dim objCData As Consineer.Data

Public Function PlaceOrder(ByRef rsNewOrder As ADODB.Recordset, ByRef rsNewOrderDetails As ADODB.Recordset, ByVal strDate As String, Optional ByVal strDatabase As String) As Boolean

On Error GoTo PlaceOrderErr
    
    Dim blnInvalid As Boolean
    
    blnInvalid = False
    
    '*** Ensure that there is at least a Post Office or Contact
    Dim intContactID As Integer, intPostOfficeID As Integer, intDeliveryID As Integer

    intContactID = 0
    intPostOfficeID = 0
    intDeliveryID = 0
    
    With rsNewOrder
        If (.Fields("PostOffice_ID") = "" Or .Fields("PostOffice_ID") = 0) Then
            If (.Fields("Contact_ID") = "" Or .Fields("Contact_ID") = 0) Then
                blnInvalid = True
            Else
                intContactID = .Fields("Contact_ID")
            End If
        Else
            intPostOfficeID = .Fields("PostOffice_ID")
        End If
        If Not (.Fields("Delivery_ID") = "" Or .Fields("Delivery_ID") = 0 Or .Fields("Delivery_ID") = .Fields("Contact_ID")) Then
            intDeliveryID = .Fields("Delivery_ID")
        End If
    End With
    
    If blnInvalid = True Then
        PlaceOrder = False
        Exit Function
    End If
    '*** /Ensure that there is at least a Post Office or Contact
    
    '*** Check each of the Items of stock in turn ensuring that there is sufficient stock levels
    Dim objCStock As Consineer.Stock
    Dim intStockID As Integer, intQuantity As Integer
    Dim blnStockSuccess As Boolean
    
    With rsNewOrderDetails
        If Not (.BOF And .EOF) Then
            
            Set objCStock = New Consineer.Stock
            
            .MoveFirst
            Do While Not .EOF
                intStockID = .Fields("Stock_ID")
                intQuantity = -.Fields("Quantity") '*** As it is an order Quantity is always negative
                blnStockSuccess = objCStock.TestStockAmendment(intStockID, intQuantity, strDatabase)
                If blnStockSuccess = False Then
                    blnInvalid = True
                    Exit Do
                End If
                .MoveNext
            Loop
            
            Set objCStock = Nothing
            
        Else
            blnInvalid = True
        End If
    End With
    
    If blnInvalid = True Then
        PlaceOrder = False
        Exit Function
    End If
    '*** /Check each of the Items of stock in turn ensuring that there is sufficient stock levels
    
    '*** Add the Order
    Dim dbConn As ADODB.Connection
    Dim rsOrder As ADODB.Recordset, rsOrderDetails As ADODB.Recordset
    Dim intOrderID As Integer

    Set dbConn = New ADODB.Connection
    Set rsOrder = New ADODB.Recordset
    Set rsOrderDetails = New ADODB.Recordset
    Set objCData = New Consineer.Data

    With dbConn
        If Not IsNull(strDatabase) And Trim(strDatabase) <> "" Then
            objCData.Database = strDatabase
        End If
        .ConnectionString = objCData.ConnectionString
        .CursorLocation = adUseClient
        .Open
    End With

    With rsOrder
        '*** Add an entry to Orders
        .ActiveConnection = dbConn
        .CursorType = adOpenKeyset
        .Source = "Orders"
        .LockType = adLockOptimistic
        .Open
        .AddNew
        .Fields("PostOffice_ID") = intPostOfficeID
        .Fields("Contact_ID") = intContactID
        .Fields("Date") = Format(strDate, "yyyy-mm-dd")
        .Update
        intOrderID = .Fields("ID")
        .Close
    End With
    
    With rsOrderDetails
        .ActiveConnection = dbConn
        .CursorType = adOpenKeyset
        .Source = "Orders_Details"
        .LockType = adLockOptimistic
        .Open
        
        If Not (rsNewOrderDetails.BOF And rsNewOrderDetails.EOF) Then
            
            Dim blnReturn As Boolean
            
            Set objCStock = New Consineer.Stock
            
            rsNewOrderDetails.MoveFirst
            Do While Not rsNewOrderDetails.EOF
                
                intStockID = rsNewOrderDetails.Fields("Stock_ID")
                intQuantity = rsNewOrderDetails.Fields("Quantity")
                
                blnReturn = objCStock.AmendStock(intStockID, -intQuantity, CInt(Stock_Amendment_Type.Ordered), strDate, True, strDatabase, intOrderID)

                .AddNew
                .Fields("Order_ID") = intOrderID
                .Fields("Stock_ID") = intStockID
                .Fields("Quantity") = intQuantity
                .Update
                
                rsNewOrderDetails.MoveNext
            Loop
            
            Set objCStock = Nothing
            
        End If

        .Close
    End With

    PlaceOrder = True

    Set objCData = Nothing
    Set rsOrderDetails = Nothing
    Set rsOrder = Nothing
    Set dbConn = Nothing
    '*** /Add the Order

Exit Function
PlaceOrderErr:
    Call ErrorHandler(Err.Number, "Consineer:PlaceOrder", Err.Description)
End Function
