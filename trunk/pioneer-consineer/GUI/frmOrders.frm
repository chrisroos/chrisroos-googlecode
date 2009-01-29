VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frmOrders 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Orders"
   ClientHeight    =   9240
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8400
   Icon            =   "frmOrders.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   9240
   ScaleWidth      =   8400
   Begin MSComCtl2.DTPicker dtOrderDate 
      Height          =   375
      Left            =   1440
      TabIndex        =   3
      Top             =   2520
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   661
      _Version        =   393216
      Format          =   59047937
      CurrentDate     =   37431
   End
   Begin VB.CommandButton cmdPlaceOrder 
      Caption         =   "Place Order"
      Height          =   375
      Left            =   6960
      TabIndex        =   11
      Top             =   8760
      Width           =   1335
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   5520
      TabIndex        =   10
      Top             =   8760
      Width           =   1335
   End
   Begin VB.Frame frmeRecipientDetails 
      Caption         =   "Recipient Details"
      Height          =   3615
      Left            =   120
      TabIndex        =   16
      Top             =   720
      Width           =   8175
      Begin VB.TextBox txtOrderAddress 
         Height          =   1335
         Left            =   5400
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   6
         Top             =   480
         Width           =   2415
      End
      Begin VB.TextBox txtDeliveryAddress 
         Height          =   1335
         Left            =   5400
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   7
         Top             =   2040
         Width           =   2415
      End
      Begin VB.CommandButton cmdSearchDeliveryAddress 
         Caption         =   "Select Delivery Address"
         Height          =   375
         Left            =   1320
         TabIndex        =   5
         Top             =   2880
         Width           =   1935
      End
      Begin VB.CheckBox chkDifferentAddress 
         Caption         =   "Send to a different Address"
         Height          =   255
         Left            =   1320
         TabIndex        =   4
         Top             =   2520
         Width           =   2295
      End
      Begin VB.CommandButton cmdSearch 
         Caption         =   "Select Order Address"
         Height          =   375
         Left            =   1320
         TabIndex        =   2
         Top             =   1200
         Width           =   1935
      End
      Begin VB.OptionButton rdoOrderFor 
         Caption         =   "Contact"
         Height          =   255
         Index           =   1
         Left            =   1320
         TabIndex        =   1
         Top             =   840
         Width           =   855
      End
      Begin VB.OptionButton rdoOrderFor 
         Caption         =   "Post Office"
         Height          =   255
         Index           =   0
         Left            =   1320
         TabIndex        =   0
         Top             =   480
         Width           =   1095
      End
      Begin VB.Label lblDeliveryAddress 
         Caption         =   "Delivery Address"
         Height          =   255
         Index           =   0
         Left            =   3960
         TabIndex        =   20
         Top             =   2040
         Width           =   1215
      End
      Begin VB.Label lblOrderAddress 
         Caption         =   "Order Address"
         Height          =   255
         Index           =   0
         Left            =   3960
         TabIndex        =   19
         Top             =   480
         Width           =   1095
      End
      Begin VB.Label lblOrderDate 
         Caption         =   "Order Date"
         Height          =   255
         Left            =   360
         TabIndex        =   18
         Top             =   1800
         Width           =   855
      End
      Begin VB.Line line 
         BorderColor     =   &H80000003&
         Index           =   0
         X1              =   3720
         X2              =   3720
         Y1              =   360
         Y2              =   3360
      End
      Begin VB.Line line 
         BorderColor     =   &H80000005&
         BorderWidth     =   2
         Index           =   1
         X1              =   3720
         X2              =   3720
         Y1              =   360
         Y2              =   3360
      End
      Begin VB.Label lblOrderFor 
         Caption         =   "Order for:"
         Height          =   255
         Left            =   360
         TabIndex        =   17
         Top             =   480
         Width           =   735
      End
   End
   Begin VB.Frame frmeOrders 
      Caption         =   "Orders"
      Height          =   1935
      Left            =   120
      TabIndex        =   13
      Top             =   6720
      Width           =   8175
      Begin MSDataGridLib.DataGrid dgridOrderItems 
         Height          =   1215
         Left            =   360
         TabIndex        =   9
         Top             =   480
         Width           =   7455
         _ExtentX        =   13150
         _ExtentY        =   2143
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
   Begin VB.Frame frmeStock 
      Caption         =   "Stock"
      Height          =   2175
      Left            =   120
      TabIndex        =   12
      Top             =   4440
      Width           =   8175
      Begin MSHierarchicalFlexGridLib.MSHFlexGrid mshGridStock 
         Bindings        =   "frmOrders.frx":0442
         Height          =   1455
         Left            =   360
         TabIndex        =   8
         Top             =   480
         Width           =   7455
         _ExtentX        =   13150
         _ExtentY        =   2566
         _Version        =   393216
         _NumberOfBands  =   1
         _Band(0).Cols   =   2
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Orders"
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
      TabIndex        =   14
      Top             =   240
      Width           =   3375
   End
   Begin VB.Label lblBackground 
      BackColor       =   &H8000000C&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H8000000C&
      Height          =   495
      Left            =   120
      TabIndex        =   15
      Top             =   120
      Width           =   8175
   End
