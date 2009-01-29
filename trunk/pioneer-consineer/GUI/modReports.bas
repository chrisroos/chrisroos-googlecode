Attribute VB_Name = "modReports"
Option Explicit

Public Function EndOfMonthReport(ByVal StartDate As String, ByVal EndDate As String) As ADODB.Recordset

    Dim objConsineer As Consineer.Data
    Dim dbConn As ADODB.Connection
    Dim rsReport As ADODB.Recordset
    
    Set objConsineer = New Consineer.Data
    Set dbConn = New ADODB.Connection
    Set rsReport = New ADODB.Recordset

    If IsDate(StartDate) Then StartDate = Format(StartDate, "yyyy-mm-dd") Else StartDate = Format(Date, "yyyy-mm-dd")
    If IsDate(EndDate) Then EndDate = Format(EndDate, "yyyy-mm-dd") Else EndDate = Format(Date, "yyyy-mm-dd")
    
    With dbConn
        objConsineer.Database = g_strDatabasePath & gc_strDatabase
        .ConnectionString = objConsineer.ConnectionString
        .CursorLocation = adUseClient
        .Open
        '*** Delete anything in the Temp Table
        .Execute ("DELETE FROM [#MonthlyReport]")
        '*** Insert Contacts Orders
        .Execute ("INSERT INTO [#monthlyreport] (Forename, Surname, FAD, Company, Address1, Address2, Address3, Address4, Address5, PostCode, [Date], Quantity, PartNo, Description, ItemCost, ManagementFee, DeliveryCost) SELECT Forename, Surname, '', Company, Address1, Address2, Address3, Address4, '', PostCode, [Date], Quantity, PartNo, Description, ItemCost, ManagementFee, DeliveryCost FROM vw_MonthlyReport_Orders_ToContacts WHERE [Date] >= #" & StartDate & "# AND [Date] <= #" & EndDate & "#")
        '*** Insert Post Office Orders
        .Execute ("INSERT INTO [#monthlyreport] (Forename, Surname, FAD, Company, Address1, Address2, Address3, Address4, Address5, PostCode, [Date], Quantity, PartNo, Description, ItemCost, ManagementFee, DeliveryCost) SELECT '', '', FAD, PostOffice, Address1, Address2, Address3, Address4, Address5, PostCode, [Date], Quantity, PartNo, Description, ItemCost, ManagementFee, DeliveryCost FROM vw_MonthlyReport_Orders_ToPostOffices WHERE [Date] >= #" & StartDate & "# AND [Date] <= #" & EndDate & "#")
    End With
    
    With rsReport
        .ActiveConnection = dbConn
        .CursorLocation = adUseClient
        .CursorType = adOpenForwardOnly
        .LockType = adLockReadOnly
        .Source = "SELECT * FROM [#MonthlyReport] ORDER BY [Date] DESC"
        .Open

    End With

    Set EndOfMonthReport = rsReport
    
    Set rsReport = Nothing
    Set dbConn = Nothing
    Set objConsineer = Nothing

End Function
