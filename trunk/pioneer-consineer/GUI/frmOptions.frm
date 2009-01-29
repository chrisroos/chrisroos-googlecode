VERSION 5.00
Begin VB.Form frmOptions 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Options"
   ClientHeight    =   3105
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4545
   Icon            =   "frmOptions.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3105
   ScaleWidth      =   4545
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   1680
      TabIndex        =   6
      Top             =   2640
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3120
      TabIndex        =   5
      Top             =   2640
      Width           =   1335
   End
   Begin VB.Frame frmeOptions 
      Caption         =   "Application Paths"
      Height          =   1815
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   4335
      Begin VB.TextBox txtReportPath 
         Height          =   285
         Left            =   1680
         TabIndex        =   8
         Top             =   1080
         Width           =   2175
      End
      Begin VB.TextBox txtDatabasePath 
         Height          =   285
         Left            =   1680
         TabIndex        =   7
         Top             =   600
         Width           =   2175
      End
      Begin VB.Label lblReportsPath 
         Caption         =   "Reports Path:"
         Height          =   255
         Left            =   360
         TabIndex        =   4
         Top             =   1080
         Width           =   1095
      End
      Begin VB.Label lblDatabasePath 
         Caption         =   "Database Path:"
         Height          =   255
         Left            =   360
         TabIndex        =   3
         Top             =   600
         Width           =   1215
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Options"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   375
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   3375
   End
   Begin VB.Label lblBackground 
      BackColor       =   &H8000000C&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H8000000C&
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   4335
   End
End
Attribute VB_Name = "frmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    frmOptions.Hide
    Unload frmOptions
    Set frmOptions = Nothing
End Sub

Private Sub cmdOK_Click()

    Dim strDatabasePath As String, strReportPath As String

    strDatabasePath = Trim(txtDatabasePath.Text)
    strReportPath = Trim(txtReportPath.Text)

    If strDatabasePath <> "" And strReportPath <> "" And Dir(strDatabasePath, vbDirectory) <> "" And Dir(strReportPath, vbDirectory) <> "" Then
        Call SaveSetting("Consineer", "Paths", "Database", strDatabasePath)
        Call SaveSetting("Consineer", "Paths", "Reports", strReportPath)
        g_strDatabasePath = strDatabasePath
        g_strReportPath = strReportPath
        Unload frmOptions
        Set frmOptions = Nothing
    Else
        MsgBox "Either the Database Path or Report Path entered is invalid.  Please re-enter", vbOKOnly + vbExclamation, "Consineer"
    End If

End Sub

Private Sub Form_Load()
    Call CenterWindow(Me)
    txtDatabasePath.Text = g_strDatabasePath
    txtReportPath.Text = g_strReportPath
End Sub
