VERSION 5.00
Begin VB.Form frmStockAdd 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Add Stock"
   ClientHeight    =   4680
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4080
   Icon            =   "frmStockAdd.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4680
   ScaleWidth      =   4080
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   2640
      TabIndex        =   7
      Top             =   4200
      Width           =   1335
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   1200
      TabIndex        =   6
      Top             =   4200
      Width           =   1335
   End
   Begin VB.Frame frmeAddStock 
      Caption         =   "Stock Details"
      Height          =   3375
      Left            =   120
      TabIndex        =   10
      Top             =   720
      Width           =   3855
      Begin VB.TextBox txtMinimumStockLevel 
         Height          =   285
         Left            =   1920
         TabIndex        =   5
         Top             =   2760
         Width           =   1695
      End
      Begin VB.TextBox txtDeliveryCost 
         Height          =   285
         Left            =   1920
         TabIndex        =   4
         Top             =   2280
         Width           =   1695
      End
      Begin VB.TextBox txtManagementFee 
         Height          =   285
         Left            =   1920
         TabIndex        =   3
         Top             =   1800
         Width           =   1695
      End
      Begin VB.TextBox txtItemCost 
         Height          =   285
         Left            =   1920
         TabIndex        =   2
         Top             =   1320
         Width           =   1695
      End
      Begin VB.TextBox txtDescription 
         Height          =   285
         Left            =   1920
         TabIndex        =   1
         Top             =   840
         Width           =   1695
      End
      Begin VB.TextBox txtPartNo 
         Height          =   285
         Left            =   1920
         TabIndex        =   0
         Top             =   360
         Width           =   1695
      End
      Begin VB.Label lblMinimumStockLevel 
         Alignment       =   1  'Right Justify
         Caption         =   "Minimum Stock Level"
         Height          =   255
         Left            =   120
         TabIndex        =   16
         Top             =   2760
         Width           =   1575
      End
      Begin VB.Label lblDeliveryCost 
         Alignment       =   1  'Right Justify
         Caption         =   "Delivery Cost"
         Height          =   255
         Left            =   720
         TabIndex        =   15
         Top             =   2280
         Width           =   975
      End
      Begin VB.Label lblManagementFee 
         Alignment       =   1  'Right Justify
         Caption         =   "Management Fee"
         Height          =   255
         Left            =   360
         TabIndex        =   14
         Top             =   1800
         Width           =   1335
      End
      Begin VB.Label lblItemCost 
         Alignment       =   1  'Right Justify
         Caption         =   "Item Cost"
         Height          =   255
         Left            =   960
         TabIndex        =   13
         Top             =   1320
         Width           =   735
      End
      Begin VB.Label lblDescription 
         Alignment       =   1  'Right Justify
         Caption         =   "Description"
         Height          =   255
         Left            =   840
         TabIndex        =   12
         Top             =   840
         Width           =   855
      End
      Begin VB.Label lblPartNo 
         Alignment       =   1  'Right Justify
         Caption         =   "Part No"
         Height          =   255
         Left            =   1080
         TabIndex        =   11
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Add Stock"
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
      TabIndex        =   8
      Top             =   240
      Width           =   3375
   End
   Begin VB.Label lblBackground 
      BackColor       =   &H8000000C&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H8000000C&
      Height          =   495
      Left            =   120
      TabIndex        =   9
      Top             =   120
      Width           =   3855
   End
End
Attribute VB_Name = "frmStockAdd"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    frmStockAdd.Hide
    Unload frmStockAdd
    Set frmStockAdd = Nothing
End Sub