End
Attribute VB_Name = "frmOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim Drag_StockID As String
Dim Drag_StockPartNo As String
Dim Drag_StockDescription As String

Dim OldIndex As Integer

Dim rsOrders As ADODB.Recordset
Dim rsOrders_Details As ADODB.Recordset

Dim WithEvents frm_PostOfficesSearch As frmPostOfficesSearch
Attribute frm_PostOfficesSearch.VB_VarHelpID = -1
Dim WithEvents frm_ContactsSearch As frmContactsSearch
Attribute frm_ContactsSearch.VB_VarHelpID = -1

Private Sub chkDifferentAddress_Click()
    Select Case chkDifferentAddress.Value
        Case 0
            Call ToggleDeliveryAddress(False)
        Case 1
            Call ToggleDeliveryAddress(True)
    End Select
End Sub

Private Sub cmdClose_Click()
    '*** Exit Cleanly
    frmOrders.Hide
    Unload frmOrders
    Set frmOrders = Nothing
End Sub

Private Sub cmdPlaceOrder_Click()

    Dim objCOrders As Consineer.Orders
    Dim strDate As String
    Dim blnReturn As Boolean
    
    strDate = dtOrderDate.Value
    Set objCOrders = New Consineer.Orders
    
    blnReturn = objCOrders.PlaceOrder(rsOrders, rsOrders_Details, strDate, g_strDatabasePath & gc_strDatabase)
    If blnReturn = True Then
        MsgBox "The Order was placed successfully.", vbOKOnly + vbInformation, "Consineer"
    Else
        MsgBox "The Order could not be placed at this time.  Please check the following." & vbCrLf & vbCrLf & _
                "1. You have selected either a Contact of Postoffice to send to." & vbCrLf & _
                "2. You have chosen at least one item of Stock." & vbCrLf & _
                "3. You have not selected a quantity of stock greater than available in stock.", vbOKOnly + vbInformation, "Consineer"
    End If

    Set objCOrders = Nothing

End Sub

Private Sub cmdSearch_Click()

    If rdoOrderFor(0).Value = True Then
        '*** Display Post Offices Search
        Set frm_PostOfficesSearch = New frmPostOfficesSearch
        Load frm_PostOfficesSearch
    ElseIf rdoOrderFor(1).Value = True Then
        '*** Display Contacts Search
        Set frm_ContactsSearch = New frmContactsSearch
        frm_ContactsSearch.FormType = SendTo
        Load frm_ContactsSearch
    End If

End Sub

Private Sub cmdSearchDeliveryAddress_Click()
    Set frm_ContactsSearch = New frmContactsSearch
    frm_ContactsSearch.FormType = DeliveryAddress
    Load frm_ContactsSearch
End Sub

Private Sub dgridOrderItems_BeforeColEdit(ByVal ColIndex As Integer, ByVal KeyAscii As Integer, Cancel As Integer)
    If ColIndex <> 3 Then
        Cancel = True
    ElseIf ColIndex = 3 And (KeyAscii < 48 Or KeyAscii > 57) Then
        Cancel = True
    End If
End Sub

Private Sub dgridOrderItems_DragDrop(Source As Control, X As Single, Y As Single)

    '*** Ignore the selected Item if it already exists
    With rsOrders_Details
        If .RecordCount > 0 Then
            .MoveFirst
            Do While Not .EOF
                If .Fields("Stock_ID") = Drag_StockID Then
                    MsgBox "Item already exists in order.  It cannot be added again.", vbOKOnly + vbInformation, "Consineer"
                    Exit Sub
                End If
                .MoveNext
            Loop
        End If
    End With
    '*** /Ignore the selected Item if it already exists

    '*** If we're this far then add the Stock Item to the Recordset
    rsOrders_Details.AddNew
    With rsOrders_Details
        .Fields("Stock_ID") = Drag_StockID
        .Fields("PartNo") = Drag_StockPartNo
        .Fields("Description") = Drag_StockDescription
        .Fields("Quantity") = 1
    End With
    Set dgridOrderItems.DataSource = rsOrders_Details
    '*** /If we're this far then add the Stock Item to the Recordset

