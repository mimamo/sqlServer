USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertAppSeed]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure  select * from tAppSession
-- exec spConvertAppSeed
CREATE PROCEDURE [dbo].[spConvertAppSeed]
(
	@LoadBeta int = 0
)
AS


/*
|| When      Who Rel      What
|| 5/28/14   CRG 10.5.8.0 Added Meeting group
|| 6/10/14   CRG 10.5.8.1 Added Timeline settings to the myTasks group
|| 6/12/14   RLB 10.5.8.1 Added Miscellaneous Cost grid session
|| 6/13/14   MAS 10.5.8.1 Changed the case of the columns for MiscCost and Expenses
|| 6/23/14   QMD 10.5.8.1 Added my tasks setting for assigning other peoples tasks
|| 7/31/14   QMD 10.5.8.2 Changed user.today to today.creative.
|| 10/27/14  MAS 10.5.8.5 Changed user.accountManager to today.accountmanager
|| 11/07/14  MAS 10.5.8.6 Added Account Manager Today section
|| 11/12/14  MAS 10.5.8.6 Added Project Setup for the print options
|| 12/18/14  MAS 10.5.8.7 Added Global Search options
|| 01/22/15  RLB 10.5.8.8 Added Sales Dashboard options
|| 01/22/14  MAS 10.5.8.8 Added Credit Card Connector options
|| 01/23/15  CRG 10.5.8.8 Added TimeEntry group
|| 02/12/15  GWG 10.5.8.9 Added menu for sales dashboard and changed action on today.sales
|| 02/13/15  RLB 10.5.8.9 Added open opps to sales dash
|| 03/9/15   GWG 10.5.9.0 Tweaked the reset user settings option on some areas.
*/

Delete tAppSettingGroup
Delete tAppSetting

/*************************************************************************************************************************
My Tasks
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('myTasks', 'My Tasks Settings', '', 1)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'H1', 0, 'My Task Options', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, Required) 
Values ('myTasks', 'DateOption', 1, 'Date Range', '1', 'Due on or before a week from Today', 'lookup', 'Due on or before Today:0|Due on or before a week from Today:1|Due on or before 2 weeks from Today:2|Start on or before Today:3|Start on or before a week from Today:4|Start on or before 2 weeks from Today:5|All:6', NULL, NULL, 1)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'OpenToDo', 2, 'Open To Do Items Only', '0', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'PredCompOnly', 3, 'Completed Predecessors Only', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'MoreTasks', 4, 'Assign New Tasks', '1', NULL, 'checkbox', NULL, NULL, 'Allow users to assign tasks to themselves')
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, VisibleField) 
Values ('myTasks', 'AssignOtherPeoplesTasks', 5, 'Assign myself to other people''s tasks', '0', NULL, 'checkbox', NULL, NULL, 'Allow users to assign others peoples tasks to themselves', 'MoreTasks')
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'ProjectType', 6, 'Project Type', '0', NULL, 'lookup', NULL, 'lookup.ProjectType', NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'H2', 7, 'Display Options', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'GroupBy', 8, 'Group By', 'PlanComplete', 'Due Date', 'lookup', 'No Grouping:NoGrouping|Priority:PriorityName|Project:ProjectFullName|Campaign:CampaignFullName|Client:ClientFullName|Task Name:TaskName|Task Type:TaskTypeDesc|Project Status:ProjectStatus|Project Type:ProjectTypeName|Account Manager:AccountManagerName|Summary Task:SummaryTaskName|Due Date:PlanComplete', NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'GroupByDir', 9, 'Group Sort Order', 'ASC', NULL, 'lookup', 'ASC|DESC', NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'SortBy', 10, 'Sort By', 'Priority', 'Priority', 'lookup', 'Project Number:ProjectNumber|Campaign ID:CampaignID|Client:ClientID|Status:TaskStatus|Priority:Priority|Task:TaskName|Task Type:TaskTypeDesc|Start Date:PlanStart|Due Date:PlanComplete|Due Time:DueBy|Percent Complete:PercComp|Account Manager:AccountManagerName|Summary Task:SummaryTaskName|Open ToDo Items:OpenToDos', NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'SortByDir', 11, 'Sort Order', 'ASC', NULL, 'lookup', 'ASC|DESC', NULL, NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'H3', 12, 'Timeline Options', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'IncludePublicMeetings', 13, 'Include Public Meetings', '1', NULL, 'checkbox', NULL, NULL, NULL)

/*
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('myTasks', 'DefaultDisplay', 6, 'Default Display Mode', '1', 'Cards', 'lookup', 'Grid:0|Cards:1', NULL, NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, CFEntity1, CFPrefix1) 
Values ('myTasks', 'Columns', 11, 'Columns', 'ProjectFullName,TaskIDName,PlanStart,PlanComplete,DueBy,RemainingHours', NULL, 'grid', 

'[{id:"PercComp", label:"Percent Comp"},
	{id:"ServiceCode", label:"Service"},
	{id:"TaskStatus", label:"Status"},
	{id:"TimesheetStatus", label:"Timesheet"},
	{id:"TaskIDName", label:"Task"},
	{id:"TaskID", label:"Task ID"},
	{id:"TaskName", label:"Task Name"},
	{id:"ProjectFullName", label:"Project"}]'

	 , NULL, NULL, 'Project', 'Project')

*/

