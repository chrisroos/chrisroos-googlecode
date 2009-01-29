VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.MDIForm frmMain 
   BackColor       =   &H8000000C&
   Caption         =   "Consineer"
   ClientHeight    =   6315
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   9885
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin MSComctlLib.ImageList imgMain 
      Left            =   3120
      Top             =   720
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   7
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0442
            Key             =   "Reports"
            Object.Tag             =   "Reports"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":075C
            Key             =   "AddContact"
            Object.Tag             =   "AddContact"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0BAE
            Key             =   "Data"
            Object.Tag             =   "Data"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1000
            Key             =   "DataMain"
            Object.Tag             =   "DataMain"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1452
            Key             =   "New"
            Object.Tag             =   "New"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":18A4
            Key             =   "Report"
            Object.Tag             =   "Report"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1BBE
            Key             =   "Contents"
            Object.Tag             =   "Contents"
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picContents 
      Align           =   3  'Align Left
      Height          =   5490
      Left            =   0
      ScaleHeight     =   5430
      ScaleWidth      =   2955
      TabIndex        =   1
      Top             =   555
      Width           =   3015
      Begin MSComctlLib.TreeView tvwContents 
         Height          =   4695
         Left            =   120
         TabIndex        =   2
         Top             =   600
         Width           =   2655
         _ExtentX        =   4683
         _ExtentY        =   8281
         _Version        =   393217
         Style           =   7
         Appearance      =   1
      End
      Begin VB.Line Line 
         Index           =   0
         X1              =   120
         X2              =   2160
         Y1              =   360
         Y2              =   360
      End
      Begin VB.Line Line 
         BorderColor     =   &H80000009&
         BorderWidth     =   2
         Index           =   3
         X1              =   120
         X2              =   2160
         Y1              =   360
         Y2              =   360
      End
      Begin VB.Line Line 
         Index           =   2
         X1              =   120
         X2              =   2160
         Y1              =   240
         Y2              =   240
      End
      Begin VB.Line Line 
         BorderColor     =   &H80000005&
         BorderWidth     =   2
         Index           =   1
         X1              =   120
         X2              =   2160
         Y1              =   240
         Y2              =   240
      End
   End
   Begin MSComctlLib.Toolbar tbar 
      Align           =   1  'Align Top
      Height          =   555
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9885
      _ExtentX        =   17436
      _ExtentY        =   979
      ButtonWidth     =   1191
      ButtonHeight    =   926
      Appearance      =   1
      Style           =   1
      _Version        =   393216
   End
   Begin MSComctlLib.StatusBar sbStatusBar 
      Align           =   2  'Align Bottom
      Height          =   270
      Left            =   0
      TabIndex        =   3
      Top             =   6045
      Width           =   9885
      _ExtentX        =   17436
      _ExtentY        =   476
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   3
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   11800
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   6
            AutoSize        =   2
            TextSave        =   "29/08/2002"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   5
            AutoSize        =   2
            TextSave        =   "10:59"
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuFileExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "Tools"
      Begin VB.Menu mnuToolsOptions 
         Caption         =   "Options"
      End
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "Window"
      WindowList      =   -1  'True
      Begin VB.Menu mnuWindowTileHorizontally 
         Caption         =   "Tile &Horizontally"
      End
      Begin VB.Menu mnuWindowTileVertically 
         Caption         =   "Tile &Vertically"
      End
      Begin VB.Menu mnuWindowCascade 
         Caption         =   "&Cascade"
      End
      Begin VB.Menu mnuWindowArrangeIcons 
         Caption         =   "&Arrange Icons"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuHelpContents 
         Caption         =   "Contents"
      End
      Begin VB.Menu mnuHelpSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "About Consineer"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub MDIForm_Load()

    '*** Read Path Settings from the Registry
    g_strDatabasePath = GetSetting("Consineer", "Paths", "Database", App.Path & "\Database")
    g_strReportPath = GetSetting("Consineer", "Paths", "Reports", App.Path & "\Reports")
    
    If Trim(g_strDatabasePath) = "" Or IsNull(g_strDatabasePath) Then g_strDatabasePath = App.Path & "\Database\"
    If Trim(g_strReportPath) = "" Or IsNull(g_strReportPath) Then g_strReportPath = App.Path & "\Reports\"
    
    If Right(g_strDatabasePath, 1) <> "\" Then g_strDatabasePath = g_strDatabasePath & "\"
    If Right(g_strReportPath, 1) <> "\" Then g_strReportPath = g_strReportPath & "\"

    '*** Setup the Status Bar
    sbStatusBar.Panels(1).Text = "Welcome to Consineer"
    
    '*** Setup the Toolbar
    tbar.ImageList = imgMain
    tbar.TextAlignment = tbrTextAlignBottom
    tbar.Style = tbrFlat
    tbar.Buttons.Add 1, "Contents", "Contents", tbrCheck, "Contents"
    tbar.Buttons.Add 2, , , tbrSeparator
    tbar.Buttons.Add 3, "AddOrder", "Add Order", tbrDefault, "New"
    tbar.Buttons.Add 4, , , tbrSeparator
    tbar.Buttons.Add 5, "AddContact", "Add Contact", tbrDefault, "AddContact"
    'tbar.Buttons.Add 6, "AddStock", "Add Stock", tbrDefault, "New"
    tbar.Buttons.Add 6, "AmendStock", "Amend Stock", tbrDefault, "New"
    tbar.Buttons(1).Value = tbrPressed

    '*** Setup the Treeview
    tvwContents.ImageList = imgMain
    tvwContents.Nodes.Add , , "Data", "Data", "DataMain"
    tvwContents.Nodes.Add "Data", tvwChild, "Post Offices", "Post Offices", "Data"
    tvwContents.Nodes.Add "Data", tvwChild, "Stock", "Stock", "Data"
    tvwContents.Nodes.Add "Data", tvwChild, "StockAmendments", "Stock Amendments", "Data"
    tvwContents.Nodes.Add "Data", tvwChild, "Contacts", "Contacts", "Data"
    tvwContents.Nodes.Add , , "Reports", "Reports", "Reports"
    tvwContents.Nodes.Add "Reports", tvwChild, "DeliveryNotes", "View Delivery Notes", "Report"
    tvwContents.Nodes.Add "Reports", tvwChild, "StockLevels", "Stock Levels", "Report"
    tvwContents.Nodes.Add "Reports", tvwChild, "LowStock", "Low Stock", "Report"
    tvwContents.Nodes.Add "Reports", tvwChild, "EndOfMonthReport", "End of Month Report", "Report"
    
    '*** Expand all Nodes in the Treeview
    Dim my_Node As Node
    For Each my_Node In tvwContents.Nodes
        my_Node.Expanded = True
    Next my_Node

