VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmDeliveryNote 
   Caption         =   "Produce Delivery Note"
   ClientHeight    =   4665
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6585
   Icon            =   "frmDeliveryNote.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   4665
   ScaleWidth      =   6585
   Begin VB.CommandButton cmdSelect 
      Caption         =   "Select"
      Height          =   375
      Left            =   5160
      TabIndex        =   8
      Top             =   4200
      Width           =   1335
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   3720
      TabIndex        =   7
      Top             =   4200
      Width           =   1335
   End
   Begin VB.Frame frmeOrders 
      Caption         =   "Orders"
      Height          =   2055
      Left            =   120
      TabIndex        =   6
      Top             =   2040
      Width           =   6375
      Begin MSComctlLib.ListView lvwOrders 
         Height          =   1455
         Left            =   240
         TabIndex        =   9
         Top             =   360
         Width           =   5895
         _ExtentX        =   10398
         _ExtentY        =   2566
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.Frame frmeDisplayOptions 
      Caption         =   "Display Options"
      Height          =   1215
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   6375
      Begin VB.OptionButton rdoShowOrdersTo 
         Caption         =   "Other Contacts"
         Height          =   255
         Index           =   1
         Left            =   1680
         TabIndex        =   5
         Top             =   720
         Width           =   1455
      End
      Begin VB.OptionButton rdoShowOrdersTo 
         Caption         =   "Post Offices"
         Height          =   255
         Index           =   0
         Left            =   1680
         TabIndex        =   4
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label lblShowOrdersTo 
         Caption         =   "Show Orders To"
         Height          =   255
         Left            =   360
         TabIndex        =   3
         Top             =   360
         Width           =   1215
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Produce Delivery Note"
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
      Width           =   6375
   End
End
Attribute VB_Name = "frmDeliveryNote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private l_OldIndex As Integer

Private Sub cmdClose_Click()
    frmDeliveryNote.Hide
    Unload frmDeliveryNote
    Set frmDeliveryNote = Nothing
End Sub

Private Sub cmdSelect_Click()
    
    If lvwOrders.SelectedItem <> "No Data Found" Then
    
        Dim intOrderID As Integer
        Dim objCData As Consineer.Data
        
        intOrderID = lvwOrders.SelectedItem
        
        Set objCData = New Consineer.Data
        
        objCData.Database = g_strDatabasePath & gc_strDatabase
        deConsineer.dbConn.ConnectionString = objCData.ConnectionString

        Set objCData = Nothing

        If rdoShowOrdersTo(0).Value = True Then
            '*** Display PostOffices Delivery Note
            deConsineer.Commands("Orders_ToPostOffices").CommandType = adCmdText
            deConsineer.Commands("Orders_ToPostOffices").CommandText = ""
            deConsineer.Commands("Orders_ToPostOffices").CommandText = "SHAPE {SELECT * FROM `vw_Orders_ToPostOffices` WHERE ID = " & intOrderID & "}  AS Orders_ToPostOffices APPEND ({SELECT * FROM `vw_Orders_List` WHERE Order_ID = " & intOrderID & "} AS Orders_List RELATE 'ID' TO 'Order_ID') AS Orders_List"
            
            With rptDeliveryNote_PostOffices
                .WindowState = vbMaximized
                .Show vbModal
            End With
        ElseIf rdoShowOrdersTo(1).Value = True Then
            '*** Display Contacts Delivery Note
            deConsineer.Commands("Orders_ToContacts").CommandType = adCmdText
            deConsineer.Commands("Orders_ToContacts").CommandText = ""
            deConsineer.Commands("Orders_ToContacts").CommandText = "SHAPE {SELECT * FROM `vw_Orders_ToContacts` WHERE ID = " & intOrderID & "} AS Orders_ToContacts APPEND ({SELECT * FROM `vw_Orders_List` WHERE Order_ID = " & intOrderID & "} AS Contacts_OrderDetails RELATE 'ID' TO 'Order_ID') AS Contacts_OrderDetails"
            
            With rptDeliveryNote_Contacts
                .WindowState = vbMaximized
                .Show vbModal
            End With
        End If
    
    Else
        MsgBox "Please select an Order from the List to Proceed", vbOKOnly + vbInformation, "Consineer"
    End If
    
    Unload deConsineer
    Set deConsineer = Nothing
    
End Sub

Private Sub Form_Load()
    
    lvwOrders.FullRowSelect = True
    
    l_OldIndex = 0
    rdoShowOrdersTo(0).Value = True
    rdoShowOrdersTo(1).Value = False
    
    Call PopulateDataGrid
    
End Sub