/*************************************************************************************************************************
Meeting
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('meeting', 'Meeting Settings', '', 1)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('meeting', 'SendNotification', 1, 'Send Notifications', '0', 'Always', 'lookup', 'Always:0|Ask:1|Never:2', NULL, NULL)

/*************************************************************************************************************************
Time Entry
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('timeEntry', 'Time Entry Settings', '', 0)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('timeEntry', 'DefaultProjects', 1, 'Default Projects From Assignments', '1', NULL, 'checkbox', NULL, NULL, NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('timeEntry', 'ShowRateLevel', 2, 'Show Rate Level', '0', NULL, 'checkbox', NULL, NULL, NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('timeEntry', 'OpenExpanded', 3, 'Expand Timesheet When Opened', '0', NULL, 'checkbox', NULL, NULL, NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('timeEntry', 'H2', 4, 'Display Options', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('timeEntry', 'GroupBy', 5, 'Group By', 'PriorityName', 'Priority', 'lookup', 'Project:ProjectFullName|Priority:PriorityName|Campaign:CampaignFullName|Task Name:TaskName|Project Status:ProjectStatus|Project Type:ProjectTypeName', NULL, NULL)


/*************************************************************************************************************************
Misc Cost
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('misccosts', 'Misc Cost Settings', '', 0)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, CFEntity1, CFPrefix1) 
Values ('misccosts', 'grdMiscCostCols', 1, 'Columns', 'expenseDate,task,item,shortDescription,gridMiscCostTotalCost,gridMiscCostTotalGross', NULL, 'grid', 
'[	{id:"expenseDate", label:"Date"},
	{id:"task", label:"Task"},
	{id:"item", label:"Item"},
	{id:"shortDescription", label:"Description"},
	{id:"miscCostClass", label:"Class"},
	{id:"miscCostDepartment", label:"Department"},
	{id:"miscCostExchangeRate", label:"Exchange Rate"},
	{id:"miscCostQuantity", label:"Quantity"},
	{id:"miscCostUnitCost", label:"Unit Cost"},
	{id:"gridMiscCostTotalCost", label:"Net"},
	{id:"miscCostBillable", label:"Billable"},
	{id:"miscCostMarkup", label:"Markup"},
	{id:"misCostUnitRate", label:"Unit Rate"},
	{id:"gridMiscCostTotalGross", label:"Gross"},
	{id:"miscCostComments", label:"Comments"}
 ]'
 , NULL, NULL, NULL, NULL)
 
/*************************************************************************************************************************
Expense Report
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('expenses', 'Expense Receipt Settings', '', 0)


INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, CFEntity1, CFPrefix1) 
Values ('expenses', 'grdExpenseReceiptsCols', 1, 'Columns', 'expenseDate,project,task,item,description,actualUnitCost,actualCost,comments', NULL, 'grid', 

'[	{id:"expenseDate", label:"Date"},
	{id:"project", label:"Project"},
	{id:"task", label:"Task"},
	{id:"item", label:"Item"},
	{id:"description", label:"Description"},
	{id:"quantity", label:"Quantity"},
	{id:"actualUnitCost", label:"Unit Cost"},
	{id:"actualCost", label:"Net"},
	{id:"comments", label:"Comments"},
	{id:"billable", label:"Billable"},
	{id:"gross", label:"Total Gross"},
	{id:"markup", label:"Mark Up"},
	{id:"paperReceipt", label:"Paper Receipt"},
	{id:"taxable", label:"Tax 1"},
	{id:"taxable2", label:"Tax 2"},
	{id:"actualCostWithTaxes", label:"Total Net With taxes"},
	{id:"unitRate", label:"Unit Rate"}
 ]'
	 , NULL, NULL, NULL, NULL)

/*************************************************************************************************************************
Account Manager Today 
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('salesToday', 'Sales Person Settings', '', 0)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesToday', 'IncludePublicMeetings', 1, 'Include Public Meetings', '0', NULL, 'checkbox', NULL, NULL, NULL)

/*************************************************************************************************************************
Project Setup 
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('projectSetup', 'Project Setup Settings', '', 0)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('projectSetup', 'H2', 1, 'Printing Options', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('projectSetup', 'ShowSummaryTasksOnly', 2, 'Print Summary Tasks Only', '0', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('projectSetup', 'LargePrint', 3, 'Print With Larger Font', '0', NULL, 'checkbox', NULL, NULL, NULL)


/*************************************************************************************************************************
Sales Dashboard
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('salesDashboard', 'Dashboard Settings', '', 0)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesDashboard', 'DashboardSettings', 0, 'Dashboard Sections', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesDashboard', 'OppByStage', 1, 'Opportunity By Stage', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesDashboard', 'OppByWWP', 2, 'Opportunity By WWP', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesDashboard', 'OppTwitter', 3, 'Twitter Feeds', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesDashboard', 'NeglectedOpps', 4, 'Neglected Opportunities', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('salesDashboard', 'SalesTarget', 5, 'Sales Target', '1', NULL, 'checkbox', NULL, NULL, NULL)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, CFEntity1, CFPrefix1) 
Values ('salesDashboard', 'byStage', 1, 'Columns', 'Subject,ContactName,SaleAmount,AGI,ActivitySubject,Probability,CurrentStatus', NULL, 'grid', 
'[	{id:"Subject", label:"Subject"},
	{id:"ContactName", label:"Contact Name"},
    {id:"FolderName", label:"Folder Name"},
    {id:"DateAdded", label:"Date Added"},
    {id:"DateUpdated", label:"Date Updated"},

    {id:"SaleAmount", label:"Sale Amount"},
    {id:"Labor", label:"Labor"},
    {id:"OutsideCostsGross", label:"Production Amount"},
    {id:"OutsideCostsPerc", label:"Production Margin"},
    {id:"MediaGross", label:"Media Amount"},
    {id:"MediaPerc", label:"Media Margin"},
    {id:"AGI", label:"AGI"},

    {id:"Months", label:"Months"},

    {id:"ActivitySubject", label:"Next Activity"},
    {id:"LeadStageName", label:"Stage"},
    {id:"Probability", label:"Probability"},

    {id:"CurrentStatus", label:"Next Steps"},
    {id:"EstCloseDate", label:"Forecasted Close Date"},

    {id:"WWPCurrentLevel", label:"WWP Level"},
    {id:"WWPNeedSupplyComment", label:"Need : Supply"},
    {id:"WWPTimelineComment", label:"Has a Timeline"},
    {id:"WWPBudgetComment", label:"Has a Budget"},
    {id:"WWPDecisionMakersComment", label:"Decision Makers"}
 ]'
 , NULL, NULL, NULL, NULL)


/*************************************************************************************************************************
Global Search
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('globalSearch', 'Search Settings', '', 0)

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'H1', 0, 'Application Sections', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'ActiveProjects', 1, 'Active Projects', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'InactiveProjects', 2, 'Inactive Projects', '0', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'Meetings', 3, 'Meetings', '0', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'Activities', 4, 'Activities', '0', NULL, 'checkbox', NULL, NULL, 'Search in the activity subject only')
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'ActivityNotes', 5, 'Activity Notes', '0', NULL, 'checkbox', NULL, NULL, 'Search in the activity notes also. This can dramatically slow down searching')
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'Contacts', 6, 'Contacts', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'Companies', 7, 'Companies', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('globalSearch', 'Opportunities', 8, 'Opportunities', '0', NULL, 'checkbox', NULL, NULL, NULL)

/*************************************************************************************************************************
Credit Card Connector
**************************************************************************************************************************/
INSERT tAppSettingGroup(GroupID, Title, Rights, ResetSettings) Values('creditCardConnector', 'Credit Card Connector', '', 0)

