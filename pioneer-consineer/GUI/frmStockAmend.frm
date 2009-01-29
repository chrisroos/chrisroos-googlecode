VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frmStockAmend 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Stock Amendments"
   ClientHeight    =   7080
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4560
   Icon            =   "frmStockAmend.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7080
   ScaleWidth      =   4560
   Begin VB.Frame frmeStockList 
      Caption         =   "Stock List"
      Height          =   2655
      Left            =   120
      TabIndex        =   12
      Top             =   720
      Width           =   4335
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshGridStock 
         Height          =   2055
         Left            =   240
         TabIndex        =   0
         Top             =   360
         Width           =   3855
         _ExtentX        =   6800
         _ExtentY        =   3625
         _Version        =   393216
         _NumberOfBands  =   1
         _Band(0).Cols   =   2
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   1680
      TabIndex        =   4
      Top             =   6600
      Width           =   1335
   End
   Begin VB.CommandButton cmdAmend 
      Caption         =   "Amend"
      Height          =   375
      Left            =   3120
      TabIndex        =   5
      Top             =   6600
      Width           =   1335
   End
   Begin VB.Frame frmeStock 
      Caption         =   "Amend Stock Quantity"
      Height          =   3015
      Left            =   120
      TabIndex        =   8
      Top             =   3480
      Width           =   4335
      Begin MSComCtl2.DTPicker dtDate 
         Height          =   375
         Left            =   1560
         TabIndex        =   16
         Top             =   960
         Width           =   1815
         _ExtentX        =   3201
         _ExtentY        =   661
         _Version        =   393216
         Format          =   59047937
         CurrentDate     =   37497
      End
      Begin VB.ComboBox cboReason 
         Height          =   315
         Left            =   1560
         Style           =   2  'Dropdown List
         TabIndex        =   14
         Top             =   1920
         Width           =   1815
      End
      Begin VB.ComboBox cboAction 
         Height          =   315
         Left            =   1560
         Style           =   2  'Dropdown List
         TabIndex        =   2
         Top             =   1440
         Width           =   1815
      End
      Begin VB.TextBox txtQuantity 
         Height          =   285
         Left            =   1560
         TabIndex        =   3
         Top             =   2400
         Width           =   1095
      End
      Begin VB.Label lblDate 
         Caption         =   "Date"
         Height          =   255
         Left            =   360
         TabIndex        =   15
         Top             =   960
         Width           =   375
      End
      Begin VB.Label lblReason 
         Caption         =   "Reason"
         Height          =   255
         Left            =   360
         TabIndex        =   13
         Top             =   1920
         Width           =   615
      End
      Begin VB.Label lblStockItem 
         BackColor       =   &H80000009&
         BorderStyle     =   1  'Fixed Single
         Height          =   285
         Index           =   1
         Left            =   1560
         TabIndex        =   1
         Top             =   480
         Width           =   2535
      End
      Begin VB.Label Label1 
         Caption         =   "Action"
         Height          =   255
         Left            =   360
         TabIndex        =   11
         Top             =   1440
         Width           =   495
      End
      Begin VB.Label lblQuantity 
         Caption         =   "Quantity"
         Height          =   255
         Left            =   360
         TabIndex        =   10
         Top             =   2400
         Width           =   615
      End
      Begin VB.Label lblStockItem 
         Caption         =   "Stock Item"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   9
         Top             =   480
         Width           =   855
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Amend Stock Levels"
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
      Width           =   3495
   End
   Begin VB.Label lblBackground 
      BackColor       =   &H8000000C&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H8000000C&
      Height          =   495
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   4335
   End
End
Attribute VB_Name = "frmStockAmend"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_intStockID As Integer