End Sub

Private Sub dgridOrderItems_DragOver(Source As Control, X As Single, Y As Single, State As Integer)

    Select Case State
        Case 0
            mshGridStock.DragIcon = LoadResPicture("Icon_Drop", vbResIcon)
        Case 1
            mshGridStock.DragIcon = LoadResPicture("Icon_Drag", vbResIcon)
    End Select

End Sub

Private Sub Form_Load()
    
    '*** Ensure that the Option to Send to a Postoffice is selected
    rdoOrderFor(0).Value = True
    rdoOrderFor(1).Value = False
    '*** /Ensure that the Option to Send to a Postoffice is selected
    
    '*** Set the Date in the Date Drop Down as Today
    dtOrderDate.Value = Date
    '*** /Set the Date in the Date Drop Down as Today
    
    '*** Setup MS Flexigrid
    With mshGridStock
        .FixedCols = 0
        .FillStyle = flexFillRepeat
        .SelectionMode = flexSelectionByRow
        .AllowUserResizing = flexResizeColumns
    End With
    '*** /Setup MS Flexigrid
    
    '*** Setup Data Grid to display Selected Items
    With dgridOrderItems
        .AllowDelete = True
    End With
    '*** /Setup Data Grid to display Selected Items
    
    '*** Create the Empty Orders and Orders_Details Recordset
    Call CreateNewOrders
    Call CreateNewOrderDetails
    
    '*** Ensure that the Different Delivery Address Option is not selected
    OldIndex = 0
    chkDifferentAddress.Value = 0
    Call ToggleDeliveryAddress(False)
    '*** /Ensure that the Different Delivery Address Option is not selected

    '*** Load all of the Stock Items into the MS Flexigrid
    Dim objConsineer As Consineer.Data
    Dim intCounter As Integer

    Set objConsineer = New Consineer.Data
    Set mshGridStock.DataSource = objConsineer.GetData("SELECT [ID], [Part No], [Description], [Min Stock Level], [Current Stock Level] FROM vw_Stock_List WHERE [Current Stock Level] > 0", g_strDatabasePath & gc_strDatabase)
    For intCounter = 1 To 5
        mshGridStock.ColWidth(intCounter) = mshGridStock.Width / 5
    Next intCounter

    Set objConsineer = Nothing
    '*** /Load all of the Stock Items into the MS Flexigrid

End Sub

Private Sub frm_ContactsSearch_CloseSearch()
    frm_ContactsSearch.Hide
    Unload frm_ContactsSearch
    Set frm_ContactsSearch = Nothing
    Call ToggleModal(False)
End Sub

Private Sub frm_ContactsSearch_Selected(ByVal strID As String, ByVal intFormType As Integer)
    
    Dim objCContacts As Consineer.Contacts
    Dim rsReturn As ADODB.Recordset
    Dim strDetails As String
    Dim intID As Integer
    
    intID = CInt(strID)
            
    Set objCContacts = New Consineer.Contacts
    Set rsReturn = objCContacts.GetContactDetails(intID, g_strDatabasePath & gc_strDatabase)
    
    With rsReturn
        If Not (.BOF And .EOF) Then
            strDetails = .Fields("Title") & " " & .Fields("Forename") & " " & .Fields("Surname") & vbCrLf
            If Not IsNull(.Fields("Company")) And Trim(.Fields("Company")) <> "" Then
                strDetails = strDetails & .Fields("Company") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 1")) And Trim(.Fields("Address 1")) <> "" Then
                strDetails = strDetails & .Fields("Address 1") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 2")) And Trim(.Fields("Address 2")) <> "" Then
                strDetails = strDetails & .Fields("Address 2") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 3")) And Trim(.Fields("Address 3")) <> "" Then
                strDetails = strDetails & .Fields("Address 3") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 4")) And Trim(.Fields("Address 4")) <> "" Then
                strDetails = strDetails & .Fields("Address 4") & vbCrLf
            End If
            If Not IsNull(.Fields("PostCode")) And Trim(.Fields("PostCode")) <> "" Then
                strDetails = strDetails & .Fields("PostCode")
            End If
        Else
            strDetails = "No Details Found"
        End If
    End With
    
    Set rsReturn = Nothing
    Set objCContacts = Nothing
    
    Select Case intFormType
        Case 0
            txtOrderAddress.Text = strDetails
            rsOrders.Fields("Contact_ID") = intID
        Case 1
            txtDeliveryAddress.Text = strDetails
            rsOrders.Fields("Delivery_ID") = intID
    End Select

