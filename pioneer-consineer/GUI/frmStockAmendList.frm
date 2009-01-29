VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Begin VB.Form frmStockAmendList 
   Caption         =   "Stock Amendments List"
   ClientHeight    =   5745
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6105
   Icon            =   "frmStockAmendList.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5745
   ScaleWidth      =   6105
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   4680
      TabIndex        =   6
      Top             =   5280
      Width           =   1335
   End
   Begin VB.Frame frmeStockAmendments 
      Caption         =   "Stock Amendments"
      Height          =   2295
      Left            =   120
      TabIndex        =   4
      Top             =   2880
      Width           =   5895
      Begin MSDataGridLib.DataGrid dgridStockAmend 
         Height          =   1695
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Width           =   5415
         _ExtentX        =   9551
         _ExtentY        =   2990
         _Version        =   393216
         HeadLines       =   1
         RowHeight       =   15
         BeginProperty HeadFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ColumnCount     =   2
         BeginProperty Column00 
            DataField       =   ""
            Caption         =   ""
            BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
               Type            =   0
               Format          =   ""
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   2057
               SubFormatType   =   0
            EndProperty
         EndProperty
         BeginProperty Column01 
            DataField       =   ""
            Caption         =   ""
            BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
               Type            =   0
               Format          =   ""
               HaveTrueFalseNull=   0
               FirstDayOfWeek  =   0
               FirstWeekOfYear =   0
               LCID            =   2057
               SubFormatType   =   0
            EndProperty
         EndProperty
         SplitCount      =   1
         BeginProperty Split0 
            BeginProperty Column00 
            EndProperty
            BeginProperty Column01 
            EndProperty
         EndProperty
      End
   End
   Begin VB.Frame frmeStockList 
      Caption         =   "Stock List"
      Height          =   2055
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   5895
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshGridStock 
         Height          =   1455
         Left            =   240
         TabIndex        =   3
         Top             =   360
         Width           =   5415
         _ExtentX        =   9551
         _ExtentY        =   2566
         _Version        =   393216
         _NumberOfBands  =   1
         _Band(0).Cols   =   2
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Stock Amendments List"
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
      Width           =   5895
   End
End
Attribute VB_Name = "frmStockAmendList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_intStockID As Integer

Private Sub cmdClose_Click()
    frmStockAmendList.Hide
    Unload frmStockAmendList
    Set frmStockAmendList = Nothing
End Sub

Private Sub Form_Load()

    m_intStockID = -1
    
    '*** Setup the MS Flexigrid
    With mshGridStock
        .FixedCols = 0
        .FillStyle = flexFillRepeat
        .SelectionMode = flexSelectionByRow
        .AllowUserResizing = flexResizeColumns
    End With
    '*** /Setup the MS Flexigrid
    
    '*** Add Items of Stock to the Stock Combo Box
    Dim objConsineer As Consineer.Data
    
    Set objConsineer = New Consineer.Data
    Set mshGridStock.DataSource = objConsineer.GetData("SELECT ID, PartNo, Description FROM Stock", g_strDatabasePath & gc_strDatabase)

    Set objConsineer = Nothing
    '*** /Add Items of Stock to the Stock Combo Box
    
    '*** Set MS Flexigrid Column Widths
    mshGridStock.ColWidth(0) = 0
    mshGridStock.ColWidth(1) = 855
    mshGridStock.ColWidth(2) = 2600
    '*** /Set MS Flexigrid Column Widths
    
End Sub

Private Sub Form_Resize()
    If Me.WindowState <> vbMinimized Then
        If Me.Width <= 6195 Then Me.Width = 6195
        If Me.Height <= 6120 Then Me.Height = 6120
        lblBackground.Width = Me.Width - 330
        frmeStockList.Width = Me.Width - 330
        mshGridStock.Width = Me.Width - 810
        frmeStockAmendments.Width = Me.Width - 330
        frmeStockAmendments.Height = Me.Height - 3855
        dgridStockAmend.Width = Me.Width - 810
        dgridStockAmend.Height = Me.Height - 4455
        cmdClose.Left = (frmeStockAmendments.Left + frmeStockAmendments.Width) - cmdClose.Width
        cmdClose.Top = (frmeStockAmendments.Top + frmeStockAmendments.Height) + 120
    End If
End Sub

Private Sub mshGridStock_Click()
    
    Dim intID As Integer
    
    mshGridStock.Col = 0
    intID = CInt(mshGridStock.Text)
    If intID <> m_intStockID Then
        '*** New item of stock chosen - show amendments list in datagrid
        m_intStockID = intID
        Call ShowStockAmendments
    End If
    
End Sub




'**************************************************************

Private Sub ShowStockAmendments()

    Dim objConsineer As Consineer.Data
    
    Set objConsineer = New Consineer.Data
    
    Set dgridStockAmend.DataSource = objConsineer.GetData("SELECT Stock_ID, Date, Amendment, Type FROM Stock_Amendments LEFT OUTER JOIN Stock_Amendments_Type ON Stock_Amendments.AmendmentType_ID = Stock_Amendments_Type.[ID] WHERE Stock_ID = " & m_intStockID, g_strDatabasePath & gc_strDatabase)
    
    Set objConsineer = Nothing

End Sub
