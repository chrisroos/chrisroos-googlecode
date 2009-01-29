VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Contacts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private objCData As Consineer.Data

Public Function GetContactDetails(ByVal intID As Integer, Optional ByVal strDatabase As String) As ADODB.Recordset

On Error GoTo GetContactDetailsErr

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
        .Source = "SELECT * FROM vw_Contacts_List WHERE vw_Contacts_List.ID = " & intID
        .LockType = adLockReadOnly
        .Open
        
        If Not (.BOF And .EOF) Then
            .MoveFirst
        End If
        
    End With
    
    Set GetContactDetails = rsReturn
    
    Set objCData = Nothing
    Set rsReturn = Nothing
    Set dbConn = Nothing

Exit Function
GetContactDetailsErr:
    Call ErrorHandler(Err.Number, "Consineer:GetContactDetails", Err.Description)
End Function

Public Function SaveContact(ByVal intTitle As Integer, ByVal strForename As String, _
        ByVal strSurname As String, ByVal strCompany As String, ByVal strAddress1 As String, _
        ByVal strAddress2 As String, ByVal strAddress3 As String, ByVal strAddress4 As String, _
        ByVal strPostcode As String, Optional ByVal strDatabase As String) As Boolean

On Error GoTo SaveContactErr

    'If intTitle = -1 Or Trim(strForename) = "" Or Trim(strSurname) = "" Or Trim(strAddress1) = "" Or Trim(strPostcode) = "" Then
    If strAddress1 = "" Or strPostcode = "" Then
        '*** One of the required fields was not entered - exit
        SaveContact = False
    Else
    
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
            '*** Add an entry to Contacts
            .ActiveConnection = dbConn
            .CursorType = adOpenKeyset
            .Source = "Contacts"
            .LockType = adLockOptimistic
            .Open
            .AddNew
            .Fields("Title_ID") = intTitle
            .Fields("Forename") = strForename
            .Fields("Surname") = strSurname
            .Fields("Company") = strCompany
            .Fields("Address1") = strAddress1
            .Fields("Address2") = strAddress2
            .Fields("Address3") = strAddress3
            .Fields("Address4") = strAddress4
            .Fields("PostCode") = strPostcode
            .Update
            .Close
        End With
        
        SaveContact = True
        
        Set objCData = Nothing
        Set rsReturn = Nothing
        Set dbConn = Nothing
    
    End If

Exit Function
SaveContactErr:
    Call ErrorHandler(Err.Number, "Consineer:SaveContact", Err.Description)
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
            '*** Surname
            strSQL = "SELECT ID, Surname, Forename, Company, Address1, Postcode FROM Contacts WHERE Surname LIKE '" & strSearch & "%'"
        Case 1
            '*** Company
            strSQL = "SELECT ID, Surname, Forename, Company, Address1, Postcode FROM Contacts WHERE Company LIKE '" & strSearch & "%'"
        Case 2
            '*** Post Code
            strSQL = "SELECT ID, Surname, Forename, Company, Address1, Postcode FROM Contacts WHERE PostCode LIKE '" & strSearch & "%'"
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