Private Sub Form_Resize()

    Dim intCounter As Integer

    If Me.WindowState <> vbMinimized Then
        If Me.Height <= 5070 Then Me.Height = 5070
        If Me.Width <= 6705 Then Me.Width = 6705
        lblBackground.Width = Me.Width - 330
        frmeDisplayOptions.Width = Me.Width - 330
        frmeOrders.Width = Me.Width - 330
        frmeOrders.Height = Me.Height - 3015
        lvwOrders.Width = Me.Width - 810
        lvwOrders.Height = Me.Height - 3615
        cmdClose.Left = (frmeOrders.Left + frmeOrders.Width) - (cmdSelect.Width + cmdClose.Width) - 105
        cmdClose.Top = (frmeOrders.Top + frmeOrders.Height) + 105
        cmdSelect.Left = (frmeOrders.Left + frmeOrders.Width) - cmdSelect.Width
        cmdSelect.Top = (frmeOrders.Top + frmeOrders.Height) + 105
        For intCounter = 1 To 6
            lvwOrders.ColumnHeaders(intCounter).Width = lvwOrders.Width / 6
        Next intCounter
    End If
    
End Sub

Private Sub rdoShowOrdersTo_Click(Index As Integer)
    If l_OldIndex <> Index Then
        Call PopulateDataGrid
    End If
    l_OldIndex = Index
End Sub




'**************************************************************

Private Sub PopulateDataGrid()

    Dim objConsineer As Consineer.Data
    Dim rsOrders As ADODB.Recordset
    Dim lngCounter As Long
    
    Set objConsineer = New Consineer.Data
    Set rsOrders = New ADODB.Recordset
    
    lngCounter = 1
    
    If rdoShowOrdersTo(0).Value = True Then
        '*** Display Post Office Orders
        Set rsOrders = objConsineer.GetData("vw_Orders_ToPostOffices", g_strDatabasePath & gc_strDatabase)
        With lvwOrders
            .View = lvwReport
            .ColumnHeaders.Clear
            .ListItems.Clear
            .ColumnHeaders.Add 1, "ID", "ID", .Width / 6
            .ColumnHeaders.Add 2, "Date", "Date", .Width / 6
            .ColumnHeaders.Add 3, "FAD", "FAD", .Width / 6
            .ColumnHeaders.Add 4, "PostOffice", "Post Office", .Width / 6
            .ColumnHeaders.Add 5, "Address1", "Address 1", .Width / 6
            .ColumnHeaders.Add 6, "PostCode", "PostCode", .Width / 6
        End With
        With rsOrders
            If Not (.BOF And .EOF) Then
                Do While Not .EOF
                    lvwOrders.ListItems.Add lngCounter, "ID" & .Fields("ID"), .Fields("ID")
                    lvwOrders.ListItems(lngCounter).SubItems(1) = IIf(IsNull(.Fields("Date")), "", .Fields("Date"))
                    lvwOrders.ListItems(lngCounter).SubItems(2) = IIf(IsNull(.Fields("FAD")), "", .Fields("FAD"))
                    lvwOrders.ListItems(lngCounter).SubItems(3) = IIf(IsNull(.Fields("PostOffice")), "", .Fields("PostOffice"))
                    lvwOrders.ListItems(lngCounter).SubItems(4) = IIf(IsNull(.Fields("Address1")), "", .Fields("Address1"))
                    lvwOrders.ListItems(lngCounter).SubItems(5) = IIf(IsNull(.Fields("PostCode")), "", .Fields("PostCode"))
                    lngCounter = lngCounter + 1
                    .MoveNext
                Loop
            Else
                lvwOrders.ListItems.Add lngCounter, "ID", "No Data Found"
            End If
        End With
    Else
        '*** Display Other Orders
        Set rsOrders = objConsineer.GetData("vw_Orders_ToContacts", g_strDatabasePath & gc_strDatabase)
        With lvwOrders
            .View = lvwReport
            .ColumnHeaders.Clear
            .ListItems.Clear
            .ColumnHeaders.Add 1, "ID", "ID", .Width / 7
            .ColumnHeaders.Add 2, "Date", "Date", .Width / 7
            .ColumnHeaders.Add 3, "Forename", "Forename", .Width / 7
            .ColumnHeaders.Add 4, "Surname", "Surname", .Width / 7
            .ColumnHeaders.Add 5, "Company", "Company", .Width / 7
            .ColumnHeaders.Add 6, "Address1", "Address 1", .Width / 7
            .ColumnHeaders.Add 7, "PostCode", "PostCode", .Width / 7
        End With
        With rsOrders
            If Not (.BOF And .EOF) Then
                Do While Not .EOF
                    lvwOrders.ListItems.Add lngCounter, "ID" & .Fields("ID"), .Fields("ID")
                    lvwOrders.ListItems(lngCounter).SubItems(1) = .Fields("Date")
                    lvwOrders.ListItems(lngCounter).SubItems(2) = .Fields("Forename")
                    lvwOrders.ListItems(lngCounter).SubItems(3) = .Fields("Surname")
                    lvwOrders.ListItems(lngCounter).SubItems(4) = .Fields("Company")
                    lvwOrders.ListItems(lngCounter).SubItems(5) = .Fields("Address1")
                    lvwOrders.ListItems(lngCounter).SubItems(6) = .Fields("PostCode")
                    lngCounter = lngCounter + 1
                    .MoveNext
                Loop
            Else
                lvwOrders.ListItems.Add lngCounter, "ID", "No Data Found"
            End If
        End With
    End If
    
    Set rsOrders = Nothing
    Set objConsineer = Nothing

End Sub