End Sub

Private Sub MDIForm_Resize()
    '*** Resize all elements on the Form
    If Me.WindowState <> vbMinimized Then
        If Me.Width <= 10000 Then Me.Width = 10000
        If Me.Height <= 7000 Then Me.Height = 7000
        tvwContents.Height = Me.Height - 2310
    End If
End Sub

Private Sub mnuFileExit_Click()
    '*** Exit Cleanly
    frmMain.Hide
    Unload frmMain
    Set frmMain = Nothing
End Sub

Private Sub mnuToolsOptions_Click()
    frmOptions.Show vbModal
End Sub

Private Sub mnuWindowArrangeIcons_Click()
    frmMain.Arrange vbArrangeIcons
End Sub

Private Sub mnuWindowCascade_Click()
    frmMain.Arrange vbCascade
End Sub

Private Sub mnuWindowTileHorizontally_Click()
    frmMain.Arrange vbTileHorizontal
End Sub

Private Sub mnuWindowTileVertically_Click()
    frmMain.Arrange vbTileVertical
End Sub

Private Sub tbar_ButtonClick(ByVal Button As MSComctlLib.Button)
    '*** Perform specified action based on Button Pressed
    Select Case Button
        Case "Contents"
            '*** Hide or Show the Left Contents bar holding the treeview
            Select Case Button.Value
                Case tbrPressed
                    picContents.Visible = True
                Case tbrUnpressed
                    picContents.Visible = False
            End Select
        Case "Add Order"
            '*** Display the Add Order screen
            Call ShowForm(frmOrders)
        Case "Add Contact"
            '*** Display the Add Contact screen
            Call ShowForm(frmContactsAdd)
        Case "Add Stock"
            Call ShowForm(frmStockAdd)
        Case "Amend Stock"
            '*** Display the Stock Amendment screen
            Call ShowForm(frmStockAmend)
    End Select
End Sub

Private Sub tvwContents_Click()
    
    Dim objCData As Consineer.Data
    
    Set objCData = New Consineer.Data
        
    Select Case tvwContents.SelectedItem.Key
        
        '*** Data Elements
        Case "Post Offices"
            Call ShowForm(frmPostOfficesList)
        Case "Stock"
            Call ShowForm(frmStockList)
        Case "StockAmendments"
            Call ShowForm(frmStockAmendList)
        Case "Contacts"
            Call ShowForm(frmContactsList)
        
        '*** Report Elements
        Case "DeliveryNotes"
            Call ShowForm(frmDeliveryNote)
        Case "StockLevels"
            objCData.Database = g_strDatabasePath & gc_strDatabase
            deConsineer.dbConn.ConnectionString = objCData.ConnectionString
            With rptStockLevels
                .WindowState = vbMaximized
                .Show vbModal
            End With
        Case "LowStock"
            objCData.Database = g_strDatabasePath & gc_strDatabase
            deConsineer.dbConn.ConnectionString = objCData.ConnectionString
            With rptLowStock
                .WindowState = vbMaximized
                .Show vbModal
            End With
        Case "EndOfMonthReport"
            Call ShowForm(frmReportsEndofMonth)
            
    End Select
    
    Set deConsineer = Nothing
    Set objCData = Nothing
    
End Sub
