VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frmReportsEndofMonth 
   Caption         =   "End of Month Report"
   ClientHeight    =   6360
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6600
   Icon            =   "frmReportsEndofMonth.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6360
   ScaleWidth      =   6600
   Begin VB.Frame frmeReport 
      Caption         =   "Report"
      Height          =   3735
      Left            =   120
      TabIndex        =   8
      Top             =   2520
      Width           =   6375
      Begin VB.CommandButton cmdClose 
         Caption         =   "Close"
         Height          =   375
         Left            =   3240
         TabIndex        =   13
         Top             =   3120
         Width           =   1335
      End
      Begin VB.CommandButton cmdExport 
         Caption         =   "Export"
         Height          =   375
         Left            =   4680
         TabIndex        =   10
         Top             =   3120
         Width           =   1335
      End
      Begin MSComctlLib.ListView lvwReportOutput 
         Height          =   2535
         Left            =   360
         TabIndex        =   9
         Top             =   480
         Width           =   5655
         _ExtentX        =   9975
         _ExtentY        =   4471
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label lblResults 
         Height          =   255
         Index           =   1
         Left            =   1200
         TabIndex        =   12
         Top             =   3120
         Width           =   1455
      End
      Begin VB.Label lblResults 
         Caption         =   "Results:"
         Height          =   255
         Index           =   0
         Left            =   360
         TabIndex        =   11
         Top             =   3120
         Width           =   615
      End
   End
   Begin VB.Frame frmeReportOptions 
      Caption         =   "Report Options"
      Height          =   1695
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   6375
      Begin VB.CommandButton cmdReport 
         Caption         =   "Display Report"
         Height          =   375
         Left            =   2880
         TabIndex        =   7
         Top             =   1080
         Width           =   1335
      End
      Begin MSComCtl2.DTPicker dtStartDate 
         Height          =   375
         Left            =   1320
         TabIndex        =   3
         Top             =   480
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   661
         _Version        =   393216
         Format          =   59113473
         CurrentDate     =   37497
      End
      Begin MSComCtl2.DTPicker dtEndDate 
         Height          =   375
         Left            =   1320
         TabIndex        =   4
         Top             =   1080
         Width           =   1335
         _ExtentX        =   2355
         _ExtentY        =   661
         _Version        =   393216
         Format          =   59113473
         CurrentDate     =   37497
      End
      Begin VB.Label lblStartDate 
         Caption         =   "Start Date"
         Height          =   255
         Left            =   360
         TabIndex        =   6
         Top             =   480
         Width           =   855
      End
      Begin VB.Label lblEndDate 
         Caption         =   "End Date"
         Height          =   255
         Left            =   360
         TabIndex        =   5
         Top             =   1080
         Width           =   735
      End
   End
   Begin VB.Label lblTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "End of Month Report"
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
      Width           =   6375
   End
End
Attribute VB_Name = "frmReportsEndofMonth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdClose_Click()
    frmReportsEndofMonth.Hide
    Unload frmReportsEndofMonth
    Set frmReportsEndofMonth = Nothing
End Sub

