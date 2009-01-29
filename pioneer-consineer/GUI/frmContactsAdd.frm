VERSION 5.00
Begin VB.Form frmContactsAdd 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Search "
   ClientHeight    =   4320
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6840
   Icon            =   "frmContactsAdd.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4320
   ScaleWidth      =   6840
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   3960
      TabIndex        =   9
      Top             =   3840
      Width           =   1335
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   5400
      TabIndex        =   10
      Top             =   3840
      Width           =   1335
   End
   Begin VB.Frame frmeContactsAdd 
      Caption         =   "Contact Details"
      Height          =   3015
      Left            =   120
      TabIndex        =   11
      Top             =   720
      Width           =   6615
      Begin VB.ComboBox cboTitle 
         Height          =   315
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   0
         Top             =   480
         Width           =   1215
      End
      Begin VB.TextBox txtPostcode 
         Height          =   285
         Left            =   4560
         TabIndex        =   8
         Top             =   2400
         Width           =   1695
      End
      Begin VB.TextBox txtAddress4 
         Height          =   285
         Left            =   4560
         TabIndex        =   7
         Top             =   1920
         Width           =   1695
      End
      Begin VB.TextBox txtAddress3 
         Height          =   285
         Left            =   4560
         TabIndex        =   6
         Top             =   1440
         Width           =   1695
      End
      Begin VB.TextBox txtAddress2 
         Height          =   285
         Left            =   4560
         TabIndex        =   5
         Top             =   960
         Width           =   1695
      End
      Begin VB.TextBox txtAddress1 
         Height          =   285
         Left            =   1440
         TabIndex        =   4
         Top             =   2400
         Width           =   1695
      End
      Begin VB.TextBox txtCompany 
         Height          =   285
         Left            =   1440
         TabIndex        =   3
         Top             =   1920
         Width           =   1695
      End
      Begin VB.TextBox txtSurname 
         Height          =   285
         Left            =   1440
         TabIndex        =   2
         Top             =   1440
         Width           =   1695
      End
      Begin VB.TextBox txtForename 
         Height          =   285
         Left            =   1440
         TabIndex        =   1
         Top             =   960
         Width           =   1695
      End
      Begin VB.Label lblTitle 
         Caption         =   "Title"
         Height          =   255
         Index           =   1
         Left            =   360
         TabIndex        =   20
         Top             =   480
         Width           =   495
      End
      Begin VB.Label lblPostcode 
         Caption         =   "Postcode"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   3480
         TabIndex        =   19
         Top             =   2400
         Width           =   855
      End
      Begin VB.Label lblAddress4 
         Caption         =   "Address 4"
         Height          =   255
         Left            =   3480
         TabIndex        =   18
         Top             =   1920
         Width           =   735
      End
      Begin VB.Label lblAddress3 
         Caption         =   "Address 3"
         Height          =   255
         Left            =   3480
         TabIndex        =   17
         Top             =   1440
         Width           =   735
      End
      Begin VB.Label lblAddress2 
         Caption         =   "Address 2"
         Height          =   255
         Left            =   3480
         TabIndex        =   16
         Top             =   960
         Width           =   735
      End
      Begin VB.Label lblAddress1 
         Caption         =   "Address 1"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   360
         TabIndex        =   15
         Top             =   2400
         Width           =   975
      End
      Begin VB.Label lblCompany 
         Caption         =   "Company"
         Height          =   255
         Left            =   360
         TabIndex        =   14
         Top             =   1920
         Width           =   735
      End
      Begin VB.Label lblSurname 
         Caption         =   "Surname"
         Height          =   255
         Left            =   360
         TabIndex        =   13
         Top             =   1440
         Width           =   735
      End
      Begin VB.Label lblForename 
         Caption         =   "Forename"
         Height          =   255
         Left            =   360
         TabIndex        =   12
         Top             =   960
         Width           =   975
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Add a Contact"
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
      TabIndex        =   21
      Top             =   240
      Width           =   3375
   End
   Begin VB.Label lblBackground 
      BackColor       =   &H8000000C&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H8000000C&
      Height          =   495
      Left            =   120
      TabIndex        =   22
      Top             =   120
      Width           =   6615
   End
End
Attribute VB_Name = "frmContactsAdd"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private blnEdited As Boolean

Private Sub cmdClose_Click()
    Unload frmContactsAdd
End Sub