End Sub

Private Sub frm_PostOfficesSearch_CloseSearch()
    frm_PostOfficesSearch.Hide
    Unload frm_PostOfficesSearch
    Set frm_PostOfficesSearch = Nothing
    Call ToggleModal(False)
End Sub

Private Sub frm_PostOfficesSearch_Selected(ByVal strID As String)
    
    Dim objCPostOffices As Consineer.PostOffices
    Dim rsReturn As ADODB.Recordset
    Dim strDetails As String
    Dim intID As Integer
    
    intID = CInt(strID)
            
    Set objCPostOffices = New Consineer.PostOffices
    Set rsReturn = objCPostOffices.GetPostOfficeDetails(intID, g_strDatabasePath & gc_strDatabase)
    
    With rsReturn
        If Not (.BOF And .EOF) Then
            strDetails = "FAD: " & .Fields("FAD") & vbCrLf
            If Not IsNull(.Fields("PostOffice")) And Trim(.Fields("PostOffice")) <> "" Then
                strDetails = strDetails & .Fields("PostOffice") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 1")) And Trim(.Fields("Address 1")) <> "" Then
                strDetails = strDetails & .Fields("Address 1") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 2")) And Trim(.Fields("Address 2")) <> "" Then
                strDetails = strDetails & .Fields("Address 2") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 3")) And Trim(.Fields("Address 3")) <> "" Then
                strDetails = strDetails & .Fields("Address 3") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 4")) And Trim(.Fields("Address 4")) <> "" Then
                strDetails = strDetails & .Fields("Address 4") & vbCrLf
            End If
            If Not IsNull(.Fields("Address 5")) And Trim(.Fields("Address 5")) <> "" Then
                strDetails = strDetails & .Fields("Address 5") & vbCrLf
            End If
            If Not IsNull(.Fields("PostCode")) And Trim(.Fields("PostCode")) <> "" Then
                strDetails = strDetails & .Fields("PostCode")
            End If
        Else
            strDetails = "No Details Found"
        End If
    End With
    
    Set rsReturn = Nothing
    Set objCPostOffices = Nothing
    
    txtOrderAddress.Text = strDetails
    rsOrders.Fields("Postoffice_ID") = CInt(strID)
    
End Sub

Private Sub mshGridStock_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    mshGridStock.Col = 0
    Drag_StockID = mshGridStock.Text
    mshGridStock.Col = 1
    Drag_StockPartNo = mshGridStock.Text
    mshGridStock.Col = 2
    Drag_StockDescription = mshGridStock.Text
    
    mshGridStock.Drag vbBeginDrag
    mshGridStock.DragIcon = LoadResPicture("Icon_Drag", vbResIcon)

End Sub

Private Sub rdoOrderFor_Click(Index As Integer)

    If Index <> OldIndex Then
        '*** User has changed from either PostOffice to Contact or Vice Versa
        txtOrderAddress.Text = vbNullString
        rsOrders.Fields("PostOffice_ID") = 0
        rsOrders.Fields("Contact_ID") = 0
    End If
    OldIndex = Index

End Sub




'*************************************************************

Private Sub CreateNewOrders()
    
    Set rsOrders = New ADODB.Recordset
    With rsOrders.Fields
        .Append "PostOffice_ID", adInteger
        .Append "Contact_ID", adInteger
        .Append "Delivery_ID", adInteger
    End With

    With rsOrders
        .Open
        .AddNew
    End With
    
End Sub

Private Sub CreateNewOrderDetails()

    Set rsOrders_Details = New ADODB.Recordset
    With rsOrders_Details.Fields
        .Append "Stock_ID", adInteger
        .Append "PartNo", adChar, 10
        .Append "Description", adChar, 30
        .Append "Quantity", adInteger
    End With
    rsOrders_Details.Open

End Sub

Private Sub ToggleDeliveryAddress(ByVal blnEnabled As Boolean)
    If blnEnabled = False Then
        txtDeliveryAddress.Text = vbNullString
        rsOrders.Fields("Delivery_ID") = 0
    End If
    cmdSearchDeliveryAddress.Enabled = blnEnabled
End Sub

Private Sub txtDeliveryAddress_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

Private Sub txtOrderAddress_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub
