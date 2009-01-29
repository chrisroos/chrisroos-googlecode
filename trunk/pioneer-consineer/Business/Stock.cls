VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Stock"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private objCData As Consineer.Data

Public Function AmendStock(ByVal intStockID As Integer, ByVal intAmendment As Integer, ByVal intAmendmentType As Integer, ByVal strDate As String, Optional ByVal blnForce As Boolean = False, Optional ByVal strDatabase As String, Optional ByVal intOrderID As Integer) As Boolean

On Error GoTo AmendStockErr

    Dim blnAmendSuccess As Boolean
    
    If intAmendment = 0 Then
        '*** If the amend level is zero then it is an error
        blnAmendSuccess = False
    Else
        
        If blnForce = False Then
            '*** By default, before amending a stock level, check if it is
            '*** possible.  If blnForce is set to true then the current
            '*** stock level is not checked.
            If TestStockAmendment(intStockID, intAmendment, strDatabase) = False Then
                '*** If we are unable to amend the stock level by the required amount
                '*** then set the return flag to false and exit
                blnAmendSuccess = False
                AmendStock = blnAmendSuccess
                Exit Function
            End If
        End If

        '*** We are able to amend the Stock levels by the required amount,
        '*** Edit the stock and stock_amendments tables as required.
        
        Dim intCurrentStockLevel As Integer
        intCurrentStockLevel = ReturnCurrentStockLevel(intStockID, strDatabase)
        
        Dim dbConn As ADODB.Connection
        Dim rsStock As ADODB.Recordset
        
        Set dbConn = New ADODB.Connection
        Set rsStock = New ADODB.Recordset
        Set objCData = New Consineer.Data
        
        With dbConn
            If Not IsNull(strDatabase) And Trim(strDatabase) <> "" Then
                objCData.Database = strDatabase
            End If
            .ConnectionString = objCData.ConnectionString
            .CursorLocation = adUseClient
            .Open
        End With

        With rsStock
            '*** Update the CurrentStockLevel in Stock
            .ActiveConnection = dbConn
            .CursorType = adOpenKeyset
            .Source = "UPDATE Stock SET CurrentStockLevel = " & intCurrentStockLevel + intAmendment & " WHERE ID = " & intStockID
            .LockType = adLockOptimistic
            .Open
            
            '*** Add an entry to Stock_Amendments
            .ActiveConnection = dbConn
            .CursorType = adOpenKeyset
            .Source = "Stock_Amendments"
            .LockType = adLockOptimistic
            .Open
            .AddNew
            .Fields("Stock_ID") = intStockID
            .Fields("Date") = Format(strDate, "yyyy-mm-dd")
            .Fields("Amendment") = intAmendment
            .Fields("AmendmentType_ID") = intAmendmentType
            If Not IsNull(intOrderID) And IsNumeric(intOrderID) And intOrderID <> 0 Then
                .Fields("Order_ID") = intOrderID
            End If
            .Update
            .Close
        End With
        
        Set objCData = Nothing
        Set rsStock = Nothing
        Set dbConn = Nothing

        blnAmendSuccess = True

    End If
    
    AmendStock = blnAmendSuccess

Exit Function
AmendStockErr:
    Call ErrorHandler(Err.Number, "Consineer:AmendStock", Err.Description)
End Function

Public Function ReturnCurrentStockLevel(ByVal intStockID As Integer, Optional ByVal strDatabase As String) As Integer

On Error GoTo ReturnCurrentStockLevelErr

    Dim dbConn As ADODB.Connection
    Dim rsReturn As ADODB.Recordset
    Dim intCurrentStockLevel As Integer
    
    Set dbConn = New ADODB.Connection
    Set rsReturn = New ADODB.Recordset
    Set objCData = New Consineer.Data

    With dbConn
        If Not IsNull(strDatabase) And Trim(strDatabase) <> "" Then
            objCData.Database = strDatabase
        End If
        .ConnectionString = objCData.ConnectionString
        .CursorLocation = adUseClient
        .Open
    End With

    With rsReturn
        .ActiveConnection = dbConn
        .CursorType = adOpenForwardOnly
        .Source = "SELECT CurrentStockLevel FROM Stock WHERE ID = " & intStockID
        .LockType = adLockReadOnly
        .Open
        
        If Not (.BOF And .EOF) Then
            .MoveFirst
            If Not IsNull(.Fields("CurrentStockLevel")) Then
                intCurrentStockLevel = .Fields("CurrentStockLevel")
            Else
                intCurrentStockLevel = 0
            End If
        Else
            '*** Use this as an error indicator - hopefully an item of stock will never
            '*** have this number of items in stock.
            '*** Should probably raise an error or return a collection that allows me
            '*** to set an error bit.
            intCurrentStockLevel = -32767
        End If
        
    End With
    
    ReturnCurrentStockLevel = intCurrentStockLevel
    
    Set objCData = Nothing
    Set rsReturn = Nothing
    Set dbConn = Nothing

Exit Function
ReturnCurrentStockLevelErr:
    Call ErrorHandler(Err.Number, "Consineer:ReturnCurrentStockLevel", Err.Description)
End Function

Public Function TestStockAmendment(ByVal intStockID As Integer, ByVal intQuantity As Integer, Optional ByVal strDatabase As String) As Boolean

On Error GoTo TestStockAmendmentErr

    Dim intCurrentStockLevel As Integer
    Dim blnTestStockAmendment As Boolean
    
    intCurrentStockLevel = ReturnCurrentStockLevel(intStockID, strDatabase)
    If intCurrentStockLevel = -32767 Then
        '*** The selected item of stock was not found
        blnTestStockAmendment = False
    ElseIf intCurrentStockLevel + intQuantity < 0 Then
        '*** Reducing the current stock level by the amount required leaves
        '*** us with minus stock!! Impossible.
        blnTestStockAmendment = False
    Else
        blnTestStockAmendment = True
    End If
    
    TestStockAmendment = blnTestStockAmendment

Exit Function
TestStockAmendmentErr:
    Call ErrorHandler(Err.Number, "Consineer:TestStockAmendment", Err.Description)
End Function