Private Sub cmdSave_Click()

    Dim objCContact As Consineer.Contacts
    Dim blnReturn As Boolean
    Dim intTitle As Integer
    Dim strForename As String, strSurname As String, strCompany As String
    Dim strAddress1 As String, strAddress2 As String, strAddress3 As String
    Dim strAddress4 As String, strPostCode As String
    
    Set objCContact = New Consineer.Contacts
    
    If cboTitle.ListIndex <> -1 Then
        intTitle = cboTitle.ItemData(cboTitle.ListIndex)
    Else
        intTitle = -1
    End If
    strForename = Trim(txtForename.Text)
    strSurname = Trim(txtSurname.Text)
    strCompany = Trim(txtCompany.Text)
    strAddress1 = Trim(txtAddress1.Text)
    strAddress2 = Trim(txtAddress2.Text)
    strAddress3 = Trim(txtAddress3.Text)
    strAddress4 = Trim(txtAddress4.Text)
    strPostCode = Trim(txtPostcode.Text)
    
    'If intTitle <> -1 And strForename <> vbNullString And IsNull(strForename) = False And strSurname <> vbNullString And IsNull(strSurname) = False And strAddress1 <> vbNullString And IsNull(strAddress1) = False And strPostCode <> vbNullString And IsNull(strPostCode) = False Then
    If strAddress1 <> vbNullString And Not IsNull(strAddress1) And strPostCode <> vbNullString And Not IsNull(strPostCode) Then
        blnReturn = objCContact.SaveContact(intTitle, strForename, strSurname, strCompany, strAddress1, strAddress2, strAddress3, strAddress4, strPostCode, g_strDatabasePath & gc_strDatabase)
    Else
        blnReturn = False
    End If
    
    If blnReturn = False Then
        MsgBox "The record was not saved at this time due to some required fields being left empty", vbOKOnly + vbInformation, "Consineer"
    Else
        Call ToggleSave(False)
    End If
    
    Set objCContact = Nothing

End Sub

Private Sub Form_Load()

    Call ToggleSave(False)
    
    '*** Setup parameters for the Text Box Controls
    txtForename.MaxLength = 25
    txtSurname.MaxLength = 25
    txtCompany.MaxLength = 50
    txtAddress1.MaxLength = 50
    txtAddress2.MaxLength = 50
    txtAddress3.MaxLength = 50
    txtAddress4.MaxLength = 50
    txtPostcode.MaxLength = 11
    
    '*** Setup the Title Combo Box
    Dim objConsineer As Consineer.Data
    Dim rsTitles As ADODB.Recordset
    
    Set objConsineer = New Consineer.Data
    Set rsTitles = objConsineer.GetData("vw_Contacts_Titles", g_strDatabasePath & gc_strDatabase)
    
    With rsTitles
        If Not (.BOF And .EOF) Then
            .MoveFirst
            Do While Not .EOF
                cboTitle.AddItem .Fields("Title")
                cboTitle.ItemData(cboTitle.NewIndex) = .Fields("ID")
                .MoveNext
            Loop
        End If
    End With
    
    Set rsTitles = Nothing
    Set objConsineer = Nothing
    '*** /Setup the Title Combo Box

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    
    Dim intResponse As Integer
    
    If blnEdited = True Then
        intResponse = MsgBox("You have not saved the current contact details." & vbCrLf & vbCrLf & _
                "Do you wish to save them now?", vbYesNoCancel + vbQuestion, "Consineer")
        If intResponse = vbYes Then
            Cancel = True
            Call cmdSave_Click
        ElseIf intResponse = vbCancel Then
            Cancel = True
        End If
    End If
    
End Sub

Private Sub txtAddress1_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtAddress1_Validate(Cancel As Boolean)
    txtAddress1.Text = Replace(txtAddress1.Text, Chr(39), "")
End Sub

Private Sub txtAddress2_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtAddress2_Validate(Cancel As Boolean)
    txtAddress2.Text = Replace(txtAddress2.Text, Chr(39), "")
End Sub

Private Sub txtAddress3_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtAddress3_Validate(Cancel As Boolean)
    txtAddress3.Text = Replace(txtAddress3.Text, Chr(39), "")
End Sub

Private Sub txtAddress4_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtAddress4_Validate(Cancel As Boolean)
    txtAddress4.Text = Replace(txtAddress4.Text, Chr(39), "")
End Sub

Private Sub txtCompany_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtCompany_Validate(Cancel As Boolean)
    txtCompany.Text = Replace(txtCompany.Text, Chr(39), "")
End Sub

Private Sub txtForename_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtForename_Validate(Cancel As Boolean)
    txtForename.Text = Replace(txtForename.Text, Chr(39), "")
End Sub

Private Sub txtPostcode_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtPostcode_Validate(Cancel As Boolean)
    txtPostcode.Text = Replace(txtPostcode.Text, Chr(39), "")
End Sub

Private Sub txtSurname_Change()
    Call ToggleSave(True)
End Sub

Private Sub txtSurname_Validate(Cancel As Boolean)
    txtSurname.Text = Replace(txtSurname.Text, Chr(39), "")
End Sub

Private Sub ToggleSave(ByVal blnValue As Boolean)
    blnEdited = blnValue
    cmdSave.Enabled = blnValue
End Sub
