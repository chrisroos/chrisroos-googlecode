VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frmStockList 
   Caption         =   "Stock List"
   ClientHeight    =   3240
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4065
   Icon            =   "frmStockList.frx":0000
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   3240
   ScaleWidth      =   4065
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshGrid 
      Height          =   2415
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   3855
      _ExtentX        =   6800
      _ExtentY        =   4260
      _Version        =   393216
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Stock"
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
      Width           =   3855
   End
End
Attribute VB_Name = "frmStockList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()

    '*** Setup MS Flexigrid Control
    With mshGrid
        .FixedCols = 0
        .FillStyle = flexFillRepeat
        .SelectionMode = flexSelectionByRow
        .AllowUserResizing = flexResizeColumns
    End With
    '*** /Setup MS Flexigrid Control
    
    '*** Populate MS Flexigrid Control
    Dim objConsineer As Consineer.Data
    
    Set objConsineer = New Consineer.Data
    Set mshGrid.DataSource = objConsineer.GetData("vw_Stock_List", g_strDatabasePath & gc_strDatabase)
    
    Set objConsineer = Nothing
    '*** /Populate MS Flexigrid Control
    
End Sub

Private Sub Form_Resize()
    '*** Resize all elements on the form
    If Me.WindowState <> vbMinimized Then
        If frmMain.Width >= 10000 And frmMain.Height >= 7000 Then
            If Me.Width <= 4185 Then Me.Width = 4185
            If Me.Height <= 3630 Then Me.Height = 3630
            lblBackground.Width = Me.Width - 330
            mshGrid.Width = Me.Width - 330
            mshGrid.Height = Me.Height - 1215
        End If
    End If
End Sub
