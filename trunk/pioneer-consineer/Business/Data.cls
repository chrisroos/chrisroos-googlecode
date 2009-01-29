VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Data"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_strConnectionString As String
Private m_strDatabase As String

Public Property Let Database(ByVal strDatabase As String)
    m_strDatabase = strDatabase
End Property

Public Property Get Database() As String
    Database = m_strDatabase
End Property

Public Property Get ConnectionString() As String
    ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & m_strDatabase & ";Persist Security Info=False"
End Property

Private Sub Class_Initialize()
    m_strDatabase = "C:\Pioneer\Pioneer v3\Database\Consineer.mdb"
End Sub

Public Function GetData(ByVal strDataSource As String, Optional ByVal strDatabase As String) As ADODB.Recordset

On Error GoTo GetDataErr

    Dim dbConn As ADODB.Connection
    Dim rs As ADODB.Recordset
    Dim blnNoData As Boolean
    
    Set dbConn = New ADODB.Connection
    Set rs = New ADODB.Recordset
    
    With dbConn
        If Not IsNull(strDatabase) And Trim(strDatabase) <> "" Then
            Database = strDatabase
        End If
        .ConnectionString = ConnectionString
        .CursorLocation = adUseClient
        .Open
    End With
    
    With rs
    
        .ActiveConnection = dbConn
        .CursorType = adOpenForwardOnly
        .Source = strDataSource
        .LockType = adLockReadOnly
        .Open
        
        If Not (.BOF And .EOF) Then
            .MoveFirst
        End If
        
    End With
    
    Set GetData = rs
    
    Set rs = Nothing
    Set dbConn = Nothing

Exit Function
GetDataErr:
    Call ErrorHandler(Err.Number, "Consineer:GetData", Err.Description)
End Function
