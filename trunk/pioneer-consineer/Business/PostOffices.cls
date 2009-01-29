VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PostOffices"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Dim objCData As Consineer.Data

Public Function GetPostOfficeDetails(ByVal intID As Integer, Optional ByVal strDatabase As String) As ADODB.Recordset

On Error GoTo GetPostOfficeDetailsErr

    Dim dbConn As ADODB.Connection
    Dim rsReturn As ADODB.Recordset
    
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
        .Source = "SELECT * FROM vw_PostOffices_List WHERE vw_PostOffices_List.ID = " & intID
        .LockType = adLockReadOnly
        .Open
        
        If Not (.BOF And .EOF) Then
            .MoveFirst
        End If
        
    End With
    
    Set GetPostOfficeDetails = rsReturn
    
    Set objCData = Nothing
    Set rsReturn = Nothing
    Set dbConn = Nothing

Exit Function
GetPostOfficeDetailsErr:
    Call ErrorHandler(Err.Number, "Consineer:GetPostOfficeDetails", Err.Description)
End Function

Public Function Search(ByVal strSearch As String, ByVal intSearchIn As Integer, Optional ByVal strDatabase As String) As ADODB.Recordset

On Error GoTo SearchErr

    Dim dbConn As ADODB.Connection
    Dim rsReturn As ADODB.Recordset
    Dim strSQL As String
    
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
    
    Select Case intSearchIn
        Case 0
            '*** FAD Code
            strSQL = "SELECT ID, FAD, ContractType_ID, PostOffice, Address1, Address2, Address3, Address4, Address5, PostCode FROM PostOffices WHERE FAD LIKE '" & strSearch & "%'"
        Case 1
            '*** Post Office
            strSQL = "SELECT ID, FAD, ContractType_ID, PostOffice, Address1, Address2, Address3, Address4, Address5, PostCode FROM PostOffices WHERE PostOffice LIKE '" & strSearch & "%'"
        Case 2
            '*** Post Code
            strSQL = "SELECT ID, FAD, ContractType_ID, PostOffice, Address1, Address2, Address3, Address4, Address5, PostCode FROM PostOffices WHERE PostCode LIKE '" & strSearch & "%'"
    End Select
    
    With rsReturn
        .ActiveConnection = dbConn
        .CursorType = adOpenForwardOnly
        .Source = strSQL
        .LockType = adLockReadOnly
        .Open
        
        If Not (.BOF And .EOF) Then
            .MoveFirst
        End If
        
    End With
    
    Set Search = rsReturn
    
    Set objCData = Nothing
    Set rsReturn = Nothing
    Set dbConn = Nothing

Exit Function
SearchErr:
    Call ErrorHandler(Err.Number, "Consineer:Search", Err.Description)
End Function