Private Sub cmdExport_Click()

    Dim rsReport As ADODB.Recordset
    Dim strOutput As String
    Dim lngCounter As Long
    Dim dblTotalLineItemCost As Double
    Dim dblItemCostTotal As Double, dblDeliveryCostTotal As Double, dblManagementFeeTotal As Double
    Dim aReport()
    
    Set rsReport = EndOfMonthReport(dtStartDate.Value, dtEndDate.Value)

    lngCounter = 0
    ReDim Preserve aReport(lngCounter)
    aReport(lngCounter) = "FAD, Company, Address 1, Address 2, Address 3, Address 4, Address 5, Postcode, Date, Part No, Description, Quantity, Item Cost, Management Fee, Delivery Cost, Total"
    lngCounter = 1

    With rsReport
    
        If Not (.BOF Or .EOF) Then
            .MoveFirst
            Do While Not .EOF
                ReDim Preserve aReport(lngCounter)
                dblTotalLineItemCost = 0
                dblTotalLineItemCost = (.Fields.Item("ManagementFee") + .Fields.Item("DeliveryCost")) * .Fields.Item("Quantity")
                dblItemCostTotal = dblItemCostTotal + .Fields.Item("ItemCost")
                dblDeliveryCostTotal = dblDeliveryCostTotal + .Fields.Item("DeliveryCost")
                dblManagementFeeTotal = dblManagementFeeTotal + .Fields.Item("ManagementFee")
                aReport(lngCounter) = .Fields.Item("FAD") & Chr(44) & .Fields.Item("Company") & Chr(44) & _
                                    .Fields.Item("Address1") & Chr(44) & .Fields.Item("Address2") & Chr(44) & _
                                    .Fields.Item("Address3") & Chr(44) & .Fields.Item("Address4") & Chr(44) & _
                                    .Fields.Item("Address5") & Chr(44) & .Fields.Item("PostCode") & Chr(44) & _
                                    .Fields.Item("Date") & Chr(44) & .Fields.Item("PartNo") & Chr(44) & _
                                    .Fields.Item("Description") & Chr(44) & .Fields.Item("Quantity") & Chr(44) & _
                                    .Fields.Item("ItemCost") & Chr(44) & .Fields.Item("ManagementFee") & Chr(44) & _
                                    .Fields.Item("DeliveryCost") & Chr(44) & dblTotalLineItemCost
                lngCounter = lngCounter + 1
                .MoveNext
            Loop
            lngCounter = lngCounter + 1
            ReDim Preserve aReport(lngCounter)
            aReport(lngCounter) = ", , , , , , , , , , , , " & dblItemCostTotal & Chr(44) & dblManagementFeeTotal & Chr(44) & dblDeliveryCostTotal
            strOutput = Join(aReport, vbCrLf)
            Open g_strReportPath & Format(Now(), "yyyymmdd hhmmss") & " Monthly Report.csv" For Output As #1
                Print #1, strOutput
            Close #1
            Erase aReport
        End If

    End With
    
    Set rsReport = Nothing
    
    MsgBox "Report exported to " & g_strReportPath & Format(Now(), "yyyymmdd hhmmss") & " Monthly Report.csv", vbOKOnly + vbInformation, "Consineer"

End Sub

