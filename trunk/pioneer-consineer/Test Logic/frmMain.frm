VERSION 5.00
Begin VB.Form frmMain 
   Caption         =   "Form1"
   ClientHeight    =   4560
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8145
   LinkTopic       =   "Form1"
   ScaleHeight     =   4560
   ScaleWidth      =   8145
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame frmeOrders 
      Caption         =   "Orders"
      Height          =   1455
      Left            =   5640
      TabIndex        =   8
      Top             =   120
      Width           =   2415
      Begin VB.CommandButton cmdPlaceOrder 
         Caption         =   "Place Order"
         Height          =   375
         Left            =   240
         TabIndex        =   9
         Top             =   360
         Width           =   1215
      End
   End
   Begin VB.Frame frmeResults 
      Caption         =   "Results"
      Height          =   2775
      Left            =   120
      TabIndex        =   6
      Top             =   1680
      Width           =   5415
      Begin VB.ListBox lstReturn 
         Height          =   2010
         Left            =   240
         TabIndex        =   7
         Top             =   480
         Width           =   4815
      End
   End
   Begin VB.Frame frmeContacts 
      Caption         =   "Contacts"
      Height          =   1455
      Left            =   3240
      TabIndex        =   1
      Top             =   120
      Width           =   2295
      Begin VB.CommandButton cmdTitles 
         Caption         =   "Titles"
         Height          =   375
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.Frame frmeStock 
      Caption         =   "Stock"
      Height          =   1455
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3015
      Begin VB.CommandButton cmdStockLevel 
         Caption         =   "Stock Level"
         Height          =   375
         Left            =   240
         TabIndex        =   4
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdAmendStock 
         Caption         =   "Amend Stock"
         Height          =   375
         Left            =   1560
         TabIndex        =   3
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdListStock 
         Caption         =   "List Stock"
         Height          =   375
         Left            =   240
         TabIndex        =   2
         Top             =   840
         Width           =   1215
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdAmendStock_Click()

    Dim objCStock As Consineer.Stock
    Dim strReturn As String
    Dim intStockID As Integer, intStockAmendment As Integer
    Dim blnReturn As Boolean
    
    Set objCStock = New Consineer.Stock
    
    '*** Get the Stock Item to Amend
    strReturn = InputBox("Please enter the ID of the Stock Item required.")
    If IsNumeric(strReturn) Then
        intStockID = CInt(strReturn)
    Else
        intStockID = 0
    End If
    
    '*** Get the level by which to Amend the stock
    strReturn = InputBox("Please enter the level by which you wish to amend the stock")
    If IsNumeric(strReturn) Then
        intStockAmendment = CInt(strReturn)
    Else
        intStockAmendment = 0
    End If
    
    blnReturn = objCStock.AmendStock(intStockID, intStockAmendment)
    If blnReturn = False Then
        MsgBox "There was an error updating the stock."
    Else
        MsgBox "The stock levels were updated successfully."
    End If
    
    Set objCStock = Nothing

End Sub

Private Sub cmdListStock_Click()

    Dim objCStock As Consineer.Stock
    Dim rsListStock As ADODB.Recordset
    
    Set objCStock = New Consineer.Stock
    Set rsListStock = objCStock.ListStock
    
    If Not rsListStock.BOF And Not rsListStock.EOF Then
        rsListStock.MoveFirst
        Do While Not rsListStock.EOF
            lstReturn.AddItem rsListStock("ID") & vbTab & rsListStock("PartNo") & _
                    rsListStock("Description") & vbTab & rsListStock("Price_ID") & _
                    rsListStock("MinStockLevel") & vbTab & rsListStock("CurrentStockLevel")
            rsListStock.MoveNext
        Loop
    Else
        MsgBox "No Stock to List"
    End If
    
    Set rsListStock = Nothing
    Set objCStock = Nothing

End Sub

Private Sub cmdPlaceOrder_Click()

    Dim objCOrders As Consineer.Orders
    
    Set objCOrders = New Consineer.Orders
    
    MsgBox objCOrders.PlaceOrder(1, 1, 0, 5)
    
    Set objCOrders = Nothing

End Sub

Private Sub cmdStockLevel_Click()

    Dim objCStock As Consineer.Stock
    Dim strReturn As String
    Dim intStockID As Integer, intStockLevel As Integer
    
    Set objCStock = New Consineer.Stock
    
    strReturn = InputBox("Please enter the ID of the Stock Item required.")
    If IsNumeric(strReturn) Then
        intStockID = CInt(strReturn)
    Else
        intStockID = 0
    End If
    
    intStockLevel = objCStock.ReturnCurrentStockLevel(intStockID)
    If intStockLevel = -32767 Then
        MsgBox "The selected item was not found in stock"
    Else
        MsgBox "Number of items remaining in stock: " & intStockLevel
    End If
    
    Set objCStock = Nothing

End Sub

Private Sub cmdTitles_Click()

    Dim objCContacts As Consineer.Contacts
    Dim rsTitles As ADODB.Recordset
    
    Set objCContacts = New Consineer.Contacts
    Set rsTitles = objCContacts.DisplayTitles
    
    If Not rsTitles.BOF And Not rsTitles.EOF Then
        rsTitles.MoveFirst
        Do While Not rsTitles.EOF
            lstReturn.AddItem rsTitles("Title")
            rsTitles.MoveNext
        Loop
    End If
    
    Set rsTitles = Nothing
    Set objCContacts = Nothing

End Sub
