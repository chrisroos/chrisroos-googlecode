Attribute VB_Name = "modErrHandler"
Option Explicit

Public Sub ErrorHandler(ByVal nError_IN As Long, Optional ByVal sSource_IN As String, Optional ByVal sDescription_IN As String)
    
    Dim sDescription As String
    
    sDescription = "Following error occured in " & sSource_IN & ":" & vbCrLf & sDescription_IN & vbCrLf

    Err.Raise nError_IN, sSource_IN, sDescription
    
    Call LogError(sSource_IN, sDescription_IN)
    
End Sub

Public Sub ErrorHandlerWithADO(ByVal nError_IN As Long, ByRef adoConn_IN As ADODB.Connection, Optional ByVal sSource_IN As String, Optional ByVal sDescription_IN As String)
    
    Dim sDescription As String
    Dim sADODisplayMsg As String
    Dim sADOLogMsg As String
    
    If Not (adoConn_IN Is Nothing) Then Call GetADOErrors(adoConn_IN, sADODisplayMsg, sADOLogMsg)
    
    sDescription = "Following error occured in " & sSource_IN & ":" & vbCrLf & _
                   CleanUpADOMsg(sDescription_IN) & vbCrLf & sADODisplayMsg
    
    Err.Raise nError_IN, sSource_IN, sDescription
    
    Call LogError(sSource_IN, CleanUpADOMsg(sDescription_IN) & vbCrLf & sADOLogMsg)
                         
End Sub

Private Function GetADOErrors(ByRef adoConn_IN As ADODB.Connection, ByRef sDisplayMsg As String, ByRef sLogMsg As String) As Boolean
    
On Error GoTo GetADOErrorsErr
    
    Dim oError As ADODB.Error

    sLogMsg = ""
    
    For Each oError In adoConn_IN.Errors
        sLogMsg = sLogMsg & "(ADO Err# " & oError.Number & ") " & CleanUpADOMsg(oError.Description) & vbCrLf
    Next oError
    
    If sLogMsg <> "" Then
        sDisplayMsg = "<Additional error messages have been logged (for Support)>"
    End If
    
    GetADOErrors = True
    
Exit Function
GetADOErrorsErr:
    sDisplayMsg = "....(Could not retreive additional ADO Errors!)"
    GetADOErrors = False
End Function

Public Sub LogError(sSource As String, sDescription As String)
    
On Error Resume Next
    
    App.LogEvent "(btukspn.co.uk:" & sSource & ") " & sDescription, vbLogEventTypeError
    Debug.Print "ERROR in " & sSource & ": " & sDescription

End Sub

Public Function CleanUpADOMsg(sMsg As String) As String
    
    Dim lPtr As Long
    Dim i As Integer
    
    For i = 1 To 3
        lPtr = InStr(lPtr + 1, sMsg, "]")
        If lPtr = 0 Then Exit For
    Next i
    
    If lPtr = 0 Then
        CleanUpADOMsg = sMsg
    Else
        CleanUpADOMsg = Mid(sMsg, lPtr + 1)
    End If
    
End Function