Private Sub cmdReport_Click()

    Dim rsReport As ADODB.Recordset
    Dim lngCounter As Long
    
    Set rsReport = EndOfMonthReport(dtStartDate.Value, dtEndDate.Value)
    
    lngCounter = 1
    
    With lvwReportOutput
        .FullRowSelect = True
        .View = lvwReport
        .ColumnHeaders.Clear
        .ListItems.Clear
        .ColumnHeaders.Add 1, "FAD", "FAD", .Width / 15
        .ColumnHeaders.Add 2, "Company", "Company", .Width / 15
        .ColumnHeaders.Add 3, "Address1", "Address 1", .Width / 15
        .ColumnHeaders.Add 4, "Address2", "Address 2", .Width / 15
        .ColumnHeaders.Add 5, "Address3", "Address 3", .Width / 15
        .ColumnHeaders.Add 6, "Address4", "Address 4", .Width / 15
        .ColumnHeaders.Add 7, "Address5", "Address 5", .Width / 15
        .ColumnHeaders.Add 8, "PostCode", "PostCode", .Width / 15
        .ColumnHeaders.Add 9, "Date", "Date", .Width / 15
        .ColumnHeaders.Add 10, "PartNo", "Part No.", .Width / 15
        .ColumnHeaders.Add 11, "Description", "Description", .Width / 15
        .ColumnHeaders.Add 12, "Quantity", "Quantity", .Width / 15
        .ColumnHeaders.Add 13, "ItemCost", "Item Cost", .Width / 15
        .ColumnHeaders.Add 14, "ManagementFee", "Management Fee", .Width / 15
        .ColumnHeaders.Add 15, "DeliveryCost", "Delivery Cost", .Width / 15
    End With
    
    With rsReport
        If Not .BOF And Not .EOF Then
            .MoveFirst
            Do While Not .EOF
                lvwReportOutput.ListItems.Add lngCounter, "ID" & lngCounter, .Fields.Item("FAD")
                lvwReportOutput.ListItems(lngCounter).SubItems(1) = IIf(IsNull(.Fields.Item("Company")), "", .Fields.Item("Company"))
                lvwReportOutput.ListItems(lngCounter).SubItems(2) = IIf(IsNull(.Fields.Item("Address1")), "", .Fields.Item("Address1"))
                lvwReportOutput.ListItems(lngCounter).SubItems(3) = IIf(IsNull(.Fields.Item("Address2")), "", .Fields.Item("Address2"))
                lvwReportOutput.ListItems(lngCounter).SubItems(4) = IIf(IsNull(.Fields.Item("Address3")), "", .Fields.Item("Address3"))
                lvwReportOutput.ListItems(lngCounter).SubItems(5) = IIf(IsNull(.Fields.Item("Address4")), "", .Fields.Item("Address4"))
                lvwReportOutput.ListItems(lngCounter).SubItems(6) = IIf(IsNull(.Fields.Item("Address5")), "", .Fields.Item("Address5"))
                lvwReportOutput.ListItems(lngCounter).SubItems(7) = IIf(IsNull(.Fields.Item("PostCode")), "", .Fields.Item("PostCode"))
                lvwReportOutput.ListItems(lngCounter).SubItems(8) = IIf(IsNull(.Fields.Item("Date")), "", .Fields.Item("Date"))
                lvwReportOutput.ListItems(lngCounter).SubItems(9) = IIf(IsNull(.Fields.Item("PartNo")), "", .Fields.Item("PartNo"))
                lvwReportOutput.ListItems(lngCounter).SubItems(10) = IIf(IsNull(.Fields.Item("Description")), "", .Fields.Item("Description"))
                lvwReportOutput.ListItems(lngCounter).SubItems(11) = IIf(IsNull(.Fields.Item("Quantity")), "", .Fields.Item("Quantity"))
                lvwReportOutput.ListItems(lngCounter).SubItems(12) = IIf(IsNull(.Fields.Item("ItemCost")), "", .Fields.Item("ItemCost"))
                lvwReportOutput.ListItems(lngCounter).SubItems(13) = IIf(IsNull(.Fields.Item("ManagementFee")), "", .Fields.Item("ManagementFee"))
                lvwReportOutput.ListItems(lngCounter).SubItems(14) = IIf(IsNull(.Fields.Item("DeliveryCost")), "", .Fields.Item("DeliveryCost"))
                lngCounter = lngCounter + 1
                .MoveNext
            Loop
        Else
            lvwReportOutput.ListItems.Add lngCounter, "ID" & lngCounter, "No Results Found"
        End If
    End With
    
    lblResults(1).Caption = lngCounter - 1
    
    Set rsReport = Nothing

End Sub

Private Sub Form_Load()
    
    Dim l_dtStartDate As Date, l_dtEndDate As String
    
    l_dtStartDate = Year(Now) & "-" & Month(Now) & "-" & 1
    l_dtEndDate = Date
    
    dtStartDate.Value = l_dtStartDate
    dtEndDate.Value = l_dtEndDate
    
End Sub

Private Sub Form_Resize()

    If Me.WindowState <> vbMinimized Then
        If Me.Height <= 6795 Then Me.Height = 6795
        If Me.Width <= 6720 Then Me.Width = 6720
        lblBackground.Width = Me.Width - 345
        frmeReportOptions.Width = Me.Width - 345
        frmeReport.Height = Me.Height - 3060
        frmeReport.Width = Me.Width - 345
        lvwReportOutput.Height = Me.Height - 4260
        lvwReportOutput.Width = Me.Width - 1065
        cmdExport.Top = lvwReportOutput.Top + lvwReportOutput.Height + 105
        cmdExport.Left = lvwReportOutput.Left + lvwReportOutput.Width - cmdExport.Width
        cmdClose.Top = lvwReportOutput.Top + lvwReportOutput.Height + 105
        cmdClose.Left = lvwReportOutput.Left + lvwReportOutput.Width - (cmdExport.Width + cmdClose.Width + 105)
        lblResults(0).Top = lvwReportOutput.Top + lvwReportOutput.Height + 105
        lblResults(1).Top = lvwReportOutput.Top + lvwReportOutput.Height + 105
    End If

End Sub