/*
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('creditCardConnector', 'H1', 0, 'Display Options', NULL, NULL, 'sectionheader', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('creditCardConnector', 'HideClearedTransactions', 1, 'Hide Cleared Transactions', '1', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint) 
Values ('creditCardConnector', 'HideCreditTransactions', 2, 'Hide Payments', '0', NULL, 'checkbox', NULL, NULL, NULL)
INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, Required) 
Values ('creditCardConnector', 'DateOption', 3, 'Date Range', '6', 'All', 'lookup', 'Due on or before Today:0|Due on or before a week from Today:1|Due on or before 2 weeks from Today:2|Start on or before Today:3|Start on or before a week from Today:4|Start on or before 2 weeks from Today:5|All:6', NULL, NULL, 0)
*/

INSERT tAppSetting(GroupID, SessionID, DisplayOrder, Label, DefaultValue, DefaultLabel, EditorType, ValueList, LookupID, Hint, CFEntity1, CFPrefix1) 
Values ('creditCardConnector', 'grdEntriesCols', 1, 'Columns', 'transactionPostedDate,amount,payeeName,fitid,postingDate,transactionType,glCompanyID,expenseAccountNumber,billable,receipt,officeID,departmentName,project,splitProjects,task,item,class,vendor,splitVouchers,userName,memo,processedStatus,salesTax,salesTaxAmount,salesTax2,salesTax2Amount', NULL, 'grid', 

'[	{id:"transactionPostedDate", label:"Date"},
	{id:"amount", label:"Amount"},
	{id:"payeeName", label:"Payee Name"},
	{id:"fitid", label:"FITID"},
	{id:"postingDate", label:"Posting Date"},
	{id:"transactionType", label:"Transaction Type"},
	{id:"glCompanyID", label:"GL Company"},
	{id:"expenseAccountNumber", label:"Expense Account Number"},
	{id:"billable", label:"Billable"},
	{id:"receipt", label:"Receipt"},
	{id:"officeID", label:"Office"},
	{id:"departmentName", label:"Department Name"},
	{id:"project", label:"Project"},
	{id:"splitProjects", label:"Split Projects"},
	{id:"task", label:"Task"},
	{id:"item", label:"Item"},
	{id:"class", label:"Class"},
	{id:"vendor", label:"Vendor"},
	{id:"splitVouchers", label:"Split Invoices"},
	{id:"userName", label:"Charged By"},
	{id:"memo", label:"Memo"},
	{id:"processedStatus", label:"Status"},
	{id:"salesTax", label:"Sales Tax"},
	{id:"salesTaxAmount", label:"Sales Tax Amount"},
	{id:"salesTax2", label:"Sales Tax2"},
	{id:"salesTax2Amount", label:"Sales Tax2 Amount"}
 ]'
	 , NULL, NULL, NULL, NULL)



