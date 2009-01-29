VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmPostOfficesSearch 
   Caption         =   "Post Offices Search"
   ClientHeight    =   4545
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6360
   Icon            =   "frmPostOfficesSearch.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   4545
   ScaleWidth      =   6360
   Begin VB.CommandButton cmdSearch 
      Caption         =   "Search"
      Height          =   375
      Left            =   4920
      TabIndex        =   2
      Top             =   840
      Width           =   1335
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   3480
      TabIndex        =   4
      Top             =   4080
      Width           =   1335
   End
   Begin VB.CommandButton cmdSelect 
      Caption         =   "Select"
      Height          =   375
      Left            =   4920
      TabIndex        =   5
      Top             =   4080
      Width           =   1335
   End
   Begin MSComctlLib.ListView lvwResults 
      Height          =   1695
      Left            =   360
      TabIndex        =   3
      Top             =   2040
      Width           =   5655
      _ExtentX        =   9975
      _ExtentY        =   2990
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Frame frmeResults 
      Caption         =   "Results"
      Height          =   2295
      Left            =   120
      TabIndex        =   11
      Top             =   1680
      Width           =   6135
   End
   Begin VB.Frame frmeOptions 
      Caption         =   "Options"
      Height          =   855
      Left            =   120
      TabIndex        =   8
      Top             =   720
      Width           =   4695
      Begin VB.TextBox txtSearch 
         Height          =   285
         Left            =   1080
         TabIndex        =   0
         Top             =   360
         Width           =   1575
      End
      Begin VB.ComboBox cboSearchIn 
         Height          =   315
         Left            =   3000
         Style           =   2  'Dropdown List
         TabIndex        =   1
         Top             =   360
         Width           =   1455
      End
      Begin VB.Label lblSearchFor 
         Caption         =   "Search for"
         Height          =   255
         Left            =   240
         TabIndex        =   10
         Top             =   360
         Width           =   855
      End
      Begin VB.Label lblIn 
         Caption         =   "in"
         Height          =   255
         Left            =   2760
         TabIndex        =   9
         Top             =   360
         Width           =   135
      End
   End
   Begin VB.Label lblResults 
      Height          =   255
      Index           =   1
      Left            =   960
      TabIndex        =   13
      Top             =   4080
      Width           =   1335
   End
   Begin VB.Label lblResults 
      Caption         =   "Results"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   12
      Top             =   4080
      Width           =   615
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Post Offices Search"
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
      Left            =   240
      TabIndex        =   6
      Top             =   240
      Width           =   3375
   End
   Begin VB.Label lblBackground 
      BackColor       =   &H8000000C&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H8000000C&
      Height          =   495
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   6135
   End
End
Attribute VB_Name = "frmPostOfficesSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Event Selected(ByVal strID As String)
Public Event CloseSearch()

Private Sub cmdClose_Click()
    '*** Close the Form using this event which is trapped in frmOrders
    RaiseEvent CloseSearch
End Sub

Private Sub cmdSearch_Click()

    Screen.MousePointer = vbHourglass
    
    Dim objCPostOffices As Consineer.PostOffices
    Dim rsPostOffices As ADODB.Recordset
    Dim strSearch As String, intSearchIn As Integer
    Dim strPostOffice As String, strPostCode As String
    Dim lngCounter As Long
    
    lngCounter = 1
    
    strSearch = Trim(txtSearch.Text)
    intSearchIn = cboSearchIn.ListIndex
    If Not (Len(strSearch) < 3 Or strSearch = "" Or IsNull(strSearch) Or intSearchIn < 0 Or intSearchIn > 2) Then
    
        lvwResults.ListItems.Clear
        
        Set objCPostOffices = New Consineer.PostOffices
        Set rsPostOffices = objCPostOffices.Search(strSearch, intSearchIn, g_strDatabasePath & gc_strDatabase)
        
        With rsPostOffices
            If Not (.BOF And .EOF) Then
                .MoveFirst
                Do While Not .EOF
                    strPostOffice = "": strPostCode = ""
                    If Not IsNull(.Fields("PostOffice")) Then strPostOffice = .Fields("PostOffice")
                    If Not IsNull(.Fields("PostCode")) Then strPostCode = .Fields("PostCode")
                    lvwResults.ListItems.Add lngCounter, "ID" & .Fields("ID"), .Fields("ID")
                    lvwResults.ListItems(lngCounter).SubItems(1) = .Fields("FAD")
                    lvwResults.ListItems(lngCounter).SubItems(2) = strPostOffice
                    lvwResults.ListItems(lngCounter).SubItems(3) = strPostCode
                    .MoveNext
                    lngCounter = lngCounter + 1
                Loop
                lblResults(1).Caption = lngCounter - 1
            Else
                '*** No results returned
                lvwResults.ListItems.Add lngCounter, "ErrNoRecords", "No Results Returned"
            End If
        End With
    
    Else
        MsgBox "Please specify valid Search Criteria and Search Field", vbOKOnly + vbInformation, "Consineer"
    End If

    Set rsPostOffices = Nothing
    Set objCPostOffices = Nothing

    Screen.MousePointer = vbDefault

End Sub

Private Sub cmdSelect_Click()
    If lvwResults.ListItems.Count > 0 And IsNumeric(lvwResults.SelectedItem) Then
        RaiseEvent Selected(lvwResults.SelectedItem.Text)
        RaiseEvent CloseSearch
    End If
End Sub

Private Sub Form_Load()
    
    Call ToggleModal(True, Me)
    
    '*** Set up the Combo Box
    With cboSearchIn
        .AddItem "FAD"
        .AddItem "Post Office"
        .AddItem "Post Code"
    End With
    
    '*** Set up the Listview Control
    With lvwResults
        .View = lvwReport
        .FullRowSelect = True
        .ColumnHeaders.Add 1, "ID", "ID", .Width / 4
        .ColumnHeaders.Add 2, "FAD", "FAD", .Width / 4
        .ColumnHeaders.Add 3, "PostOffices", "Post Offices", .Width / 4
        .ColumnHeaders.Add 4, "PostCode", "Postcode", .Width / 4
    End With

End Sub

Private Sub Form_Resize()
    
    Dim intCounter As Integer
    
    If Me.WindowState <> vbMinimized Then
        If Me.Width <= 6450 Then Me.Width = 6450
        If Me.Height <= 4935 Then Me.Height = 4935
        lblBackground.Width = Me.Width - 315
        frmeResults.Width = Me.Width - 315
        frmeResults.Height = Me.Height - 2640
        lvwResults.Width = Me.Width - 795
        lvwResults.Height = Me.Height - 3240
        lblResults(1).Top = frmeResults.Top + frmeResults.Height + 105
        lblResults(0).Top = frmeResults.Top + frmeResults.Height + 105
        cmdClose.Left = (frmeResults.Left + frmeResults.Width) - (cmdSelect.Width + cmdClose.Width) - 105
        cmdClose.Top = (frmeResults.Top + frmeResults.Height) + 105
        cmdSelect.Left = (frmeResults.Left + frmeResults.Width) - cmdSelect.Width
        cmdSelect.Top = (frmeResults.Top + frmeResults.Height) + 105
        For intCounter = 1 To 4
            lvwResults.ColumnHeaders(intCounter).Width = lvwResults.Width / 4
        Next intCounter
    End If
    
End Sub

Private Sub txtSearch_Validate(Cancel As Boolean)
    txtSearch.Text = Replace(txtSearch.Text, Chr(39), "")
End Sub