Private Sub cmdAmend_Click()

    Dim objCStock As Consineer.Stock
    Dim strQuantity As String, strDate As String
    Dim blnReturn As Boolean, blnForce As Boolean
    Dim intStockID As Integer, intAction As Integer, intQuantity As Integer
    Dim intAmendmentType As Integer
    
    intStockID = m_intStockID
    intAction = cboAction.ListIndex
    If cboReason.ListIndex <> -1 Then intAmendmentType = cboReason.ItemData(cboReason.ListIndex) Else intAmendmentType = -1
    strDate = dtDate.Value
    strQuantity = Trim(txtQuantity.Text)
    
    If Not (intStockID = -1 Or intAction = -1 Or intAmendmentType = -1 Or strQuantity = vbNullString) Then
    
        Select Case intAction
            Case 0
                '*** Negative
                intQuantity = -CInt(strQuantity)
            Case 1
                '*** Positive
                intQuantity = CInt(strQuantity)
                blnForce = True
        End Select
        
        Set objCStock = New Consineer.Stock
        blnReturn = objCStock.AmendStock(intStockID, intQuantity, intAmendmentType, strDate, blnForce, g_strDatabasePath & gc_strDatabase)
        Set objCStock = Nothing
        
        If blnReturn = True Then
            MsgBox "The Stock Level was updated successfully.", vbOKOnly + vbInformation, "Consineer"
        Else
            MsgBox "The action requested was not performed due to insufficient stock levels", vbOKOnly + vbInformation, "Consineer"
        End If
    
    Else
        MsgBox "You must enter a Stock Item, an Action and a Quantity in order to Amend the Stock", vbOKOnly + vbInformation, "Consineer"
    End If

End Sub

Private Sub cmdClose_Click()
    frmStockAmend.Hide
    Unload frmStockAmend
    Set frmStockAmend = Nothing
End Sub

Private Sub Form_Load()

    Dim objConsineer As Consineer.Data
    
    Set objConsineer = New Consineer.Data
    
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
    Set mshGridStock.DataSource = objConsineer.GetData("SELECT ID, PartNo, Description FROM Stock", g_strDatabasePath & gc_strDatabase)
    '*** /Add Items of Stock to the Stock Combo Box
    
    '*** Add Reasons to Drop Down List
    Dim rsReason As ADODB.Recordset
    
    Set rsReason = objConsineer.GetData("vw_Stock_AmendmentTypes", g_strDatabasePath & gc_strDatabase)
    With rsReason
        If Not .BOF And Not .EOF Then
            .MoveFirst
            Do While Not .EOF
                cboReason.AddItem Trim(.Fields("Type"))
                cboReason.ItemData(cboReason.NewIndex) = .Fields("ID")
                .MoveNext
            Loop
        Else
            cboReason.AddItem "Generic Reason"
        End If
    End With
    '*** /Add Reasons to Drop Down List

    '*** Set MS Flexigrid Column Widths
    mshGridStock.ColWidth(0) = 0
    mshGridStock.ColWidth(1) = 855
    mshGridStock.ColWidth(2) = 2600
    '*** /Set MS Flexigrid Column Widths
        
    '*** Add Action List to Combo Box
    With cboAction
        .AddItem "Reduce Stock"
        .AddItem "Increase Stock"
    End With
    '*** /Add Action List to Combo Box
    
    '*** Set Date Control to Today's Date
    dtDate.Value = Date
    
    Set objConsineer = Nothing
    
End Sub

Private Sub mshGridStock_Click()
    
    Dim intID As Integer
    Dim strPartNo As String, strDescription As String
    
    mshGridStock.Col = 0
    intID = CInt(mshGridStock.Text)
    m_intStockID = intID
    mshGridStock.Col = 1
    strPartNo = Trim(mshGridStock.Text)
    mshGridStock.Col = 2
    strDescription = Trim(mshGridStock.Text)
    
    lblStockItem(1).Caption = strPartNo & "   " & strDescription
    
End Sub

Private Sub txtQuantity_KeyPress(KeyAscii As Integer)
    If (KeyAscii < 48 Or KeyAscii > 57) And KeyAscii <> 8 Then KeyAscii = 0
End Sub