/*************************************************************************************************************************/

delete tAppMenu Where CompanyKey = 0
set identity_insert tAppMenu on

INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
Values (1, 'System', 0, 0, 0, 'Today', 'today.creative', NULL, 'i-calendar', 1, NULL, NULL)


set identity_insert tAppMenu off

if @LoadBeta = 1
BEGIN
	delete tAppMenu Where CompanyKey = 0
	set identity_insert tAppMenu on
	INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
	Values (1, 'System', 0, 0, 0, 'Creatives', NULL, NULL, 'i-opportunities', 1, NULL, NULL)
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (2, 'System', 0, 0, 1, 'Today', 'today.creative', NULL, 'i-calendar', 1, NULL, NULL)
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (3, 'System', 0, 0, 1, 'Expense Reports', 'user.expenses.dash', 'user.expenses.edit', 'i-billing', 2, 'billinguseexpenses', 'billinguseexpenses')
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (10, 'System', 0, 0, 1, 'Time Sheet', 'user.timeEntry.edit', NULL, 'i-time', 3, 'billingusetimesheet', NULL)

	INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
	Values (4, 'System', 0, 0, 0, 'Salesperson', NULL, NULL, 'i-opportunities', 2, NULL, NULL)
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (5, 'System', 0, 0, 4, 'Today', 'today.sales', NULL, 'i-calendar', 1, NULL, NULL)
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (6, 'System', 0, 0, 4, 'Dashboard', 'cm.dashboard.sales', NULL, 'i-dash', 2, NULL, NULL)
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (7, 'System', 0, 0, 4, 'Contacts', 'cm.contacts.dash', 'cm.common.add', 'i-avatar', 3, 'useContacts', 'addContacts')
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (8, 'System', 0, 0, 4, 'Companies', 'cm.companies.dash', 'cm.common.add', 'i-companies', 4, 'useCompanies', 'addCompanies')
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (9, 'System', 0, 0, 4, 'Expense Reports', 'user.expenses.dash', 'user.expenses.edit', 'i-billing', 5, 'billinguseexpenses', 'billinguseexpenses')
		INSERT tAppMenu(AppMenuKey, Entity, EntityKey, CompanyKey, FolderKey, Label, ActionID, NewActionID, Icon, DisplayOrder, RightID, NewRightID) 
		Values (11, 'System', 0, 0, 4, 'Time Sheet', 'user.timeEntry.edit', NULL, 'i-time', 6, 'billingusetimesheet', NULL)
	set identity_insert tAppMenu off

END
GO
