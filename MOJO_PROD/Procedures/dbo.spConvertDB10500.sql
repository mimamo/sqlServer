USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10500]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10500]
(
@SeedOnly tinyint = 0
)
AS


Delete tRight


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11605, 'viewLegacyFields', 'View Legacy Fields', 'admin', 'admin', 25, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90901, 'prjEditTeam', 'Edit the Project Team (Workamajig Only)', 'project', 'admin', 52, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10100, 'adminsetup', 'Maintain Setup Information', 'admin', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10101, 'adminsetup_acctinfo', '---- Edit Account Information', 'admin', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10102, 'adminsetup_globaloptions', '---- Edit Global Options', 'admin', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10103, 'adminsetup_dashboard', '---- Edit Dashboards', 'admin', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10104, 'adminsetup_GLSettings', '---- Edit GL Settings', 'admin', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10105, 'adminsetup_CM', '---- Edit Contact Management options', 'admin', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10106, 'adminsetup_timeoptions', '---- Edit Time, Expense & Billing options', 'admin', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10107, 'adminsetup_media', '---- Edit Media Setup options', 'admin', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10108, 'adminsetup_specsheet', '---- Edit Spec Sheets', 'admin', 'admin', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10109, 'adminsetup_projrequest', '---- Edit Project Requests', 'admin', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10110, 'adminsetup_forms', '---- Edit Tracking Forms', 'admin', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10111, 'adminsetup_purchasing', '---- Edit Purchasing Options', 'admin', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10112, 'adminsetup_da', '---- Edit Digital Assets Options', 'admin', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10113, 'adminsetup_custfields', '---- Edit and Assign Custom Fields', 'admin', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10200, 'admineditinout', 'Edit Other Peoples In / Out Status', 'admin', 'admin', 15, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10600, 'adminemployee', 'Maintain Company Employees', 'admin', 'admin', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10700, 'admineditlogin', 'Edit Employee and Contact Login information', 'admin', 'admin', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10720, 'user_billing', 'Edit Employee and Contact Billing Information ', 'admin', 'admin', 18, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10750, 'adminviewcostrate', 'View Staff cost per hour in the User Lookup', 'admin', 'admin', 19, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10800, 'adminedituserskills', 'Maintain User Skill Levels', 'admin', 'admin', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10805, 'admineditusercalendar', 'Maintain Employee Calendar ', 'admin', 'admin', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11200, 'reportsdesign', 'Design custom reports', 'admin', 'admin', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11300, 'reportsrun', 'Run custom reports', 'admin', 'admin', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11400, 'dataexchange', 'Import and export data', 'admin', 'admin', 24, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11500, 'admineditlisting', 'Edit Custom Listings', 'admin', 'admin', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11601, 'adminViewLog', 'View the System Log', 'admin', 'admin', 26, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20100, 'approveadd', 'Add and Edit Digital Art Reviews', 'project', 'admin', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20300, 'approvedelete', 'Delete a Digital Art Reviews', 'project', 'admin', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30100, 'billingeditinvoice', 'Add and Edit Client Invoices and Credits', 'billing', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30200, 'billingpayments', 'Enter Receipts', 'billing', 'admin', 2, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30300, 'br_viewarreports', '-- View AR Reports --', 'reports', 'admin', 4000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30310, 'br_viewapreports', '-- View AP Reports --', 'reports', 'admin', 5000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30320, 'br_viewglfinancial', '-- View Company Financial Reports --', 'reports', 'admin', 7000, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30330, 'br_viewmedia', '-- View Media Reports --', 'reports', 'admin', 6000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30700, 'billingdeposits', 'Edit Deposit Slips', 'billing', 'admin', 3, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30800, 'billingcreditcard', 'Edit and Charge Credit Cards', 'billing', 'admin', 4, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30900, 'billingretainers', 'Edit Retainers', 'billing', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30901, 'billingviewretainers', 'View Retainers', 'billing', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30902, 'billingremovefromsheet', 'Delete Worksheets and Remove Items from Worksheets', 'billing', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30903, 'billingedittran', 'Edit and Move Transactions on Projects', 'billing', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40400, 'dash_showsnapshot', 'View the Project Snapshot', 'dashboard', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40500, 'dash_showprofit', 'View the Profit Snapshot', 'dashboard', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40600, 'dash_editcompanynotes', 'Edit the Company Wide Notes', 'dashboard', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40700, 'dash_editprojectnotes', 'Edit the Project Notes', 'dashboard', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40800, 'dash_editcontactnotes', 'Edit the Contact Notes (in contact management)', 'dashboard', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (50100, 'fileAccess', 'Access the File Folders', 'file', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (50110, 'fileSearchAll', 'Search in projects you are not assigned to', 'file', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60100, 'purch_editpo', 'Add and Edit PO''s', 'purch', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60300, 'purch_editvoucher', 'Add and Edit Vendor Invoices', 'purch', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61100, 'quote_edit', 'Add and Edit Quotes', 'purch', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61200, 'quote_createpo', 'Create PO''s from Quotes', 'purch', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61300, 'purch_editpayment', 'Add and Edit Payments', 'purch', 'admin', 9, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61400, 'purch_viewiteminfo', 'View Cost and Rate on Item Lookup ', 'purch', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70100, 'formuse', 'Use forms', 'form', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70200, 'formadd', 'Add new forms', 'form', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70300, 'formdelete', 'Delete forms', 'form', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70400, 'formviewall', 'View forms not assigned to the user', 'form', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70500, 'nonauthorformdelete', 'Delete form if not author', 'form', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90100, 'adminCreateProject', 'Create New Projects', 'project', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90200, 'prjInfo', 'Maintain Project Setup', 'project', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90300, 'prjviewprojectreports', '-- View Project Financial Reports --', 'reports', 'admin', 2000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90310, 'prjviewtasks', 'View Task, Schedule Pages', 'project', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90315, 'prjviewbudget', 'View Project Budget Page', 'project', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90320, 'prjedittasks', 'Edit task information', 'project', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90330, 'prjeditestimate', 'Edit Estimate Information', 'project', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90335, 'prjeditestimaterates', 'Edit Rates on Estimates', 'project', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90336, 'prjrecalcrates', 'Update Estimate Rates from Project', 'project', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90340, 'prjunappestimate', 'Unapprove estimate or change order ', 'project', 'admin', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90350, 'prjeditcreativebrief', 'Edit the Creative Brief', 'project', 'admin', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90355, 'prjeditmastertaskdefs', 'Edit Master Task defaults on task', 'project', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90360, 'prjeditspecs', 'Edit the Specifications', 'project', 'admin', 18, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90370, 'prjMiscExpense', 'Add and Edit Misc Expenses', 'project', 'admin', 19, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90600, 'prjviewcreativebrief', 'View the Creative Brief', 'project', 'admin', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90700, 'prjviewspecs', 'View the Project Specifications', 'project', 'admin', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90800, 'prjEditCampaign', 'Edit Campaigns', 'project', 'admin', 51, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90810, 'prjEditLocked', 'Edit Projects in a Locked Status', 'project', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90850, 'prjUnlockLocked', 'Override Scheduling Lock', 'project', 'admin', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90900, 'prjViewCampaign', 'View Campaigns', 'project', 'admin', 50, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100100, 'billingusetimesheet', 'Use Timesheets', 'time', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100110, 'time_editratelevel', 'Edit the rate level on the time sheet', 'time', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100120, 'timeallservices', 'Charge time to any service', 'time', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100130, 'timealltasks', 'Charge time to any task', 'time', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100300, 'billingtimesheetrate', 'View rates on the timesheet', 'time', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100400, 'billingviewalltime', 'View anyone''s timesheet', 'time', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100500, 'billinguseexpenses', 'Use Expenses', 'time', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100700, 'billingviewallexpense', 'View anyone''s expense report', 'time', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100800, 'billingeditanyone', 'Edit Time Sheets and Expense Reports for anyone', 'time', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (110300, 'traffic_viewschedule', 'View Project Schedules', 'traffic', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (110900, 'traffic_viewstaff', 'View Staff Scheduling and Loading', 'traffic', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (110950, 'traffic_viewassignment', 'Traffic Assignment Review', 'traffic', 'admin', 3, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200100, 'proj_projectsummary', 'Project Budget Summary', 'reports', 'admin', 2010, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200200, 'time_productivity', 'Time Productivity Analysis', 'reports', 'admin', 2020, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200300, 'proj_billingworksheet', 'Billing Worksheet', 'reports', 'admin', 2200, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200400, 'proj_projectpo', 'Project Purchase Order Listing', 'reports', 'admin', 2300, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200500, 'time_chargeabilitysummary_hours', 'Chargeability Summary - Hours', 'reports', 'admin', 2100, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200600, 'time_chargeabilitysummary_dollars', 'Chargeability Summary - Dollars', 'reports', 'admin', 2120, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200700, 'proj_actualsbymonth', 'Project Actuals by Month', 'reports', 'admin', 2121, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300000, 'rpt_trafficreports', '--  View Traffic Reports --', 'reports', 'admin', 3000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300100, 'proj_projectstatus', 'Project Status', 'reports', 'admin', 3100, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300200, 'tasks_byUser', 'Project Tasks by Person', 'reports', 'admin', 3200, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300300, 'tasks_byUserDate', 'Project Tasks by Person and Date', 'reports', 'admin', 3300, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300400, 'tasks_byDate', 'Project Tasks by Date', 'reports', 'admin', 3400, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300500, 'tasks_setup', 'Project Setup', 'reports', 'admin', 3500, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (300600, 'tasks_gantt', 'Project Gantt Charts', 'reports', 'admin', 3600, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303301, 'media_recap', 'Media Recap', 'reports', 'admin', 6010, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303302, 'media_discrepancy', 'Media Discrepancy Report', 'reports', 'admin', 6020, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303303, 'media_mixanalysis', 'Media Mix Analysis', 'reports', 'admin', 6030, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (400100, 'acct_ar_aging', 'AR Account Aging', 'reports', 'admin', 4010, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (400300, 'acct_projectwip', 'Project WIP Report', 'reports', 'admin', 2150, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401000, 'usereports', 'View the reports menu', 'reports', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401100, 'rptViewCMReports', '-- View Contact Management Reports --', 'reports', 'admin', 1000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401200, 'rptCMBusDev', 'Business Development Meeting', 'reports', 'admin', 1001, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401300, 'rptCMDownOpps', 'Downgraded Opportunities', 'reports', 'admin', 1002, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500000, 'adminsetup_media', 'Edit the Media setup files', 'media', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500010, 'media_editio', 'Edit Insertion Orders', 'media', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500020, 'media_editbc', 'Edit Broadcast Orders', 'media', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500030, 'media_editestimate', 'Edit Media Estimates', 'media', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500040, 'media_traffic', 'View the Media Traffic Screen', 'media', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500100, 'client_calendar', 'View the calendar', 'client', 'client', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500200, 'client_approvals', 'View the approvals page', 'client', 'client', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500300, 'client_schedule', 'View the project schedule', 'client', 'client', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500400, 'client_hours', 'View hours on project budget ', 'client', 'client', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500500, 'client_budget', 'View project budget page', 'client', 'client', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500550, 'client_viewbudget', 'View the project budget', 'client', 'client', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500600, 'client_budgetdetail', 'Drill down on budget transactions details ', 'client', 'client', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500650, 'client_budgetactuals', 'View actual dollars and hours on a project budget', 'client', 'client', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500700, 'client_invoices', 'View current invoices', 'client', 'client', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500750, 'client_invoicespast', 'View closed invoices', 'client', 'client', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500800, 'client_originalschedule', 'View the original schedule', 'client', 'client', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501100, 'client_prview', 'View Project Requests', 'client', 'client', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501200, 'client_pradd', 'Add New Project Requests', 'client', 'client', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501300, 'client_predit', 'Edit Project Requests from their company', 'client', 'client', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501400, 'client_prdelete', 'Can delete requests from their company', 'client', 'client', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501450, 'client_praddnewspec', 'Can add and delete spec sheets on project requests', 'client', 'client', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501500, 'client_dafiles', 'Can View Digital Asset Files', 'client', 'client', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501550, 'client_dafilesupload', 'Can Upload Digital Asset Files', 'client', 'client', 18, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501600, 'client_projectlist', 'View the list of assigned projects', 'client', 'client', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501700, 'client_notes', 'Add and Edit the Project Diary', 'client', 'client', 19, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501800, 'client_myinfo', 'Change MyInfo data and password', 'client', 'client', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501801, 'client_assignments', 'View Assigned Tasks', 'client', 'client', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501810, 'client_daviewprior', 'Can view prior digital art reviews', 'client', 'client', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501820, 'client_viewinvoicecompany', 'View Invoices for Company', 'client', 'client', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501830, 'client_viewinvoiceparentcompany', 'View Invoices for Parent Company', 'client', 'client', 24, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501840, 'client_projectdescription', 'View the Project Description', 'client', 'client', 25, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501850, 'client_projectteam', 'View the Project Team', 'client', 'client', 26, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501860, 'client_creativebrief', 'View the Project Creative Brief', 'client', 'client', 27, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501870, 'client_projectspecs', 'View the Project Specifications', 'client', 'client', 28, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (601000, 'desktopEditSetup', 'Edit the company settings for the desktop (Workamajig Only)', 'desktop', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (903500, 'adminDeleteProject', 'Delete a Project', 'project', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (903510, 'prjReopen', 'Reopen Projects', 'project', 'admin', 3, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10500, 'admincontact', 'View the Company Address Book (CM Only)', 'cm', 'admin', 1, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930000, 'cm_editcontacts', 'Edit contact information (CM Only)', 'cm', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930100, 'cm_viewothermanagers', 'View Other Account Manager''s Opportunities and Activities (CM Only)', 'cm', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930150, 'cm_dashboard', 'View the contact management dashboard (CM Only)', 'cm', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930200, 'cm_viewleads', 'View and Edit Opportunities (CM Only)', 'cm', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930400, 'cm_viewactivities', 'View Contact Activites (CM Only)', 'cm', 'admin', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930500, 'cm_allowdelete', 'Delete contacts (CM Only)', 'cm', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930600, 'cm_showall', 'See contacts they do not own (CM Only)', 'cm', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930700, 'cm_alldb', 'See contacts in all databases (CM Only)', 'cm', 'admin', 12, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120100, 'calUseCalendar', 'Access the calendar', 'calendar', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120200, 'caladdmeetings', 'Add New Meetings', 'calendar', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120300, 'calviewcompany', 'View Company Meetings (CM Only)', 'calendar', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120400, 'calBlockOutDays', 'Mark Calendar Events to block out days on the schedule', 'calendar', 'admin', 72, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120500, 'caleditglobalgroups', 'Maintain Global Distribution Groups', 'calendar', 'admin', 73, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120600, 'foldersCalendar', 'Add/Edit/Delete Public Calendars', 'calendar', 'admin', 71, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931400, 'useLeads', 'Use Lead', 'cm', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931401, 'viewOtherLeads', 'View Leads You Do Not Own', 'cm', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931402, 'editOtherLeads', 'Edit Leads You Do Not Own', 'cm', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931403, 'addLeads', 'Add Leads', 'cm', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931404, 'deleteLeads', 'Delete Leads', 'cm', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931405, 'foldersLeads', 'Add/Edit/Delete Lead Folders', 'cm', 'admin', 15, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931600, 'useContacts', 'Use Contacts', 'cm', 'admin', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931601, 'viewOtherContacts', 'View Contacts You Do Not Own', 'cm', 'admin', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931602, 'editOtherContacts', 'Edit Contacts You Do Not Own', 'cm', 'admin', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931603, 'addContacts', 'Add New Contacts', 'cm', 'admin', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931604, 'deleteContacts', 'Delete Public Contacts', 'cm', 'admin', 24, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931605, 'moveFoldersContacts', 'Move Public Contacts to Private Folders', 'cm', 'admin', 25, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931606, 'foldersContacts', 'Add/Edit/Delete Public Contact Folders', 'cm', 'admin', 26, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931700, 'useCompanies', 'Use Companies', 'cm', 'admin', 30, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931701, 'viewOtherCompanies', 'View Companies You Do Not Own', 'cm', 'admin', 31, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931702, 'editOtherCompanies', 'Edit Companies You Do Not Own', 'cm', 'admin', 32, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931703, 'addCompanies', 'Add new Companies', 'cm', 'admin', 33, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931704, 'deleteCompanies', 'Delete Companies', 'cm', 'admin', 34, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931705, 'foldersCompanies', 'Add/Edit/Delete Company Folders', 'cm', 'admin', 35, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931706, 'cm_editacctinfo', 'Edit Accounting Information', 'cm', 'admin', 36, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931100, 'useOpp', 'Use Opportunities', 'cm', 'admin', 40, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931101, 'viewOtherOpp', 'View Opportunities You Do Not Own', 'cm', 'admin', 41, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931102, 'editOtherOpp', 'Edit Opportunities You Do Not Own', 'cm', 'admin', 42, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931103, 'addOpp', 'Add New Opportunities', 'cm', 'admin', 43, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931104, 'deleteOpp', 'Delete Opportunities', 'cm', 'admin', 44, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931105, 'foldersOpp', 'Add/Edit/Delete Opportunity Folders', 'cm', 'admin', 45, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931500, 'useActivities', 'Use Activities', 'cm', 'admin', 50, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931501, 'viewOtherActivities', 'View Activities Not Assigned To You', 'cm', 'admin', 51, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931502, 'editOtherActivities', 'Edit Activities Not Assigned To You', 'cm', 'admin', 52, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931503, 'deleteActivities', 'Delete Activities', 'cm', 'admin', 53, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931504, 'foldersActivities', 'Add/Edit/Delete Public Activity Folders', 'cm', 'admin', 54, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931505, 'moveFoldersActivities', 'Move Public Activities to Private Folders', 'cm', 'admin', 55, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931506, 'activityAllwaysCheckOpp', 'Always Check for Opportunities on Actvities', 'cm', 'admin', 56, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931550, 'useMarketingLists', 'Use Marketing Lists', 'cm', 'admin', 60, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930800, 'cm_viewclientlist', 'View the client list', 'cm', 'admin', 34, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930900, 'cm_viewvendorlist', 'View the vendor list', 'cm', 'admin', 35, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940100, 'gl_glaccount', 'Maintain GL Accounts', 'acct', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940200, 'gl_journalentry', 'Enter Journal Entries', 'acct', 'admin', 2, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940300, 'gl_budget', 'Enter GL Budgets', 'acct', 'admin', 3, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940400, 'gl_accountrecs', 'Reconcile GL Accounts', 'acct', 'admin', 7, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940450, 'gl_post', 'Post Transaction to the General Ledger', 'acct', 'admin', 9, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940500, 'gl_postwip', 'Post WIP to GL', 'acct', 'admin', 8, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940600, 'laborbud_edit', 'Edit Labor Budgets', 'acct', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940610, 'laborbud_viewanyoffice', '---- Edit / View labor budgets for any office', 'acct', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940620, 'laborbud_viewanydept', '---- Edit / View labor budgets for any department', 'acct', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940630, 'chargesum_viewanyperson', '---- View any or all people on chargeability summary', 'acct', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940700, 'accteditanytime', 'Edit transactions after approval', 'acct', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940800, 'gl_editgross', 'Edit Gross Amounts on Transactions', 'acct', 'admin', 11, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950000, 'acct_ap_aging', 'AP Account Aging', 'reports', 'admin', 5010, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950001, 'acct_ap_listing', 'AP Listing', 'reports', 'admin', 5020, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950002, 'acct_ap_1099', '1099 Vendor Detail', 'reports', 'admin', 5050, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950003, 'acct_po_listing', 'Purchase Order Listing', 'reports', 'admin', 5060, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950004, 'acct_po_project', 'Project PO Listing', 'reports', 'admin', 5070, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950005, 'acct_ap_checks', 'Payment Listing', 'reports', 'admin', 5080, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950006, 'acct_ar_invoicesummary', 'Invoice Summary', 'reports', 'admin', 4050, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950007, 'acct_ar_invoicelineitemsummary', 'Invoice Line Item Summary', 'reports', 'admin', 4060, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950008, 'acct_gl_trailbal', 'Trial Balance', 'reports', 'admin', 7130, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950009, 'acct_gl_genledger', 'General Ledger', 'reports', 'admin', 7140, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950010, 'acct_gl_genjournal', 'General Journal', 'reports', 'admin', 7150, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950011, 'acct_gl_pl_ytd', 'Income Statement', 'reports', 'admin', 7160, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950012, 'acct_gl_balsheet', 'Balance Sheet', 'reports', 'admin', 7170, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950013, 'acct_ap_purchjournal', 'Purchase Journal', 'reports', 'admin', 5030, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950014, 'acct_ap_payjournal', 'Cash Disbursements Journal', 'reports', 'admin', 5040, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950015, 'acct_ar_salesjournal', 'Sales Journal', 'reports', 'admin', 4020, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950016, 'acct_ar_cashjournal', 'Cash Receipts Journal', 'reports', 'admin', 4030, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950020, 'acct_ar_statement', 'Client Statements', 'reports', 'admin', 4040, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950025, 'acct_inv_backup', 'Invoice Backup', 'reports', 'admin', 4045, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950030, 'acct_gl_excel', 'Access Financials from Excel', 'reports', 'admin', 7180, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950040, 'acct_ap_accruedorder', 'AP Accrued Order Detail Report', 'reports', 'admin', 5075, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950045, 'acct_ap_exceptions', 'AP Exceptions Report', 'reports', 'admin', 5015, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950110, 'acct_salestaxanalysis', 'Sales Tax Analysis Report', 'reports', 'admin', 4070, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950120, 'acct_projectprofit', 'Project Profitability', 'reports', 'admin', 2015, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950121, 'acct_projectrealization', 'Project Hourly Realization Rate', 'reports', 'admin', 2016, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950130, 'acct_gl_statement_cashflow', 'Statement of Cash Flows', 'reports', 'admin', 7180, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950135, 'acct_gl_cashprojection', 'Cash Projection', 'reports', 'admin', 7185, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950136, 'acct_gl_uncleared', 'Uncleared Transactions', 'reports', 'admin', 7186, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950140, 'acct_metrics', 'Metrics Monitor', 'reports', 'admin', 7190, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960000, 'pr_viewrequests', 'View Project Requests', 'requests', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960010, 'pr_addrequests', 'Add New Requests to the system', 'requests', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960020, 'pr_editrequests', 'Edit Existing Requests', 'requests', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960030, 'pr_deleterequests', 'Delete Existing Requests', 'requests', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960040, 'pr_editapproval', 'Edit the approval process', 'requests', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960050, 'proj_projectassignments', 'Assigned Tasks', 'reports', 'admin', 3150, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960051, 'admin_employeehours', 'Employee Actual Hours Report', 'reports', 'admin', 5076, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (1190930, 'prjnotes', 'Add and Edit Project Diary Notes', 'project', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000000, 'br_viewlegacy', '-- View Legacy Reports --', 'reports', 'admin', 9000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000001, 'legacy_proj_projectsummary', 'Project Budget Summary (Legacy)', 'reports', 'admin', 9001, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000002, 'legacy_acct_projectprofit', 'Project Profitability (Legacy)', 'reports', 'admin', 9002, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000003, 'legacy_acct_projectwip', 'Project WIP Report (Legacy)', 'reports', 'admin', 9003, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000004, 'legacy_acct_gl_pl_ytd', 'Income Statement (Legacy)', 'reports', 'admin', 9004, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90000001, 'cbeditbatch', 'Edit Charge Back Batches', 'billing', 'ChargeCodes', 1, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (91000000, 'muddAMRpt', 'AGI By Account Manager Report', 'reports', 'mudd', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (91000001, 'muddSMRpt', 'AGI By Sales Manager', 'reports', 'mudd', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (91000002, 'muddAMClientRpt', 'AGI By Account Manager or Client', 'reports', 'mudd', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (92000000, 'partnersnapierMonthyActualHours', 'Retainer Monthly Actual Hours', 'reports', 'partnersnapier', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (92000001, 'partnersnapierMonthyActualHrsBudget', 'Retainer Monthly Actual Hours with Budget', 'reports', 'partnersnapier', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (92000002, 'partnersnapierSalesJournal', 'Custom Sales Journal', 'reports', 'partnersnapier', 999, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90911, 'prjDashStatus', 'View the current status on the project dashboard', 'project', 'admin', 100, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90912, 'prjDashDescription', 'View the project description on the project dashboard', 'project', 'admin', 101, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90913, 'prjDashSetup', 'View the setup information on the project dashboard', 'project', 'admin', 102, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90914, 'prjDashBrief', 'View the creative brief on the project dashboard', 'project', 'admin', 103, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90915, 'prjDashSpecs', 'View the spec sheets on the project dashboard', 'project', 'admin', 104, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90916, 'prjDashTeam', 'View the team list on the project dashboard', 'project', 'admin', 105, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90917, 'prjDashSnapshot', 'View the project snapshot on the project dashboard', 'project', 'admin', 106, 1)



Delete tWidget

INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (1, NULL, 'RSS Reader', 'RSS Reader', 'main', 0, 'OtherRSSReader.swf', 'widgetOther', '<settings><Title>RSS READER</Title><rssUrl></rssUrl></settings>', 1, 1, 400, 400, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (2, NULL, 'Chargeability Summary', 'Displays the chargeability summary', 'main', 0, 'MetricsChargeabilitySummary.swf', 'widgetMetric', '<settings><title>CHARGEABILITY SUMMARY</title><laborBudgetKey>-1</laborBudgetKey><officeKey>-1</officeKey><departmentKey>-1</departmentKey><userKey>-1</userKey></settings>', 1, 1, 295, 400, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (3, NULL, 'Metrics Monitor', 'Displays a single snapshot of all the metrics in the monitor', 'main', 0, 'MetricsMonitorSummary.swf', 'widgetMetric', '', 1, 1, 450, 325, 0, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (4, NULL, 'Income By Service', 'Displays income by service', 'main', 0, 'MetricsIncomeByService.swf', 'widgetMetric', '<settings><title>INCOME BY SERVICE</title><numServices>5</numServices><dateRange>0</dateRange></settings>', 1, 1, 285, 410, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (5, NULL, 'Vulnerability To Loss', 'Displays your revenue allocation by client', 'main', 0, 'MetricsVulnerabilityToLoss.swf', 'widgetMetric', '<settings><title>VULNERABILITY TO LOSS</title><dateRange>1</dateRange></settings>', 1, 1, 290, 480, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (6, NULL, 'Cash On Hand', 'Displays the amount of cash on hand', 'main', 0, 'MetricsCashOnHand.swf', 'widgetMetric', '<settings><title>CASH ON HAND</title><upperTarget>0</upperTarget><lowerTarget>0</lowerTarget></settings>', 1, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (7, NULL, 'Revenue Per Employee', 'Displays the amount of revenue per employee', 'main', 0, 'MetricsRevenuePerEmployee.swf', 'widgetMetric', '<settings><title>REVENUE PER EMPLOYEE</title><laborBudgetKey>0</laborBudgetKey><fullTimeHours>2080</fullTimeHours><upperTarget>8500</upperTarget><lowerTarget>6000</lowerTarget></settings>', 1, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (8, NULL, 'Repeat Clients', 'Displays the percentage of repeat clients', 'main', 0, 'MetricsRepeatClients.swf', 'widgetMetric', '<settings><title>REPEAT CLIENTS</title><upperTarget>80</upperTarget><lowerTarget>50</lowerTarget><dateRange>0</dateRange></settings>', 1, 1, 300, 330, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (9, NULL, 'Markup By Item', 'Displays the Markup for each item', 'main', 0, 'MetricsMarkupByItem.swf', 'widgetMetric', '<settings><title>MARKUP BY ITEM</title><numItems>5</numItems><target>25</target><dateRange>1</dateRange></settings>', 1, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (10, NULL, 'Chargeability Percentage', 'Displays the percentage of billable hours divided by total hours', 'main', 0, 'MetricsChargeabilityPercentage.swf', 'widgetMetric', '<settings><title>CHARGEABILITY PERCENTAGE</title><userKey>-1</userKey><upperTarget>75</upperTarget><lowerTarget>50</lowerTarget><dateRange>-1</dateRange></settings>', 1, 1, 295, 360, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (11, NULL, 'Write Off Summary', 'Displays the labor written off and the associated reason', 'main', 0, 'MetricsWriteOffSummary.swf', 'widgetMetric', '<settings><title>WRITE OFF SUMMARY</title><officeKey>-1</officeKey><departmentKey>-1</departmentKey><userKey>-1</userKey><dateRange>0</dateRange></settings>', 1, 1, 320, 410, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (12, NULL, 'Billable Efficiency', 'Compares how much of your billable time you able to realize against your targets', 'main', 0, 'MetricsBillingEfficiency.swf', 'widgetMetric', '<settings><title>BILLABLE EFFICIENCY</title><laborBudgetKey>0</laborBudgetKey><dateRange>1</dateRange></settings>', 1, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (15, NULL, 'Tracking Forms', 'Displays a summary of any tracking forms that have been assigned to you', 'main', 0, 'OperationalForms.swf', 'widgetOperational', '', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (16, NULL, 'Active Projects', 'Diplays a list of all active projects you are assigned to', 'main', 0, 'OperationalActiveProjects.swf', 'widgetOperational', '<settings><title>ACTIVE PROJECTS</title><openAssignmentsOnly>0</openAssignmentsOnly><groupBy>None</groupBy><groupByOrder>ASC</groupByOrder><sortBy>None</sortBy><sortByOrder>ASC</sortByOrder><projectStatus>-1</projectStatus><billingStatus>-1</billingStatus><warningPercent>80</warningPercent><layout></layout></settings>', 0, 1, 400, 630, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (17, NULL, 'My Tasks', 'Displays a summary of any tracking forms that have been assigned to you', 'main', 0, 'OperationalMyTasks.swf', 'widgetOperational', '<settings><title>MY TASKS</title><dateRange>0</dateRange><showOnRight>0</showOnRight><defaultSort>ProjectNumber</defaultSort><layout></layout><direction>Asc</direction><warningPerc>75</warningPerc><completedOnly>0</completedOnly><groupBy>NoGrouping</groupBy><groupByOrder>Asc</groupByOrder></settings>', 0, 1, 400, 700, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (21, NULL, 'My Items to Approve', 'View a summary of all the items you have to approve', 'main', 0, 'OperationalMyApprovals.swf', 'widgetOperational', '', 0, 1, 500, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (22, NULL, 'My Notes', 'Allows you to add a personal note to your desktop', 'main', 0, 'OperationalMyNote.swf', 'widgetOperational', '<settings><title>MY NOTES</title></settings>', 0, 1, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (23, NULL, 'Company Notes', 'View the company message on your desktop', 'main', 0, 'OperationalCompanyNote.swf', 'widgetOperational', '<settings><title>COMPANY NOTES</title></settings>', 0, 0, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (24, NULL, 'My Activities', 'View and update your contact management activities', 'main', 0, 'OperationalMyActivities.swf', 'widgetOperational', '<settings><title>MY ACTIVITIES</title><dateRange>1</dateRange><hideActivityNotes>0</hideActivityNotes><direction>ASC</direction></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (25, NULL, 'In Out Board', 'View who is in and out of the office', 'main', 0, 'OperationalInOutBoard.swf', 'widgetOperational', '<settings><title>IN/OUT BOARD</title></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (26, NULL, 'Today''s Meetings', 'View the events for today', 'main', 0, 'OperationalTodaysEvents.swf', 'widgetOperational', '<settings><title>TODAY''S MEETINGS</title></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (27, NULL, 'Today''s Time', 'View all your time entries for today', 'main', 0, 'OperationalTodaysTime.swf', 'widgetOperational', '<settings><title>TODAY''S TIME</title></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (28, NULL, 'Client Notes', 'Allows you to view notes setup for a client. This is only visible to the actual client when the log in', 'main', 0, 'OperationalClientNote.swf', 'widgetOperational', '', 0, 1, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (29, NULL, 'Opportunity Pipeline', 'View the opportunity pipeline', 'main', 0, 'OpportunityPipeline.swf', 'widgetOperational', '<settings><title>OPPORTUNITY PIPELINE</title><accountManagerKey></accountManagerKey><entityValues>0</entityValues><entityText></entityText><ProjectTypeKey>-1</ProjectTypeKey><LeadStatusKey>-1</LeadStatusKey><AmountType>0</AmountType><GroupBy>1</GroupBy><ShowAs>0</ShowAs></settings>', 0, 1, 250, 540, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (30, NULL, 'Opportunity Forecast', 'View the opportunity forecast', 'main', 0, 'OpportunityForecast.swf', 'widgetOperational', '<settings><title>OPPORTUNITY FORECAST</title><entityValues></entityValues><entityText></entityText><GroupedBy>1</GroupedBy></settings>', 0, 1, 250, 540, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (31, NULL, 'Opportunity Outcome', 'View the opportunity pipeline', 'main', 0, 'OpportunityOutcome.swf', 'widgetOperational', '<settings><title>OPPORTUNITY OUTCOME</title><dateRange>1</dateRange></settings>', 0, 1, 245, 445, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (32, NULL, 'Opportunity Closed By Person', 'View the opportunity pipeline', 'main', 0, 'OpportunityClosedByPerson.swf', 'widgetOperational', '<settings><title>OPPORTUNITY CLOSED BY PERSON</title><dateRange>1</dateRange></settings>', 0, 1, 245, 445, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (33, NULL, 'Weather', 'Weather', 'main', 0, 'OtherWeather.swf', 'widgetOther', '<settings><title></title><city/><unittype>0</unittype><citycode/><country/><state/><location/><zipcode>000000</zipcode></settings>', 1, 1, 302, 280, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (34, NULL, 'Company Calendar', 'View all staff members'' calendars that you have access to.', 'main', 0, 'OperationalCompanyCalendar.swf', 'widgetOperational', '<settings><title>COMPANY CALENDAR</title><IncludePersonal>1</IncludePersonal><IncludePublic>0</IncludePublic><IncludeActivities>0</IncludeActivities><IncludeTasks>0</IncludeTasks><GroupBy>0</GroupBy></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (35, NULL, 'Revenue By Account Manager', 'Displays the amount of revenue by account manager', 'main', 0, 'MetricsRevenueByAccountManager.swf', 'widgetMetric', '<settings><title>REVENUE BY ACCOUNT MANAGER</title><dateRange>0</dateRange></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (36, NULL, 'Revenue Trend', 'Displays the cumulative revenue trend for a twelve month period', 'main', 0, 'MetricsRevenueTrend.swf', 'widgetMetric', '<settings><title>REVENUE TREND</title><month>1</month><year>2009</year><firstTarget>0</firstTarget><secondTarget>0</secondTarget><thirdTarget>0</thirdTarget><fourthTarget>0</fourthTarget><entityValues></entityValues><entityText></entityText></settings>', 0, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (37, NULL, 'Activity Counts', 'View a summary of the activities', 'main', 0, 'ActivityCounts.swf', 'widgetMetric', '<settings><title>ACTIVITY COUNTS</title><activityTypeKeys></activityTypeKeys><assignedUserKeys></assignedUserKeys></settings>', 1, 1, 300, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (99, NULL, 'Sticky Note', 'Allows you to add a sticky note to your desktop', 'main', 0, 'OperationalStickyNote.swf', 'widgetOperational', '<settings><title>STICKY NOTE</title><noteText></noteText></settings>', 0, 1, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (10000, 75557, 'ww', '', 'main', 0, 'OtherSWFLoader.swf', 'widgetOther', NULL, 0, 0, 100, 300, 1, GETDATE())





if @SeedOnly = 1   -- ***********************************************************************************************************
	return


Update tUser Set UserCompanyName = tCompany.CompanyName, OwnerKey = tCompany.ContactOwnerKey
from tCompany Where tUser.CompanyKey = tCompany.CompanyKey


Update tAddress Set CompanyKey = 0 Where Entity = 'tUser'


--Convert Calendar Events
exec spConvertDB10500Calendar


--Convert Contact Databases
exec spConvertDB10500ContactDatabase


Update tProject
Set LeadKey = tLead.LeadKey
from tLead
Where tProject.ProjectKey = tLead.ProjectKey



/*
This converts the tStringCompany field currently used for Activity Type
to a seperate table tActivityType.  Once the table is populated for each 
company, it will then update all tActivity rows with the proper 
tActivityType.ActivityTypeKey. 
*/

declare @Values varchar(4000)
declare @CurrSearchIdx int 
declare @DelimIdx int
declare @ValuesLength int
declare @Value varchar(100)
declare @CompanyKey int

select @CompanyKey = -1

while 1=1
	begin 
		select @CompanyKey = min(CompanyKey) 
		from tStringCompany (nolock)
		where CompanyKey > @CompanyKey
		and StringID = 'CMActityType'
		and StringDropDown is not null
	
		if @CompanyKey is null
			break

		select @Values = ltrim(rtrim(StringDropDown)) from tStringCompany
		where StringID = 'CMActityType'
		and CompanyKey = @CompanyKey

		select @ValuesLength = len(@Values)
		--print 'Total Length = ' + cast(@ValuesLength as varchar(10))
		 
		select @CurrSearchIdx = 1

		while 1=1
			begin
				select @DelimIdx = charindex('|', @Values, @CurrSearchIdx)
				if @DelimIdx > 0
					begin
						select @Value = substring(@Values, @CurrSearchIdx, @DelimIdx - @CurrSearchIdx)
						select @CurrSearchIdx = @DelimIdx + 1
						--print @Value
						insert tActivityType (TypeName, CompanyKey, Active)
						values (@Value, @CompanyKey, 1)
					end
				else
					begin
						select @Value = substring(@Values, @CurrSearchIdx, @ValuesLength - @CurrSearchIdx + 1)
						--print @Value
						insert tActivityType (TypeName, CompanyKey, Active)
						values (@Value, @CompanyKey, 1)
						break
					end
			end
	end



update tActivity
set ActivityTypeKey = at.ActivityTypeKey
from tActivityType at (nolock)
where tActivity.CompanyKey = at.CompanyKey 
and tActivity.Type = at.TypeName


update tActivityType
set LastModified = getdate()



--#### begin default all Custom Field Single Checkboxes to value 'NO' ####
create table #CFDefCB (CustomFieldKey int not null)

insert #CFDefCB (CustomFieldKey)
select distinct(ofs.ObjectFieldSetKey)
from tObjectFieldSet ofs (nolock) inner join tFieldSet fs (nolock) on ofs.FieldSetKey = fs.FieldSetKey
inner join tFieldSetField fsf (nolock) on fs.FieldSetKey = fsf.FieldSetKey
inner join tFieldDef fd (nolock) on fsf.FieldDefKey = fd.FieldDefKey
where isnull(fs.Active, 0) = 1
and fd.DisplayType = 9


declare @CFKey int
select @CFKey = -1
while 1=1
	begin
		select @CFKey = min(CustomFieldKey)
		from #CFDefCB
		where CustomFieldKey > @CFKey
		
		if @CFKey is null
			break
			
		exec spCF_tFieldValueSetDefaults @CFKey
	end
--#### end default all Custom Field Single Checkboxes to value 'NO'	####


INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931700 From tRightAssigned Where RightKey = 10500  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931700)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931704 From tRightAssigned Where RightKey = 10500  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931704)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931703 From tRightAssigned Where RightKey = 10500  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931703)


INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931600 From tRightAssigned Where RightKey = 930000  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931600)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931603 From tRightAssigned Where RightKey = 930000  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931603)

INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931604 From tRightAssigned Where RightKey = 930500  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931604)

INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931101 From tRightAssigned Where RightKey = 930100  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931101)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931501 From tRightAssigned Where RightKey = 930100  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931501)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931502 From tRightAssigned Where RightKey = 930100  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931502)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931102 From tRightAssigned Where RightKey = 930100  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931102)


INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931100 From tRightAssigned Where RightKey = 930200  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931100)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931103 From tRightAssigned Where RightKey = 930200  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931103)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931104 From tRightAssigned Where RightKey = 930200  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931104)



INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931500 From tRightAssigned Where RightKey = 930400  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931500)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931503 From tRightAssigned Where RightKey = 930400  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931503)


INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931601 From tRightAssigned Where RightKey = 930600  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931601)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931701 From tRightAssigned Where RightKey = 930600  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931701)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931702 From tRightAssigned Where RightKey = 930600  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931702)
INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) Select 'Security Group', EntityKey, 931602 From tRightAssigned Where RightKey = 930600  and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931602)
GO
