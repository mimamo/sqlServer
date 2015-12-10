USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDBSeed]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDBSeed]
AS

/*
|| When      Who Rel      What
|| 8/21/09   CRG 10.5.0.8 Created to have all of the seed generating statements in one SP.
||                        Add comments here when you add a new seed value
|| 8/31/09   CRG 10.5.0.9 Added options for Today's Meetings widget
|| 9/8/09    GWG 10.5.0.9 Added a right for editing notes for clients  (also changed some labels)
|| 10/06/09  GHL 10.5.1.2 (63999) Added prjAccessAny and prjChargeAny
|| 10/06/09  GHL 10.5.1.3 (47035) Added prjTimeCompletedTask and prjExpenseCompletedTask
|| 11/4/09   CRG 10.5.1.3 Fixed a spelling error in RightKey: 931506
|| 12/03/09  GHL 10.5.1.4 (64187) Added proj_projectscoreboard for project summary scoreboard
|| 02/08/10  GWG 10.5.1.8 Added the opportunity list as a legacy report
|| 02/10/10  GWG 10.5.1.8 Added new widget for recurring transactions (not active yet, commented out)
|| 03/18/10  MAS 10.5.2.0 Added Voucher Lab
|| 3/31/10   GWG 10.5.2.0 Fixed some wording and display orders for certain security groups
|| 04/08/10  RLB 10.5.2.1 Added Billing Add Transaction to Worksheet.
|| 04/24/10  GWG 10.5.2.1 Added a right for enabling labs and modified the labs
|| 04/27/10  GWG 10.5.2.1 Added right for CBRE report
|| 05/6/10   RLB 10.5.2.2 (80005)Changed Display Order on admin_employeehours
|| 06/17/10  GWG 10.5.3.1 Fixed a spelling error, moved schedule edit to beta and fixed a setting chargeability percentage
|| 06/17/10  GWG 10.5.3.2 Removed the client notes widget.
|| 7/8/10    GWG 10.5.3.2 Added GL Posting as a Lab
|| 08/26/10  RLB 10.5.3.4 (80063,69422)Added 2 new rights View invoice for child company and view invoices for assigned projects
|| 08/27/10  RLB 10.5.3.4 added right for new Overhead Allocation Details Report
|| 09/30/10  MFT 10.5.3.5 added Lab for Transactions and AcctRec
|| 10/03/10  MFT 10.5.3.6 added Lab for IO & PO
|| 10/10/10  GWG 10.5.3.6 Changed a description for adminviewcostrate and added some release comments
|| 10/27/10  RLB 10.5.3.7 Added a lab for WIP Aging
|| 10/28/10  GWG 10.5.3.7 Took items out of labs and rearanged stuff
|| 11/16/10  RLB 10.5.3.8 added new right group legacy
|| 12/3/10   CRG 10.5.3.9 Added labs for Diary and ToDos (commented out for now)
|| 12/10/10  GWG 10.5.3.9 Changed the default url for the rss widget
|| 01/14/11  MAS 10.5.?.? Added MobileMenu seed values
|| 02/01/11  GWG 10.5.4.0 Changed lab settings and removed a duplicate adminsetup_media in system setup
|| 03/20/11  GWG 10.5.4.2 Added a new notification (task reminder)
|| 04/18/11  GWG 10.5.4.3 Commented out project requests from the mobile menu for now
|| 06/02/11  RLB 10.5.4.5 (113014) added ProjectTypeKey for My Task widget
|| 06/28/11  RLB 10.5.4.5 (115163) added right to convert contacts and employees
|| 06/28/11  GHL 10.5.4.5 (60333) Added media billing report
|| 08/02/11  GHL 10.5.4.6 Added LabID for credit cards
|| 09/12/11  GHL 10.5.4.8 Added Rights for Credit Card charges
|| 09/22/11  GHL 10.5.4.8 (109668) Added right pyramidLaborRpt for a customization for Pyramid
|| 09/27/11  GWG 10.5.4.8 Made the metrics monitor resizable
|| 09/28/11  GHL 10.5.4.8 Added client_editprojectspecs for the Integer Group of Colorado for clients to edit project specs
||                        Added billingtimesheetunapprove for the Integer Group of Colorado to unapprove timesheets
|| 09/28/11  CRG 10.5.4.8 Removed WebDAV from the Labs. It will now just be an internal flag in tPreference that we turn on once they're converted
|| 09/28/11  GHL 10.5.4.8 Changed wording of the right purch_usecreditcard to 'use credit card charge entry screens'
||                        to differentiate with right billingcreditcard
|| 10/25/11 RLB 10.5.4.9  (124610) Added right to edit other peoples Diary Posts
|| 11/4/11  GWG 10.5.4.9  Reordered the mobile menu
|| 11/8/11  RLB 10.5.5.0  Adding Retainer Lab
|| 12/7/11  RLB 10.5.5.1  (128080) Added openToDoOnly option on the My Task widget
|| 01/30/12 MAS 10.5.5.3  Added Financial Institution data for Credit Card downloads
|| 04/09/12 GHL 10.5.5.5  Added right to edit electronic signature on check formats
|| 04/09/12 GHL 10.5.5.5  (139284) Added rights billingtransfertran and billingwriteofftran 
|| 04/23/12 MAS 10.5.5.5  Added purch_usecreditcardconnect right
|| 05/04/12 MAS 10.5.5.5  Changed the URL connection string for AMEX
|| 6/1/12   CRG 10.5.5.6  Added publishCalendar lab
|| 6/6/12   RLB 10.5.5.6  (138325) Added Client right to see Project Misc Cost
|| 6/13/12  GHL 10.5.5.7  Added right adminsetup_glcompanyaccess to allow editing of gl compapanies access on company edit screen
|| 6/28/12  RLB 10.5.5.7  (147280) Added option on the active project widget
|| 7/16/12  CRG 10.5.5.8  Added lab for revenue forecast
|| 07/23/12 RLB 10.5.5.8  (149536) Added New right to view project revenue source
|| 07/25/12 MFT 10.5.5.8  Added new right for printing checks (purch_printchecks)
|| 07/27/12 RLB 10.5.5.8  Added new option in the Chargeablility Summary widget
|| 07/31/12 RLB 10.5.5.8  Added GL Company Option to the Cash on Hand widget
|| 07/31/12 RLB 10.5.5.8  Added GL Company Option to the Write Off Summary widget
|| 07/31/12 MFT 10.5.5.8  Added Settings value to the tWidget INSERT for Metrics Monitor
|| 07/31/12 RLB 10.5.5.8  Added GL Company Option to the Opp Pipeline widget
|| 08/07/12 RLB 10.5.5.8  Added GL Company Option to the Chargeablility percentage and HMI changes
|| 08/07/12 RLB 10.5.5.8  Added GL Company Option to the Rev Per Employee
|| 08/07/12 RLB 10.5.5.8  Added GL Company Option to the Opp Forecast widget and HMI changes
|| 08/07/12 RLB 10.5.5.8  Added GL Company Option to the Opp Outcome and HMI changes
|| 08/07/12 MFT 10.5.5.8  Added Settings value to the tWidget INSERT for Billable Efficiency
|| 08/08/12 RLB 10.5.5.8  Added GL Company Option to the Opp closed by person and HMI changes
|| 08/08/12 MFT 10.5.5.8  Added Settings value to the tWidget INSERT for Vulnerability to Loss
|| 08/08/12 RLB 10.5.5.8  Added GL Company Option to the Active Project widget
|| 08/10/12 RLB 10.5.5.8  Added GL Company Option to the Income By Service and HMI changes
|| 08/10/12 RLB 10.5.5.8  Added GL Company Option to the Repeat clients and HMI changes
|| 08/10/12 RLB 10.5.5.8  Added GL Company Option to the Revenue Trend and HMI changes
|| 08/11/12 QMD 10.5.5.9  Added lab for google contacts and google calendar v3
|| 08/15/12 KMC 10.5.5.9  (151654) Updated the insert into tWidget for Revenure Trend Widget (ID=36) and default
||                        the year node to blank in the XML string.  Also updated MetricsRevenueTrend.mxml to set the
||                        year to the current year if it is blank
|| 08/20/12 RLB 10.5.5.9  (152004) Added rights to merge Leads, Contacts and Companies
|| 08/20/12 MFT 10.5.5.9  Added GL Company Option to the tWidget for Markup By Item and Company Calendar
|| 09/11/12 CRG 10.5.6.0  Added lab for P&L Custom Layouts
|| 09/18/12 MFT 10.5.6.0  Added right hmiProjectResourceUtilization for HMI custom report
|| 09/24/12 RLB 10.5.6.0  Added right to Unpost for HMI
|| 10/02/12 KMC 10.5.6.0  (134065) Added Account Balances widget
|| 10/05/12 WDF 10.5.6.0  (150044) Added 'Project Billable Hours Summary' report
|| 10/25/12 MFT 10.5.6.1  (156391) Added right for Project Reconciliation Summary
|| 11/20/12 WDF 10.5.6.2  Added Settings value 'ShowInActive'to the tWidget INSERT for Opportunity Pipeline, Opportunity Forecast, Revenue Trend, Activity Counts
|| 11/26/12 RLB 10.5.6.2  added description on Deliverable Lab stating that Web Dav Is required to use
|| 11/29/12 QMD 10.5.6.2  Added lab for new emma and google caldav
|| 12/7/12  GWG 10.5.6.3  Added All projects to the over budget calculation
|| 02/14/13 KMC 10.5.6.5  Removed googleCalendarV3 from Labs
|| 03/01/13 RLB 10.5.6.5  Add lab for project time line
|| 03/15/13 GWG 10.5.6.6  Pulled a number of things out of labs
|| 03/20/13 MAS 10.5.6.6  Added activity widget
|| 03/27/13 RLB 10.5.6.6  Added Timeline Widget and lab
|| 04/23/13 RLB 10.5.6.7  Added right to see non project related events on the dialy feed widget
|| 04/29/13 RLB 10.5.6.7  (175860) Added right to view Project Setup Accounting Tab
|| 06/06/13 MFT 10.5.6.9  Added lab for PrintMedia
|| 06/11/13 CRG 10.5.6.9  Added new Media rights
|| 07/03/13 QMD 10.5.6.9  Added new Mobile App (Expense Reports)
|| 07/09/13 MFT 10.5.6.9  Added new tFinancialInstitution row (13)
|| 07/09/13 KMC 10.5.7.0  (184557) Added new right purch_approvecreditcardcharge for approving credit card charges
|| 07/23/13 MFT 10.5.6.9  Added new tFinancialInstitution row (14)
|| 08/23/13 GHL 10.5.7.1  Added 2 multicurrency gains and losses reports
|| 08/26/13 GHL 10.5.7.1  Added right to view forecasts from other AEs
|| 08/27/13 GHL 10.5.7.1  Added right to view forecasts
|| 09/03/13 GHL 10.5.7.2  Added USD currency
|| 09/03/13 RLB 10.5.7.2  (187734) Added right to view customfields on project dashboard
|| 09/06/13 GHL 10.5.7.2  Added multicurrency lab
|| 09/17/13 MFT 10.5.7.2  Added right 61700/purch_approvemyprojectvoucher to approve vendor invoices on projects assigned to 
|| 09/17/13 CRG 10.5.7.2  Added LockQty to Pages value in tMediaUnitType
|| 10/21/13 GHL 10.5.7.3  Added right to maintain currency rates
|| 10/24/13 WDF 10.5.7.3  (171844) Added new right prjViewTran for viewing the Project Transaction screens 
|| 10/31/13 MFT 10.5.7.3  Added new right prjnotesedit and changed prjnotes to Add only, reorganized project, admin rights to be together
|| 11/07/13 MFT 10.5.7.4  Added new right media_printbuysched
|| 11/11/13 WDF 10.5.7.4  (195542) Added new rights specificially for ToDos
|| 02/06/14 MFT 10.5.7.7  Changed media_printbuysched to media_printbuycal;Added media_printbuyblock & media_printbuygrid
|| 02/18/14 CRG 10.5.7.7  Fixed the POKind on the tMediaUnitType seeding
|| 03/06/14 WDF 10.5.7.8  (124798) Added new right 'acct_client_gl_pl_ytd' to split out Client P&L from Corp P&L
|| 03/25/14 GWG 10.5.7.8  Removed bank of america because of errors
|| 04/15/14 GWG 10.5.7.9  Added correct bofa url information
|| 04/17/14 KMC 10.5.7.9  (213294) Removed the lab/beta for deliverables
|| 04/29/14 MAS 10.5.7.9  Added adminUserSettings right 
|| 05/01/14 PLC 10.5.7.9  Added defaults Print USer dates 1 and 2 
|| 05/06/14 GHL 10.5.8.0  Changed INSERT 000 to INSERT (000) for media unit 
|| 05/14/14 GHL 10.5.8.0  Enabled the currency rate admin screen
|| 05/30/14 GHL 10.5.8.0  (218161) Removed lab NewLayoutBilling, we only use NewLayoutDesign now
|| 06/05/14 QMD 10.5.8.0  (218393) Added new right prjAssignTasksToMe
|| 06/09/14 RLB 10.5.8.1  (216811) Removed Bank of America from tFinancialInstitution
|| 06/26/14 KMC 10.5.8.1  (220472) Added right for viewing the Billing tab in project central, right ID 90926/prjDashBilling.
|| 07/02/14 QMD 10.5.8.1  (218393) Removed right prjAssignTasksToMe
|| 07/02/14 QMD 10.5.8.1  (220670) Added new right prjQuickAddTask and prjQuickAddActivity
|| 07/15/14 GWG 10.5.8.2  Changed the sort order of two rights for multi currency
|| 08/12/14 CRG 10.5.8.3  Added googleCalDAV Lab
|| 09/03/14 WDF 10.5.8.4  (225597) Added Custom Report (99000001)
|| 09/03/14 CRG 10.5.8.4  Removed googleCalDAV Lab
|| 09/23/14 MAS 10.5.8.4  Abelson & Taylor - added adminChangeBillingTitle right
|| 10/03/14 CRG 10.5.8.4  Added lab vPayment
|| 10/21/14 WDF 10.5.8.5  (231857) Added 'hideToDoNotes' and 'hideDiaryNotes' to tWidget.Settings where WidgetKey = 24 
|| 11/19/14 GAR 10.5.8.6  (236371) Added new security right.  Changed 'Edit Global Options' to 'Allow Access to Global Options: System Options '
||						  and added 'Allow Access to Global Options: Lists'.
|| 12/09/14 GHL 10.5.8.7  (229954) Added concentricChargeabilityRpt right for enhancement for Concentric 
|| 12/10/14 RLB 10.5.8.7  (239148) Removed Labs PO, Spec Sheet and Mass Billing
|| 01/09/15 GHL 10.5.8.8  (241893) Removed forecast lab, part of the general release now
|| 01/20/15 GHL 10.5.8.8  Added security right prjrecalclaborrates for Abelson Taylor
|| 01/26/15 GAR 10.5.8.8  (242601) Added jplChargeabilitySummary right for enhancement for JPL 
|| 01/26/15 GHL 10.5.8.8  Added prjChangeAnyoneCharges right to control the Anyone Allowed to Charge Time on projects for Abelson Taylor
|| 01/28/15 GHL 10.5.8.8  Added abelsonProjectResourceUtilization right to allow Abelson Taylor to use the HMI Project Resource Utilization rpt
|| 02/03/15 GAR 10.5.8.9  (244725) Changed Media Discrepancy Report to Media Details Report
|| 02/05/15 GWG 10.5.8.9  Move multi currency to labs
|| 02/09/15 GHL 10.5.8.9  Added right billingunwriteofftran to undo writeoffs for abelson taylor
|| 02/19/15 GHL 10.5.8.9  Added right prjViewTranAdjusted to view adjusted transactions for abelson Taylor
|| 03/05/15 GWG 10.5.9.0  Added Platinum review beta entry
|| 03/12/15 GHL 10.5.9.1  (241695) Added purch_viewbankinfo + purch_editbankinfo to control vendor's bank info for Spark44 enh
|| 05/01/15 GWG 10.5.9.2  Removed a label from one of the rights.
*/

/*
Script for generating level specific rights
Select 'INSERT tRightLevel(RightKey, CompanyKey, Level) Values (' + CAST(RightKey as Varchar) + ',100,1) --' + RightID from tRight 

Move Out
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (58,  0, 1, 'ClientInvoiceVoiding', 'Voiding Client Invoices', 'This allows you to void client invoices. If the invoice contains Time & Material lines, negative transactions will be created and applied to the voided invoices. And duplicate transactions will also be created and left unbilled.')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (33, 0, 1, 'artReview', '(BETA) New Deliverable Review System', 'WebDAV must be enabled in order to use this feature')
-- make it visible all the time. Make an option to show Reviews
-- When you add a deliverable, if they do not have webdav enabled, show an error message and tell them to upgrade
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (50, 0, 1, 'MassBilling', 'Mass Billing Screens', '')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (53, 0, 1, 'SpecEdit', 'New Specification entry screen', 'This gives you access to the new Specifications screens')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (17, 0, 1, 'PurchOrder', 'New Purchase Order entry screens', 'This gives you access to the new Purchase Order entry forms')
*/

DELETE tLab
-- to move out

-- Just Moved In
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (57,  0, 1, 'EstimateEdit', 'Template Estimates', 'This allows you to set up template estimates that are service only or segment and service')
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (43, 1, 1, 'googleContacts', '(BETA) Google Contacts', 'This will enable the settings needed to sync your google contacts with Workamajig')
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (42, 0, 1, 'forecast', 'Revenue Forecast', '')


INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (7,  0, 11, 'NewLayoutDesign', 'Setup New Invoice and Estimate Templates.', 'This gives you access to the new invoice and estimate designer, lets you set up layouts on clients, project, invoices and estimates to test printing')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (38, 0, 1, 'InterCompany', 'Inter Company Posting', 'Allows setup of intercompany mappings which opens up intercompany posting')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (39, 0, 1, 'RestrictToCompany', 'GL Company Security Restrictions', 'Enables setup of restrictions to only see certain companies')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (54, 0, 1, 'eStatement', 'Automatic Bank Reconciliation', '')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (56,  0, 1, 'MultiCurrency', 'Multicurrency Functionality', 'This allows you to enter transactions in foreign currencies')

-- Beta Items





INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (63,  1, 1, 'DFA', '(BETA) Double Click for Advertisers Integration', '')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (66,  1, 1, 'platReviews', '(BETA) Deliverable Review in Platinum', '')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (65,  1, 1, 'vPayment', '(BETA) American Express vPayment process', '')
INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (67,  1, 1, 'billingWorksheet', '(BETA) New Billing Worksheets', '')

--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (61,  1, 1, 'InteractiveMedia', '(BETA) Interactive Media screens', '')
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (55,  1, 1, 'PrintMedia', '(BETA) Print Media screens', '')
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (59,  1, 1, 'RadioMedia', '(BETA) Radio Media screens', '')
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (60,  1, 1, 'TVMedia', '(BETA) TV Media screens', '')
--INSERT tLab(LabKey, Beta, DisplayOrder, LabID, LabName, LabDescription) Values (62,  1, 1, 'OutdoorMedia', '(BETA) Outdoor Media screens', '')

--

/*


pushing this right through labs


 -- Special Development items


Next Key: 68

*/


DELETE tRight

/* -- Media Rights
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500050, 'media_viewWorksheet', 'View the Media Worksheet', 'media', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500060, 'media_editWorksheet', 'Edit the Media Worksheet', 'media', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303305, 'media_printbuycal', 'Media Print Buy Calendar Report', 'reports', 'admin', 6040, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303306, 'media_printbuyblock', 'Media Print Buy Block Report', 'reports', 'admin', 6041, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303307, 'media_printbuygrid', 'Media Print Buy Grid Report', 'reports', 'admin', 6042, 1)

*/

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11605, 'viewLegacyFields', 'View Legacy Fields', 'admin', 'admin', 25, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10100, 'adminsetup', 'Maintain Setup Information', 'admin', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10101, 'adminsetup_acctinfo', '---- Edit Account Information', 'admin', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10102, 'adminsetup_globaloptions', '---- Allow Access to Global Options: System Options', 'admin', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10115, 'adminsetup_globaloptionslists', '---- Allow Access to Global Options: Lists', 'admin', 'admin', 3, 1)
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
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10114, 'adminsetup_glcompanyaccess', '---- Edit GL Company Access', 'admin', 'admin', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10200, 'admineditinout', 'Edit Other Peoples In / Out Status', 'admin', 'admin', 16, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10600, 'adminemployee', 'Maintain Company Employees', 'admin', 'admin', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10620, 'adminuserconvert', 'Convert Contact to Employee or Employee to Contact', 'admin', 'admin', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10700, 'admineditlogin', 'Edit Employee and Contact Login information', 'admin', 'admin', 18, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10720, 'user_billing', 'Edit Employee and Contact Billing Information ', 'admin', 'admin', 19, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10750, 'adminviewcostrate', 'View labor net cost per hour in lookups and reports', 'admin', 'admin', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10800, 'adminedituserskills', 'Maintain User Skill Levels', 'admin', 'admin', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10805, 'admineditusercalendar', 'Maintain Employee Calendar ', 'admin', 'admin', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11200, 'reportsdesign', 'Design custom reports', 'admin', 'admin', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11300, 'reportsrun', 'Run custom reports', 'admin', 'admin', 24, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11400, 'dataexchange', 'Import and export data', 'admin', 'admin', 25, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11500, 'admineditlisting', 'Edit Custom Listings', 'admin', 'admin', 26, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11601, 'adminViewLog', 'View the System Log', 'admin', 'admin', 27, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11602, 'adminActivateMyLabs', 'Allow a person to enable labs just for themselves', 'admin', 'admin', 28, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11603, 'adminDisplayNonProjectLogs', 'View Non Project Log ', 'admin', 'admin', 29, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11604, 'adminUserSettings', 'Set Platinum User settings', 'admin', 'admin', 30, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (11606, 'adminChangeBillingTitle', 'Edit Employee Billing Title', 'admin', 'admin', 31, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90100, 'adminCreateProject', 'Create New Projects', 'project', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90200, 'prjInfo', 'Maintain Project Setup', 'project', 'admin', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (903510, 'prjReopen', 'Reopen Projects', 'project', 'admin', 30, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90310, 'prjviewtasks', 'View Task, Schedule Pages', 'project', 'admin', 40, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90355, 'prjeditmastertaskdefs', 'Edit Master Task defaults on task', 'project', 'admin', 50, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90810, 'prjEditLocked', 'Edit Projects in a Locked Status', 'project', 'admin', 60, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90315, 'prjviewbudget', 'View Project Budget Page', 'project', 'admin', 70, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90320, 'prjedittasks', 'Edit task information', 'project', 'admin', 80, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90850, 'prjUnlockLocked', 'Override Scheduling Lock', 'project', 'admin', 90, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90335, 'prjeditestimaterates', 'Edit Rates on Estimates', 'project', 'admin', 100, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90336, 'prjrecalcrates', 'Update Estimate Rates from Project', 'project', 'admin', 110, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90337, 'prjrecalclaborrates', 'Recalculate Labor Rates on Project', 'project', 'admin', 111, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90330, 'prjeditestimate', 'Edit Estimate Information', 'project', 'admin', 120, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (1190930, 'prjnotes', 'Add Project Diary Notes', 'project', 'admin', 130, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (1190931, 'prjnotesedit', 'Edit own Project Diary Notes', 'project', 'admin', 140, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90922, 'prjEditOthersDiary', 'Edit other peoples diary posts', 'project', 'admin', 150, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (903500, 'adminDeleteProject', 'Delete a Project', 'project', 'admin', 160, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90600, 'prjviewcreativebrief', 'View the Creative Brief', 'project', 'admin', 170, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90350, 'prjeditcreativebrief', 'Edit the Creative Brief', 'project', 'admin', 180, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90700, 'prjviewspecs', 'View the Project Specifications', 'project', 'admin', 190, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90360, 'prjeditspecs', 'Edit the Specifications', 'project', 'admin', 200, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90370, 'prjMiscExpense', 'Add and Edit Misc Expenses', 'project', 'admin', 210, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90340, 'prjunappestimate', 'Unapprove estimate or change order ', 'project', 'admin', 220, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20100, 'approveadd', 'Add and Edit Digital Art Reviews', 'project', 'admin', 230, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20300, 'approvedelete', 'Delete a Digital Art Reviews', 'project', 'admin', 240, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90905, 'prjViewTran', 'View Project Transactions', 'project', 'admin', 250, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90906, 'prjViewTranAdjusted', 'View Project Adjusted Transactions', 'project', 'admin', 251, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90900, 'prjViewCampaign', 'View Campaigns', 'project', 'admin', 260, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90800, 'prjEditCampaign', 'Edit Campaigns', 'project', 'admin', 270, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90901, 'prjEditTeam', 'Edit the Project Team (Workamajig Only)', 'project', 'admin', 280, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90911, 'prjDashStatus', 'View the current status on the project dashboard', 'project', 'admin', 290, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90912, 'prjDashDescription', 'View the project description on the project dashboard', 'project', 'admin', 300, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90913, 'prjDashSetup', 'View the setup information on the project dashboard', 'project', 'admin', 310, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90914, 'prjDashBrief', 'View the creative brief on the project dashboard', 'project', 'admin', 320, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90915, 'prjDashSpecs', 'View the spec sheets on the project dashboard', 'project', 'admin', 330, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90916, 'prjDashTeam', 'View the team list on the project dashboard', 'project', 'admin', 340, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90917, 'prjDashSnapshot', 'View the project snapshot on the project dashboard', 'project', 'admin', 350, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90918, 'prjAccessAny', 'Access any project', 'project', 'admin', 360, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90919, 'prjChargeAny', 'Charge any project', 'project', 'admin', 370, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90920, 'prjTimeCompletedTask', 'Charge time to completed tasks', 'project', 'admin', 380, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90921, 'prjExpenseCompletedTask', 'Charge expense to completed tasks', 'project', 'admin', 390, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90923, 'prjViewRevenueSource', 'View Project Revenue Source', 'project', 'admin', 400, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90924, 'prjViewSetupAccounting', 'View Project Setup Accounting', 'project', 'admin', 410, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90925, 'prjDashCustomFields', 'View the Project CustomFields', 'project', 'admin', 420, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90930, 'prjViewToDos', 'View To Dos', 'project', 'admin', 430, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90931, 'prjEditToDos', 'Add/Edit To Dos', 'project', 'admin', 440, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90932, 'prjDeleteToDos', 'Delete To Dos', 'project', 'admin', 450, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90933, 'prjViewOtherToDos', 'View To Dos Not Assigned To You', 'project', 'admin', 460, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90934, 'prjEditOtherToDos', 'Edit To Dos Not Assigned To You', 'project', 'admin', 470, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90935, 'prjQuickAddTask', 'Use Quick Task Add without being able to edit the schedule', 'project', 'admin', 480, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90936, 'prjQuickAddActivity', 'Use Quick Activity Add without being able to edit the schedule', 'project', 'admin', 481, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90937, 'prjChangeAnyoneCharges', 'Change Anyone Allowed to Charge Time on project', 'project', 'admin', 371, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30101, 'billingviewinvoice', 'View the Invoice List ', 'billing', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30100, 'billingeditinvoice', 'Add and Edit Client Invoices and Credits', 'billing', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30200, 'billingpayments', 'Enter Receipts', 'billing', 'admin', 3, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30300, 'br_viewarreports', '-- View AR Reports --', 'reports', 'admin', 4000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30310, 'br_viewapreports', '-- View AP Reports --', 'reports', 'admin', 5000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30320, 'br_viewglfinancial', '-- View Company Financial Reports --', 'reports', 'admin', 7000, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30330, 'br_viewmedia', '-- View Media Reports --', 'reports', 'admin', 6000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30700, 'billingdeposits', 'Edit Deposit Slips', 'billing', 'admin', 4, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30800, 'billingcreditcard', 'Edit and Charge Credit Cards', 'billing', 'admin', 5, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30900, 'billingretainers', 'Edit Retainers', 'billing', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30901, 'billingviewretainers', 'View Retainers', 'billing', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30902, 'billingremovefromsheet', 'Delete Worksheets and Remove Items from Worksheets', 'billing', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30903, 'billingedittran', 'Edit Transactions on Projects', 'billing', 'admin', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30904, 'billingaddtran', 'Add Transactions to Worksheets', 'billing', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30905, 'billingtransfertran', 'Transfer Transactions to other Projects', 'billing', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30906, 'billingwriteofftran', 'Write Off Transactions', 'billing', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (30907, 'billingunwriteofftran', 'Unwrite Off Transactions', 'billing', 'admin', 13, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40400, 'dash_showsnapshot', 'View the Project Snapshot', 'dashboard', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40500, 'dash_showprofit', 'View the Profit Snapshot', 'dashboard', 'admin', 2, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (50100, 'fileAccess', 'Access the File Folders', 'file', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (50110, 'fileSearchAll', 'Search in projects you are not assigned to', 'file', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60100, 'purch_editpo', 'Add and Edit PO''s', 'purch', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60300, 'purch_editvoucher', 'Add and Edit Vendor Invoices', 'purch', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60400, 'purch_usecreditcard', 'View and use credit card charge entry screens', 'purch', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60401, 'purch_addothercreditcardcharge', 'Add credit card charges for other employees', 'purch', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60402, 'purch_editothercreditcardcharge', 'Edit credit card charges of other employees', 'purch', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60403, 'purch_approvecreditcardcharge', 'Approve credit card charges', 'purch', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (60500, 'purch_usecreditcardconnect', 'View and use the credit card connect screen', 'purch', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61100, 'quote_edit', 'Add and Edit Quotes', 'purch', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61200, 'quote_createpo', 'Create PO''s from Quotes', 'purch', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61300, 'purch_editpayment', 'Add and Edit Payments', 'purch', 'admin', 9, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61400, 'purch_viewiteminfo', 'View Cost and Rate on Item Lookup ', 'purch', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61500, 'purch_editsignatureoncheck', 'Edit Electronic Signature on Checks', 'purch', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61600, 'purch_printchecks', 'Print Checks', 'purch', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61700, 'purch_approvemyprojectvoucher', 'Approve vendor invoices on your projects', 'purch', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61800, 'purch_viewbankinfo', 'View vendor bank information', 'purch', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (61900, 'purch_editbankinfo', 'Edit vendor bank information', 'purch', 'admin', 15, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70100, 'formuse', 'Use forms', 'form', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70200, 'formadd', 'Add new forms', 'form', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70300, 'formdelete', 'Delete forms', 'form', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70400, 'formviewall', 'View forms not assigned to the user', 'form', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (70500, 'nonauthorformdelete', 'Delete form if not author', 'form', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90300, 'prjviewprojectreports', '-- View Project Financial Reports --', 'reports', 'admin', 2000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100100, 'billingusetimesheet', 'Use Timesheets', 'time', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100110, 'time_editratelevel', 'Edit the rate level on the time sheet', 'time', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100120, 'timeallservices', 'Charge time to any service', 'time', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100130, 'timealltasks', 'Charge time to any task', 'time', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100300, 'billingtimesheetrate', 'View rates on the timesheet', 'time', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100400, 'billingviewalltime', 'View anyone''s timesheet', 'time', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100500, 'billinguseexpenses', 'Use Expenses', 'time', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100700, 'billingviewallexpense', 'View anyone''s expense report', 'time', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100800, 'billingeditanyone', 'Edit Time Sheets and Expense Reports for anyone', 'time', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (100900, 'billingtimesheetunapprove', 'Unapprove the timesheets', 'time', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (110300, 'traffic_viewschedule', 'View Project Schedules', 'traffic', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (110900, 'traffic_viewstaff', 'View Staff Scheduling and Loading', 'traffic', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (110950, 'traffic_viewassignment', 'Traffic Assignment Review', 'traffic', 'admin', 3, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200100, 'proj_projectsummary', 'Project Budget Analysis', 'reports', 'admin', 2010, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (200101, 'proj_projectscoreboard', 'Project Summary Scoreboard', 'reports', 'admin', 2011, 1)
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
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303302, 'media_discrepancy', 'Media Details Report', 'reports', 'admin', 6020, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303303, 'media_mixanalysis', 'Media Mix Analysis', 'reports', 'admin', 6030, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303304, 'media_billing', 'Media Billing Report', 'reports', 'admin', 6031, 1)
--INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303305, 'media_printbuycal', 'Media Print Buy Calendar Report', 'reports', 'admin', 6040, 1)
--INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303306, 'media_printbuyblock', 'Media Print Buy Block Report', 'reports', 'admin', 6041, 1)
--INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (303307, 'media_printbuygrid', 'Media Print Buy Grid Report', 'reports', 'admin', 6042, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (400100, 'acct_ar_aging', 'AR Account Aging', 'reports', 'admin', 4010, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401000, 'usereports', 'View the reports menu', 'reports', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401100, 'rptViewCMReports', '-- View Contact Management Reports --', 'reports', 'admin', 1000, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401200, 'rptCMBusDev', 'Business Development Meeting', 'reports', 'admin', 1001, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401300, 'rptCMDownOpps', 'Downgraded Opportunities', 'reports', 'admin', 1002, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500010, 'media_editio', 'Edit Insertion Orders', 'media', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500020, 'media_editbc', 'Edit Broadcast Orders', 'media', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500030, 'media_editestimate', 'Edit Media Estimates', 'media', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500040, 'media_traffic', 'View the Media Traffic Screen', 'media', 'admin', 6, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (601000, 'desktopEditSetup', 'Edit the company settings for the desktop (Workamajig Only)', 'desktop', 'admin', 1, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40600, 'dash_editcompanynotes', 'Edit the Company Wide Notes (CMP Only)', 'legacy', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40700, 'dash_editprojectnotes', 'Edit the Project Notes (CMP Only)', 'legacy', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (40800, 'dash_editcontactnotes', 'Edit the Contact Notes (CMP Only) (in contact management)', 'legacy', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (10500, 'admincontact', 'View the Company Address Book (CM Only)', 'legacy', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930000, 'cm_editcontacts', 'Edit contact information (CM Only)', 'legacy', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930100, 'cm_viewothermanagers', 'View Other Account Manager''s Opportunities and Activities (CM Only)', 'legacy', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930150, 'cm_dashboard', 'View the contact management dashboard (CM Only)', 'legacy', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930200, 'cm_viewleads', 'View and Edit Opportunities (CM Only)', 'legacy', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930400, 'cm_viewactivities', 'View Contact Activites (CM Only)', 'legacy', 'admin', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930500, 'cm_allowdelete', 'Delete contacts (CM Only)', 'legacy', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930600, 'cm_showall', 'See contacts they do not own (CM Only)', 'legacy', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930700, 'cm_alldb', 'See contacts in all databases (CM Only)', 'legacy', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120300, 'calviewcompany', 'View Company Meetings (CM Only)', 'legacy', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000000, 'br_viewlegacy', '-- View Legacy Reports --', 'legacy', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000001, 'legacy_proj_projectsummary', 'Project Budget Summary (Legacy)', 'legacy', 'admin', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000002, 'legacy_acct_projectprofit', 'Project Profitability (Legacy)', 'legacy', 'admin', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000003, 'legacy_acct_projectwip', 'Project WIP Report (Legacy)', 'legacy', 'admin', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (20000004, 'legacy_acct_gl_pl_ytd', 'Income Statement (Legacy)', 'legacy', 'admin', 18, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (401301, 'rptCMLeadList', 'Opportunity List (CMP Only)', 'legacy', 'admin', 19, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120100, 'calUseCalendar', 'Access the calendar', 'calendar', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120200, 'caladdmeetings', 'Add New Meetings', 'calendar', 'admin', 2, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120400, 'calBlockOutDays', 'Mark Calendar Events to block out days on the schedule', 'calendar', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120500, 'caleditglobalgroups', 'Maintain Global Distribution Groups', 'calendar', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (120600, 'foldersCalendar', 'Add/Edit/Delete Public Calendars', 'calendar', 'admin', 4, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931400, 'useLeads', 'Use Lead', 'cm', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931401, 'viewOtherLeads', 'View Leads You Do Not Own', 'cm', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931402, 'editOtherLeads', 'Edit Leads You Do Not Own', 'cm', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931403, 'addLeads', 'Add Leads', 'cm', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931404, 'deleteLeads', 'Delete Leads', 'cm', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931405, 'foldersLeads', 'Add/Edit/Delete Lead Folders', 'cm', 'admin', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931406, 'mergeLeads', 'Merge Leads', 'cm', 'admin', 16, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931600, 'useContacts', 'Use Contacts', 'cm', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931601, 'viewOtherContacts', 'View Contacts You Do Not Own', 'cm', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931602, 'editOtherContacts', 'Edit Contacts You Do Not Own', 'cm', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931603, 'addContacts', 'Add New Contacts', 'cm', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931604, 'deleteContacts', 'Delete Public Contacts', 'cm', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931605, 'moveFoldersContacts', 'Move Public Contacts to Private Folders', 'cm', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931606, 'foldersContacts', 'Add/Edit/Delete Public Contact Folders', 'cm', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931607, 'mergeContacts', 'Merge Contacts', 'cm', 'admin', 8, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931700, 'useCompanies', 'Use Companies', 'cm', 'admin', 8, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931701, 'viewOtherCompanies', 'View Companies You Do Not Own', 'cm', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931702, 'editOtherCompanies', 'Edit Companies You Do Not Own', 'cm', 'admin', 12, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931703, 'addCompanies', 'Add new Companies', 'cm', 'admin', 9, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931704, 'deleteCompanies', 'Delete Companies', 'cm', 'admin', 10, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931705, 'foldersCompanies', 'Add/Edit/Delete Company Folders', 'cm', 'admin', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931706, 'cm_editacctinfo', 'Edit Accounting Information', 'cm', 'admin', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931707, 'mergeCompanies', 'Merge Companies', 'cm', 'admin', 15, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931100, 'useOpp', 'Use Opportunities', 'cm', 'admin', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931101, 'viewOtherOpp', 'View Opportunities You Do Not Own', 'cm', 'admin', 18, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931102, 'editOtherOpp', 'Edit Opportunities You Do Not Own', 'cm', 'admin', 19, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931103, 'addOpp', 'Add New Opportunities', 'cm', 'admin', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931104, 'deleteOpp', 'Delete Opportunities', 'cm', 'admin', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931105, 'foldersOpp', 'Add/Edit/Delete Opportunity Folders', 'cm', 'admin', 20, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931500, 'useActivities', 'Use Activities', 'cm', 'admin', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931501, 'viewOtherActivities', 'View Activities Not Assigned To You', 'cm', 'admin', 24, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931507, 'editActivities', 'Edit Activities', 'cm', 'admin', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931502, 'editOtherActivities', 'Edit Activities Not Assigned To You', 'cm', 'admin', 25, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931503, 'deleteActivities', 'Delete Activities', 'cm', 'admin', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931504, 'foldersActivities', 'Add/Edit/Delete Public Activity Folders', 'cm', 'admin', 26, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931505, 'moveFoldersActivities', 'Move Public Activities to Private Folders', 'cm', 'admin', 27, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931506, 'activityAllwaysCheckOpp', 'Always Check for Opportunities on Activities', 'cm', 'admin', 28, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (931550, 'useMarketingLists', 'Use Marketing Lists', 'cm', 'admin', 29, 1)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930800, 'cm_viewclientlist', 'View the client list', 'cm', 'admin', 30, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (930900, 'cm_viewvendorlist', 'View the vendor list', 'cm', 'admin', 31, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940100, 'gl_glaccount', 'Maintain GL Accounts', 'acct', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940200, 'gl_journalentry', 'Enter Journal Entries', 'acct', 'admin', 2, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940300, 'gl_budget', 'Enter GL Budgets', 'acct', 'admin', 3, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940321, 'gl_forecast', 'Edit / View Revenue Forecasts', 'acct', 'admin', 12, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940320, 'gl_view_forecast_others', '---- View Revenue Forecasts from other AEs', 'acct', 'admin', 13, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940330, 'gl_currencyrates', 'Maintain Currency Exchange Rates', 'acct', 'admin', 13, 0)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940400, 'gl_accountrecs', 'Reconcile GL Accounts', 'acct', 'admin', 7, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940450, 'gl_post', 'Post Transaction to the General Ledger', 'acct', 'admin', 9, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940455, 'gl_unpost', 'Unpost Transaction to the General Ledger', 'acct', 'admin', 10, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940500, 'gl_postwip', 'Post WIP to GL', 'acct', 'admin', 8, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940600, 'laborbud_edit', 'Edit Labor Budgets', 'acct', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940610, 'laborbud_viewanyoffice', '---- Edit / View labor budgets for any office', 'acct', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940620, 'laborbud_viewanydept', '---- Edit / View labor budgets for any department', 'acct', 'admin', 6, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940630, 'chargesum_viewanyperson', '---- View any or all people on chargeability summary', 'acct', 'admin', 7, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (940700, 'accteditanytime', 'Edit transactions after approval', 'acct', 'admin', 11, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950000, 'acct_ap_aging', 'AP Account Aging', 'reports', 'admin', 5010, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950001, 'acct_ap_listing', 'AP Listing', 'reports', 'admin', 5020, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950002, 'acct_ap_1099', '1099 Vendor Detail', 'reports', 'admin', 5050, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950003, 'acct_po_listing', 'Purchase Order Listing', 'reports', 'admin', 5060, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950004, 'acct_po_project', 'Project PO Listing', 'reports', 'admin', 5070, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950005, 'acct_ap_checks', 'Payment Listing', 'reports', 'admin', 5080, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950006, 'acct_ar_invoicesummary', 'Invoice Summary', 'reports', 'admin', 4050, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950007, 'acct_ar_invoicelineitemsummary', 'Invoice Line Item Summary', 'reports', 'admin', 4060, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950120, 'acct_projectprofit', 'Project Profitability', 'reports', 'admin', 7128, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (400300, 'acct_projectwip', 'Project WIP Analysis', 'reports', 'admin', 2129, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950008, 'acct_gl_trailbal', 'Trial Balance', 'reports', 'admin', 7130, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950009, 'acct_gl_genledger', 'General Ledger', 'reports', 'admin', 7140, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950010, 'acct_gl_genjournal', 'General Journal', 'reports', 'admin', 7150, 0)

INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950011, 'acct_gl_pl_ytd', 'Income Statement Corporate', 'reports', 'admin', 7160, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950050, 'acct_client_gl_pl_ytd', 'Income Statement Client', 'reports', 'admin', 7165, 0)


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
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950121, 'acct_projectrealization', 'Project Hourly Realization Rate', 'reports', 'admin', 2016, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950130, 'acct_gl_statement_cashflow', 'Statement of Cash Flows', 'reports', 'admin', 7180, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950135, 'acct_gl_cashprojection', 'Cash Projection', 'reports', 'admin', 7185, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950136, 'acct_gl_uncleared', 'Uncleared Transactions', 'reports', 'admin', 7186, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950137, 'rptOverheadAllocationDetail', 'Overhead Allocation Details', 'reports', 'admin', 7187, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (950140, 'acct_metrics', 'Metrics Monitor', 'reports', 'admin', 7190, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960000, 'pr_viewrequests', 'View Project Requests', 'requests', 'admin', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960010, 'pr_addrequests', 'Add New Requests to the system', 'requests', 'admin', 2, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960020, 'pr_editrequests', 'Edit Existing Requests', 'requests', 'admin', 3, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960030, 'pr_deleterequests', 'Delete Existing Requests', 'requests', 'admin', 4, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960040, 'pr_editapproval', 'Edit the approval process', 'requests', 'admin', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960050, 'proj_projectassignments', 'Assigned Tasks', 'reports', 'admin', 3150, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960051, 'admin_employeehours', 'Employee Actual Hours Report', 'reports', 'admin', 2017, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960052, 'acct_gl_mc_realized', 'Multicurrency Realized Gains and Losses', 'reports', 'admin', 7191, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (960053, 'acct_gl_mc_unrealized', 'Multicurrency Unrealized Gains and Losses', 'reports', 'admin', 7192, 1)


INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (90000001, 'cbeditbatch', 'Edit Charge Back Batches', 'billing', 'ChargeCodes', 1, 0)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (91000000, 'muddAMRpt', 'AGI By Account Manager Report', 'reports', 'mudd', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (91000001, 'muddSMRpt', 'AGI By Sales Manager', 'reports', 'mudd', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (91000002, 'muddAMClientRpt', 'AGI By Account Manager or Client', 'reports', 'mudd', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (92000000, 'partnersnapierMonthyActualHours', 'Retainer Monthly Actual Hours', 'reports', 'partnersnapier', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (92000001, 'partnersnapierMonthyActualHrsBudget', 'Retainer Monthly Actual Hours with Budget', 'reports', 'partnersnapier', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (92000002, 'partnersnapierSalesJournal', 'Custom Sales Journal', 'reports', 'partnersnapier', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (93000001, 'cbreSBRpt', 'Custom Split Billing Invoice', 'reports', 'cbre', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (94000001, 'pyramidLaborRpt', 'Custom Project Labor Analysis', 'reports', 'pyramid', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (95000001, 'hmiProjectResourceUtilization', 'Custom Project Resource Utilization', 'reports', 'hmi', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (95000002, 'abelsonProjectResourceUtilization', 'Custom Project Resource Utilization', 'reports', 'abelson', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (96000001, 'bgbBillableHours', 'Project Billable Hours Summary', 'reports', 'bgb', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (97000001, 'bgbProjectReconciliationSummary', 'Project Reconciliation Summary', 'reports', 'bgb', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (98000000, 'boyScoutExport', 'Project Data Export', 'reports', 'boyscouts', 999, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (99000001, 'brittonTrafficRpt', 'Custom Time Detail Data', 'reports', 'britton', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (99100001, 'concentricChargeabilityRpt', 'Custom Utilization Report', 'reports', 'concentric', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (99200001, 'jplChargeabilitySummary', 'Custom Chargeability Summary', 'reports', 'jplcharge', 1, 1)




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
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500775, 'client_invoicesassigned', 'View Invoices for assigned projects', 'client', 'client', 13, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (500800, 'client_originalschedule', 'View the original schedule', 'client', 'client', 5, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501100, 'client_prview', 'View Project Requests', 'client', 'client', 14, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501200, 'client_pradd', 'Add New Project Requests', 'client', 'client', 15, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501300, 'client_predit', 'Edit Project Requests from their company', 'client', 'client', 16, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501400, 'client_prdelete', 'Can delete requests from their company', 'client', 'client', 17, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501450, 'client_praddnewspec', 'Can add and delete spec sheets on project requests', 'client', 'client', 24, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501500, 'client_dafiles', 'Can View Digital Asset Files', 'client', 'client', 18, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501550, 'client_dafilesupload', 'Can Upload Digital Asset Files', 'client', 'client', 19, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501600, 'client_projectlist', 'View the list of assigned projects', 'client', 'client', 1, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501700, 'client_notes', 'Add to the Project Diary', 'client', 'client', 20, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501710, 'client_editNotes', 'Edit Diary Notes', 'client', 'client', 21, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501800, 'client_myinfo', 'Change MyInfo data and password', 'client', 'client', 22, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501801, 'client_assignments', 'View Assigned Tasks', 'client', 'client', 23, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501810, 'client_daviewprior', 'Can view prior digital art reviews', 'client', 'client', 25, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501820, 'client_viewinvoicecompany', 'View Invoices for Company', 'client', 'client', 26, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501830, 'client_viewinvoiceparentcompany', 'View Invoices for Parent Company', 'client', 'client', 27, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501835, 'client_viewinvoicechildcompany', 'View Invoices for Child Company', 'client', 'client', 28, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501840, 'client_projectdescription', 'View the Project Description', 'client', 'client', 29, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501850, 'client_projectteam', 'View the Project Team', 'client', 'client', 30, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501860, 'client_creativebrief', 'View the Project Creative Brief', 'client', 'client', 31, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501870, 'client_projectspecs', 'View the Project Specifications', 'client', 'client', 32, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501880, 'client_editprojectspecs', 'Edit the Project Specifications', 'client', 'client', 33, 1)
INSERT tRight(RightKey, RightID, Description, RightGroup, SetGroup, DisplayOrder, CPM) Values (501890, 'client_viewprojectmisccost', 'View the Project Misc Cost', 'client', 'client', 34, 1)

DELETE tWidget Where CompanyKey is null

INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (1, NULL, 'RSS Reader', 'RSS Reader', 'main', 0, 'OtherRSSReader.swf', 'widgetOther', '<settings><Title>RSS READER</Title><rssUrl>http://www.groupamajig.com/forum/rss.php</rssUrl></settings>', 1, 1, 400, 400, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (2, NULL, 'Chargeability Summary', 'Displays the chargeability summary', 'main', 0, 'MetricsChargeabilitySummary.swf', 'widgetMetric', '<settings><title>CHARGEABILITY SUMMARY</title><laborBudgetKey>-1</laborBudgetKey><officeKey>-1</officeKey><departmentKey>-1</departmentKey><userKey>-1</userKey><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 295, 400, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (3, NULL, 'Metrics Monitor', 'Displays a single snapshot of all the metrics in the monitor', 'main', 0, 'MetricsMonitorSummary.swf', 'widgetMetric', '<settings><title>METRICS MONITOR</title><laborBudgetKey>0</laborBudgetKey><fullTimeHours>2048</fullTimeHours><GLCompanyKey>0</GLCompanyKey><GLCompanyID></GLCompanyID><GLCompanyName></GLCompanyName></settings>', 1, 1, 450, 325, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (4, NULL, 'Income By Service', 'Displays income by service', 'main', 0, 'MetricsIncomeByService.swf', 'widgetMetric', '<settings><title>INCOME BY SERVICE</title><numServices>5</numServices><dateRange>0</dateRange><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 285, 410, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (5, NULL, 'Vulnerability To Loss', 'Displays your revenue allocation by client', 'main', 0, 'MetricsVulnerabilityToLoss.swf', 'widgetMetric', '<settings><title>VULNERABILITY TO LOSS</title><dateRange>1</dateRange><calcMode>0</calcMode><GLCompanyKey>0</GLCompanyKey><GLCompanyID></GLCompanyID><GLCompanyName></GLCompanyName></settings>', 1, 1, 290, 480, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (6, NULL, 'Cash On Hand', 'Displays the amount of cash on hand', 'main', 0, 'MetricsCashOnHand.swf', 'widgetMetric', '<settings><title>CASH ON HAND</title><upperTarget>0</upperTarget><lowerTarget>0</lowerTarget><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (7, NULL, 'Revenue Per Employee', 'Displays the amount of revenue per employee', 'main', 0, 'MetricsRevenuePerEmployee.swf', 'widgetMetric', '<settings><title>REVENUE PER EMPLOYEE</title><laborBudgetKey>0</laborBudgetKey><fullTimeHours>2080</fullTimeHours><upperTarget>8500</upperTarget><lowerTarget>6000</lowerTarget><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (8, NULL, 'Repeat Clients', 'Displays the percentage of repeat clients', 'main', 0, 'MetricsRepeatClients.swf', 'widgetMetric', '<settings><title>REPEAT CLIENTS</title><upperTarget>80</upperTarget><lowerTarget>50</lowerTarget><dateRange>0</dateRange><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 300, 330, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (9, NULL, 'Markup By Item', 'Displays the Markup for each item', 'main', 0, 'MetricsMarkupByItem.swf', 'widgetMetric', '<settings><title>MARKUP BY ITEM</title><numItems>5</numItems><target>25</target><dateRange>1</dateRange><GLCompanyKey>0</GLCompanyKey><GLCompanyID></GLCompanyID><GLCompanyName></GLCompanyName></settings></settings>', 1, 1, 285, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (10, NULL, 'Chargeability Percentage', 'Displays the percentage of billable hours divided by total hours', 'main', 0, 'MetricsChargeabilityPercentage.swf', 'widgetMetric', '<settings><title>CHARGEABILITY PERCENTAGE</title><userKey>-1</userKey><upperTarget>75</upperTarget><lowerTarget>50</lowerTarget><dateRange>0</dateRange><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 295, 360, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (11, NULL, 'Write Off Summary', 'Displays the labor written off and the associated reason', 'main', 0, 'MetricsWriteOffSummary.swf', 'widgetMetric', '<settings><title>WRITE OFF SUMMARY</title><officeKey>-1</officeKey><departmentKey>-1</departmentKey><userKey>-1</userKey><dateRange>0</dateRange><glcompanyKey>-1</glcompanyKey></settings>', 1, 1, 320, 410, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (12, NULL, 'Billable Efficiency', 'Compares how much of your billable time you able to realize against your targets', 'main', 0, 'MetricsBillingEfficiency.swf', 'widgetMetric', '<settings><title>BILLABLE EFFICIENCY</title><laborBudgetKey>0</laborBudgetKey><GLCompanyKey>0</GLCompanyKey><GLCompanyID></GLCompanyID><GLCompanyName></GLCompanyName><dateRange>1</dateRange></settings>', 1, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (15, NULL, 'Tracking Forms', 'Displays a summary of any tracking forms that have been assigned to you', 'main', 0, 'OperationalForms.swf', 'widgetOperational', '', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (16, NULL, 'Active Projects', 'Diplays a list of all active projects you are assigned to', 'main', 0, 'OperationalActiveProjects.swf', 'widgetOperational', '<settings><title>ACTIVE PROJECTS</title><openAssignmentsOnly>0</openAssignmentsOnly><onlyProjectsOnTeam>1</onlyProjectsOnTeam><groupBy>None</groupBy><groupByOrder>ASC</groupByOrder><sortBy>None</sortBy><sortByOrder>ASC</sortByOrder><projectStatus>-1</projectStatus><billingStatus>-1</billingStatus><warningPercent>80</warningPercent><glcompanyKey>-1</glcompanyKey><layout></layout></settings>', 0, 1, 400, 630, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (17, NULL, 'My Tasks', 'Displays a summary of any tracking forms that have been assigned to you', 'main', 0, 'OperationalMyTasks.swf', 'widgetOperational', '<settings><title>MY TASKS</title><dateRange>0</dateRange><showOnRight>0</showOnRight><defaultSort>ProjectNumber</defaultSort><layout></layout><direction>Asc</direction><warningPerc>75</warningPerc><completedOnly>0</completedOnly><groupBy>NoGrouping</groupBy><groupByOrder>Asc</groupByOrder><ProjectTypeKey/><openToDoOnly/></settings>', 0, 1, 400, 700, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (21, NULL, 'My Items to Approve', 'View a summary of all the items you have to approve', 'main', 0, 'OperationalMyApprovals.swf', 'widgetOperational', '', 0, 1, 500, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (22, NULL, 'My Notes', 'Allows you to add a personal note to your desktop', 'main', 0, 'OperationalMyNote.swf', 'widgetOperational', '<settings><title>MY NOTES</title></settings>', 0, 1, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (23, NULL, 'Company Notes', 'View the company message on your desktop', 'main', 0, 'OperationalCompanyNote.swf', 'widgetOperational', '<settings><title>COMPANY NOTES</title></settings>', 0, 0, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (24, NULL, 'My Activities', 'View and update your contact management activities', 'main', 0, 'OperationalMyActivities.swf', 'widgetOperational', '<settings><title>MY ACTIVITIES</title><dateRange>1</dateRange><hideActivityNotes>0</hideActivityNotes><hideToDoNotes>0</hideToDoNotes><hideDiaryNotes>0</hideDiaryNotes><direction>ASC</direction></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (25, NULL, 'In Out Board', 'View who is in and out of the office', 'main', 0, 'OperationalInOutBoard.swf', 'widgetOperational', '<settings><title>IN/OUT BOARD</title></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (26, NULL, 'Today''s Meetings', 'View the events for today', 'main', 0, 'OperationalTodaysEvents.swf', 'widgetOperational', '<settings><title>TODAY''S MEETINGS</title><IncludePersonal>1</IncludePersonal><IncludePublic>0</IncludePublic><IncludeActivities>0</IncludeActivities></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (27, NULL, 'Today''s Time', 'View all your time entries for today', 'main', 0, 'OperationalTodaysTime.swf', 'widgetOperational', '<settings><title>TODAY''S TIME</title></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (29, NULL, 'Opportunity Pipeline', 'View the opportunity pipeline', 'main', 0, 'OpportunityPipeline.swf', 'widgetOperational', '<settings><title>OPPORTUNITY PIPELINE</title><accountManagerKey></accountManagerKey><entityValues>0</entityValues><entityText></entityText><ProjectTypeKey>-1</ProjectTypeKey><LeadStatusKey>-1</LeadStatusKey><AmountType>0</AmountType><GroupBy>1</GroupBy><ShowAs>0</ShowAs><glcompanyKey>-1</glcompanyKey><ShowInActive>0</ShowInActive></settings>', 0, 1, 250, 540, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (30, NULL, 'Opportunity Forecast', 'View the opportunity forecast', 'main', 0, 'OpportunityForecast.swf', 'widgetOperational', '<settings><title>OPPORTUNITY FORECAST</title><entityValues></entityValues><entityText></entityText><GroupedBy>1</GroupedBy><glcompanyKey>-1</glcompanyKey><ShowInActive>0</ShowInActive></settings>', 0, 1, 250, 540, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (31, NULL, 'Opportunity Outcome', 'View the opportunity pipeline', 'main', 0, 'OpportunityOutcome.swf', 'widgetOperational', '<settings><title>OPPORTUNITY OUTCOME</title><dateRange>1</dateRange><glcompanyKey>-1</glcompanyKey></settings>', 0, 1, 245, 445, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (32, NULL, 'Opportunity Closed By Person', 'View the opportunity pipeline', 'main', 0, 'OpportunityClosedByPerson.swf', 'widgetOperational', '<settings><title>OPPORTUNITY CLOSED BY PERSON</title><dateRange>1</dateRange><glcompanyKey>-1</glcompanyKey></settings>', 0, 1, 245, 445, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (33, NULL, 'Weather', 'Weather', 'main', 0, 'OtherWeather.swf', 'widgetOther', '<settings><title></title><city/><unittype>0</unittype><citycode/><country/><state/><location/><zipcode>000000</zipcode></settings>', 1, 1, 302, 280, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (34, NULL, 'Company Calendar', 'View all staff members'' calendars that you have access to.', 'main', 0, 'OperationalCompanyCalendar.swf', 'widgetOperational', '<settings><title>COMPANY CALENDAR</title><IncludePersonal>1</IncludePersonal><IncludePublic>0</IncludePublic><IncludeActivities>0</IncludeActivities><IncludeTasks>0</IncludeTasks><GroupBy>0</GroupBy><GLCompanyKey>0</GLCompanyKey><GLCompanyID></GLCompanyID><GLCompanyName></GLCompanyName></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (35, NULL, 'Revenue By Account Manager', 'Displays the amount of revenue by account manager', 'main', 0, 'MetricsRevenueByAccountManager.swf', 'widgetMetric', '<settings><title>REVENUE BY ACCOUNT MANAGER</title><dateRange>0</dateRange></settings>', 0, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (36, NULL, 'Revenue Trend', 'Displays the cumulative revenue trend for a twelve month period', 'main', 0, 'MetricsRevenueTrend.swf', 'widgetMetric', '<settings><title>REVENUE TREND</title><month>1</month><year></year><firstTarget>0</firstTarget><secondTarget>0</secondTarget><thirdTarget>0</thirdTarget><fourthTarget>0</fourthTarget><entityValues></entityValues><entityText></entityText><glcompanyKey>-1</glcompanyKey><ShowInActive>0</ShowInActive></settings>', 0, 1, 345, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (37, NULL, 'Activity Counts', 'View a summary of the activities', 'main', 0, 'ActivityCounts.swf', 'widgetMetric', '<settings><title>ACTIVITY COUNTS</title><activityTypeKeys></activityTypeKeys><assignedUserKeys></assignedUserKeys><ShowInActive>0</ShowInActive></settings>', 1, 1, 300, 345, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (99, NULL, 'Sticky Note', 'Allows you to add a sticky note to your desktop', 'main', 0, 'OperationalStickyNote.swf', 'widgetOperational', '<settings><title>STICKY NOTE</title><noteText></noteText></settings>', 0, 1, 500, 500, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (38, NULL, 'Scheduled Transactions', 'Shows a list of scheduled transactions that need to be generated', 'main', 0, 'OperationalRecurTran.swf', 'widgetOperational', NULL, 0, 0, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (39, NULL, 'Account Balances', 'Shows a grid current for specific GL account type and the balances for those accounts', 'main', 0, 'MetricsAccountBalances.swf', 'widgetMetric', '<settings><title>ACCOUNT BALANCE</title><glCompanyKey>-1</glCompanyKey>0<glAccountType></glAccountType></settings>', 1, 1, 300, 300, 1, GETDATE())
INSERT tWidget(WidgetKey, CompanyKey, DisplayName, Description, WidgetType, WidgetGroup, SourceFile, Icon, Settings, UserEdit, HasSettings, Height, Width, CanResize, LastModified) Values (40, NULL, 'The Daily Feed', 'View actions of the day', 'main', 0, 'OperationalActivityHistory.swf', 'widgetOperational', '<settings><title>The Daily Feed</title><groupBy>1</groupBy><userKey>-1</userKey><departmentKey>-1</departmentKey><projectOptions>0</projectOptions><glCompanyKey>-1</glCompanyKey></settings>', 1, 1, 500, 500, 1, GETDATE())

DELETE tString
DELETE tStringGroup

INSERT tStringGroup(StringGroupKey, StringGroupName, DisplayOrder) Values (2, 'Projects', 2)
INSERT tStringGroup(StringGroupKey, StringGroupName, DisplayOrder) Values (6, 'Publication Dates', 6)
INSERT tStringGroup(StringGroupKey, StringGroupName, DisplayOrder) Values (7, 'Broadcast Dates', 7)
INSERT tStringGroup(StringGroupKey, StringGroupName, DisplayOrder) Values (8, 'General', 1)
INSERT tStringGroup(StringGroupKey, StringGroupName, DisplayOrder) Values (9, 'Digital Art Review Fields', 8)

INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('KeyUser1', 2, 'Key Person 1', NULL, NULL, 2, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('KeyUser2', 2, 'Key Person 2', NULL, NULL, 3, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('KeyUser3', 2, 'Key Person 3', NULL, NULL, 4, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('KeyUser4', 2, 'Key Person 4', NULL, NULL, 5, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('KeyUser5', 2, 'Key Person 5', NULL, NULL, 6, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('KeyUser6', 2, 'Key Person 6', NULL, NULL, 7, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaPrint1', 6, 'User Defined 1', 'Order Close', NULL, 1, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaPrint2', 6, 'User Defined 2', 'Material Close', NULL, 2, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaPrint3', 6, 'User Defined 3', NULL, NULL, 3, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaPrint4', 6, 'User Defined 4', NULL, NULL, 4, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaPrint5', 6, 'User Defined 5', NULL, NULL, 5, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaPrint6', 6, 'User Defined 6', NULL, NULL, 6, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaBroadcast1', 7, 'User Defined 1', NULL, NULL, 1, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaBroadcast2', 7, 'User Defined 2', NULL, NULL, 2, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaBroadcast3', 7, 'User Defined 3', NULL, NULL, 3, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaBroadcast4', 7, 'User Defined 4', NULL, NULL, 4, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaBroadcast5', 7, 'User Defined 5', NULL, NULL, 5, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('MediaBroadcast6', 7, 'User Defined 6', NULL, NULL, 6, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('Client', 8, 'Client', 'Client', 'Clients', 1, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('DARApprovalOption1', 9, 'Approval Status Option 1', 'Approved As Is', NULL, 1, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('DARApprovalOption2', 9, 'Approval Status Option 2', 'Approved With Comments', NULL, 2, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('DARApprovalOption3', 9, 'Approval Status Option 3', 'See Comments and Resubmit', NULL, 3, 0, NULL)
INSERT tString(StringID, StringGroupKey, DisplayName, StringSingular, StringPlural, DisplayOrder, AllowDD, DefaultDD) Values ('DARApprovalOption4', 9, 'Approval Status Option 4', 'Rejected', NULL, 4, 0, NULL)

DELETE tNotification

INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('ODTIME', 'Overdue Timesheets', 1, 2, 'This will notify you on a daily basis of any timesheets that should have been submitted, but have not yet been sent out.', 1, NULL, '1*All People|2*People where I approve their time|3*People I supervise', NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('NOHOURS', 'Missing Time', 1, 1, 'This will send you a daily email of all people who did not enter their hours the prior day', 2, 'For', '1*All People|2*People where I approve their time|3*People I supervise', NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('TASKUPDATE', 'Updates to Task Information', 2, 2, 'This will immediately send you an email whenever there is an update to the actual project information', 2, 'For', '1*All Projects I am Assigned to|2*Projects where I am the account manager|3*Only Projects in my office', NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('NEWPROJECT', 'New Projects', 2, 1, 'This will immediately send you an email when a project is added to the system', 1, NULL, NULL, NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('NEWVENDOR', 'New Vendors', 2, 4, 'This will immediately send you an email when a vendor is added to the system', 1, NULL, NULL, NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('NEWCLIENT', 'New Clients', 2, 5, 'This will immediately send you an email when a client is added to the system', 1, NULL, NULL, NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('UPDATESTATUS', 'Changes in Project Status', 2, 3, 'This will immediately notify you when the production status code changes on a project', 2, 'for', '1*All Projects I am Assigned to|2*Projects where I am the account manager|3*Only Projects in my office|4*All Projects', NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('OVERBUDGET', 'Overbudget Projects', 1, 1, 'This will send you an email on a daily basis of all overbudget (in terms of total dollars) projects. This will only work on projects with an approved budget.', 2, 'For', '1*My Projects|2*Projects where I am the account manager|3*Projects in my office|4*All Projects', '-30*Projects within 30% of Budget|-20*Projects within 20% of Budget|-10*Projects within 10% of Budget|-5*Projects within 5% of Budget|0*All Projects at budget|5*Projects 5 % over budget|10*Projects 10 % over budget|20*Projects 20 % over budget')
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('OVERBUDGETTASK', 'Overbudget Tasks', 1, 2, 'This will send you an email on a daily basis of all overbudget (in terms of total dollars) tasks. This will only work on projects with an approved budget.', 2, 'For', '1*My Projects|2*Projects where I am the account manager|3*Projects in my office|4*All Projects', '-30*Tasks within 30% of Budget|-20*Tasks within 20% of Budget|-10*Tasks within 10% of Budget|-5*Tasks within 5% of Budget|0*All Tasks at budget|5*Tasks 5 % over budget|10*Tasks 10 % over budget|20*Tasks 20 % over budget')
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('OVERBUDGETSERVICE', 'Overbudget by Service', 1, 3, 'This will send you an email on a daily basis of all overbudget (in terms of total dollars) services. This will only work on projects with an approved budget.', 2, 'For', '1*My Projects|2*Projects where I am the account manager|3*Projects in my office|4*All Projects', '-30*Services within 30% of Budget|-20*Services within 20% of Budget|-10*Services within 10% of Budget|-5*Services within 5% of Budget|0*All Services at budget|5*Services 5 % over budget|10*Services 10 % over budget|20*Services 20 % over budget')
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('OVERBUDGETITEM', 'Overbudget by Item', 1, 3, 'This will send you an email on a daily basis of all overbudget (in terms of total dollars) items. This will only work on projects with an approved budget.', 2, 'For', '1*My Projects|2*Projects where I am the account manager|3*Projects in my office', '-30*Items within 30% of Budget|-20*Items within 20% of Budget|-10*Items within 10% of Budget|-5*Items within 5% of Budget|0*All Items at budget|5*Items 5 % over budget|10*Items 10 % over budget|20*Items 20 % over budget')
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('ODBILLING', 'Overdue Billing Worksheets', 1, 4, 'This will notify you on a daily basis of any billing worksheets that should have been approved, but have not yet been approved.', 2, 'For', '1*My Billing Worksheets|2*All Billing Worksheets', NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('ODESTIMATE', 'Overdue Project Estimates', 1, 5, 'This will notify you on a daily basis of any estimates that should have been approved, but have not yet been approved.', 2, 'For', '1*My Estimates|2*All Estimates', NULL)
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('TASKREMINDER', 'Task Reminders', 1, 6, 'This will notify you when tasks you are assigned to are about to be due. This email goes out once a day', 2, 'For', '1*My Assigned Tasks on Active Projects|2*All Tasks on Active Projects I am assigned to|3*All Tasks on Active Projects I am the Account Manager', '0*Due On or Before Today|3*Due in the next 3 days|7*Due in the next 7 days|14*Due in the next 14 Days')
INSERT tNotification(NotificationID, NotificationName, DisplayGroup, DisplayOrder, Description, ValueType, ValueLabel, ValueDropDown, ValueDropDown2) Values ('DELIVERABLE', 'Daily Deliverable Status', 1, 6, 'This will send you a daily status email of all deliverables that have been sent for review and have approaching due dates', 2, 'For', '1*All Deliverables I own on Active Projects|2*All Deliverables on Active Projects I am assigned to|3*All Deliverables on Active Projects I am the Account Manager', '0*Due On or Before Today|2*Due in the next 2 days|3*Due in the next 3 days|5*Due in the next 5 days')




-- tMobileMenu
DELETE tMobileMenu
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (1,  1, 1,'', 'Projects', 'projects.aspx?m=searchPage', 'projectSearchList', 'menuProjects')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (2,  2, 1,'', 'My Tasks', 'tasks.aspx?m=searchPage', 'taskSearchList', 'menuMyTasks')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (3,  3, 1,'calUseCalendar', 'Calendar', 'calendar.aspx?m=mainUI', 'mainCalendar', 'menuCalendar')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (6,  4, 1, 'useCompanies', 'Companies', 'clients.aspx?m=searchPage', 'clientSearchList', 'menuCompanies')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (7,  5, 1,'useContacts', 'Contacts', 'contacts.aspx?m=searchPage', 'contactSearchList', 'menuContacts')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (8,  6, 1,'useActivities', 'Activities', 'activities.aspx?m=searchPage', 'activitySearchList', 'menuActivities')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (4,  7, 1,'billingusetimesheet', 'Timesheets', 'timeentry.aspx?m=searchPage', 'timeSheetSearchList', 'menuTimesheets')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (5,  8, 1,'', 'Approvals', 'approvals.aspx?m=searchPage', 'approvalList', 'menuApprovals')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (9,  9, 1,'useOpp', 'Opportunities', 'opportunities.aspx?m=searchPage', 'opportunitySearchList', 'menuOpportunities')
--INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) Values (10,  10, 1,'', 'Project Requests', 'projectRequests.aspx?m=searchPage', 'projectRequestSearch', 'menuProjectRequests')
INSERT tMobileMenu (MobileMenuKey, DefaultDisplayOrder, DefaultSelection, RightID, Label, DataURL, PageID, Class) VALUES (11, 11, 1, 'billinguseexpenses', 'Expense Reports', 'expenseReports.aspx?m=searchPage', 'expenseReportSearchList', 'menuExpenseReports')

/*
Delete tMobileSearchCondition Where MobileSearchKey in (Select MobileSearchKey from tMobileSearch Where UserKey is NULL)
Delete tMobileSearch Where UserKey is NULL

set identity_insert tMobileSearch on
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (1, NULL, 'Project', NULL, 'Due In the Next Two Weeks', 'Project Due Date', 'ASC', 'Client ID and Name', 1, 3, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (2, NULL, 'Project', NULL, 'Active Projects By Client', 'Project Number', 'ASC', 'Client ID and Name', 2, 1, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (3, NULL, 'Project', NULL, 'Active Projects By Status', 'Project Number', 'ASC', 'Project Status', 3, 2, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (4, NULL, 'Contact', NULL, 'My Contacts', 'LastName', 'ASC', 'None', 1, 4, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (5, NULL, 'Contact', NULL, 'Contacts with an Activity in the next Week', 'Next Activity Date', 'ASC', NULL, 2, 5, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (6, NULL, 'Contact', NULL, 'All Active Contacts', 'Contact First Name', 'ASC', NULL, 3, 6, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (7, NULL, 'MyTasks', NULL, 'Due In The Next 7 Days', 'Task Plan Completion Date', 'ASC', 'Priority', 1, 6, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (8, NULL, 'MyTasks', NULL, 'By Priority', 'Task Plan Completion Date', 'ASC', 'Priority', 2, 7, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (9, NULL, 'Opportunity', NULL, 'My Opportunities', 'Forecasted Close Date', 'ASC', 'Stage Name', 1, 8, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (10, NULL, 'Opportunity', NULL, 'Opportunities By Stage', 'Forecasted Close Date', 'ASC', 'Stage Name', 2, 9, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (11, NULL, 'Opportunity', NULL, 'Opportunities By Status', 'Forecasted Close Date', 'ASC', 'Status', 3, 10, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (13, NULL, 'Activity', NULL, 'Due By Today', 'Activity Date', 'ASC', 'Activity Priority', 2, 12, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (14, NULL, 'Activity', NULL, 'All Activities', 'Activity Date', 'ASC', NULL, 3, 13, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (15, NULL, 'TimeSheet', NULL, 'All Open', 'Start Date', 'DESC', 'Approval Status', 1, 14, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (16, NULL, 'TimeSheet', NULL, 'All Completed', 'Start Date', 'DESC', 'Name', 2, 15, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (17, NULL, 'TimeSheet', NULL, 'My Open Time Sheets', 'Start Date', 'DESC', 'Approval Status', 3, 16, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (18, NULL, 'TimeSheet', NULL, 'My Completed Time Sheets', 'Start Date', 'DESC', NULL, 4, 17, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (19, NULL, 'ProjectRequest', NULL, 'Open Requests', 'Date Added', 'DESC', 'Client ID and Name', 1, 18, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (20, NULL, 'ProjectRequest', NULL, 'All Requests', 'Date Added', 'DESC', 'Client ID and Name', 2, 19, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (21, NULL, 'Company', NULL, 'My Companies', 'Company Name', 'ASC', NULL, 1, 20, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (22, NULL, 'Company', NULL, 'Clients', 'Company Name', 'ASC', NULL, 2, 21, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (23, NULL, 'Company', NULL, 'Vendors', 'Vendor ID', 'ASC', NULL, 3, 22, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (24, NULL, 'Company', NULL, 'All Companies', 'Company Name', 'ASC', NULL, 23, NULL, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (12, NULL, 'Activity', NULL, 'My Activities', 'Activity Date', 'DESC', 'Assigned To', 1, 11, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (25, NULL, 'ExpenseReport', NULL, 'All Open', 'Start Date', 'DESC', 'Full Name', 1, 24, 1, 0)
INSERT tMobileSearch(MobileSearchKey, CompanyKey, ListID, UserKey, SearchName, SortField, SortDirection, GroupField, DisplayOrder, StdSearchKey, StandardSearch, Deleted) Values (26, NULL, 'ExpenseReport', NULL, 'My Expense Reports', 'Start Date', 'DESC', NULL, 1, 25, 1, 0)
set identity_insert tMobileSearch off


set identity_insert tMobileSearchCondition on
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (1, 1, 'Project Due Date', 'Is On or Before 2 Weeks From Today', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (2, 2, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (3, 3, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (4, 4, 'Contact Owner', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (5, 5, 'Next Activity Date', 'Is On or Before A Week From Today', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (6, 6, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (7, 7, 'Assigned Staff', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (8, 7, 'Percentage Complete', 'Less Than', '100', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (9, 7, 'Task Plan Completion Date', 'Is On or Before A Week From Today', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (10, 7, 'Active Project', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (11, 8, 'Percentage Complete', 'Less Than', '100', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (12, 8, 'Predecessors Completed', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (13, 8, 'Active Project', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (14, 9, 'Opportunity Owner Name', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (15, 9, 'Actual Close Date', 'Is Blank', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (16, 10, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (17, 11, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (18, 12, 'Assigned To', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (19, 12, 'Activity Date Completed', 'Is Blank', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (20, 13, 'Assigned To', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (21, 13, 'Activity Date', 'Is On or Before Today', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (22, 15, 'Edit Status', 'Equal To', 'Open', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (23, 16, 'Approval Status', 'Equal To', 'Approved', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (24, 17, 'Name', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (25, 17, 'Edit Status', 'Equal To', 'Open', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (26, 18, 'Name', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (27, 18, 'Approval Status', 'Equal To', 'Approved', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (28, 19, 'Request Status', 'Not Equal To', 'Completed', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (29, 21, 'Account Manager Full Name', 'Equal to My Name', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (30, 21, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (31, 22, 'Client ID', 'Is Not Blank', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (32, 22, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (33, 23, 'Vendor ID', 'Is Not Blank', NULL, NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (34, 23, 'Active', 'Equal To', 'YES', NULL)
INSERT tMobileSearchCondition(MobileSearchConditionKey, MobileSearchKey, FieldName, Condition, Value1, Value2) Values (35, 26, 'Full Name', 'Equal to My Name', NULL, NULL)
set identity_insert tMobileSearchCondition off

*/

delete tFinancialInstitution
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(1, 'American Express (credit card)','3101','AMEX','https://online.americanexpress.com/myca/ofxdl/desktop/desktopDownload.do?request_type=nl_ofxdownload')

--INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(4, 'Bank of America','5959','HAN','https://eftx.bankofamerica.com/eftxweb/access.ofx')

INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(5, 'Capital One Bank','1001','Hibernia','https://onlinebanking.capitalone.com/ofx/process.ofx')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(6, 'Chase (credit card)','10898','B1','https://ofx.chase.com')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(7, 'Citi Bank (credit card)','24909','Citigroup','https://www.accountonline.com/cards/svc/citiofxmanager.do')
--INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(7, 'Citi Bank (credit card)','24909','Citigroup','https://secureofx2.bankhost.com/citi/cgi-forte/ofx_rt?servicename=ofx_rt&pagename=ofx')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(8, 'Discover Card (credit card)','7101','Discover Financial Services','https://ofx.discovercard.com/')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(9, 'LaSalle Bank','1101','LaSalleBankMidwest','https://www.oasis.cfree.com/1101.ofxgp')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(10, 'National City','5860','NATIONAL CITY','https://ofx.nationalcity.com/ofx/OFXConsumer.aspx')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(11, 'PNC Bank','4501','ISC','https://www.oasis.cfree.com/test.ofxgp')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(12, 'Wachovia','4309','Wachovia','https://pfmpw.wachovia.com/cgi-forte/fortecgi?servicename=ofx&pagename=PFM')
INSERT tFinancialInstitution(FinancialInstitutionKey, FIName, FIID, FIOrg, FIUrl) Values(13, 'Union Bank of California','2901','Union Bank of California','https://www.oasis.cfree.com/2901.ofxgp')


Delete tMediaUnitType
-- print
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2, LockQty) Values (1001, 1, 1, 'PGS', 'Pages', NULL, NULL, 1)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1002, 1, 2, 'CM', 'Centimeters', 'Col', 'CM')
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1003, 1, 3, 'IN', 'Inches', 'Col', 'Inches')
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1004, 1, 4, 'LI', 'Lines', 'Col', 'Lines')
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1005, 1, 5, 'INS', 'Insertions', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1006, 1, 6, 'INSERT', 'Inserts', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1007, 1, 7, 'INSERT (000)', 'Inserts (000)', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1008, 1, 8, 'IMPS', 'Impressions Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1009, 1, 9, 'IMPS (000)', 'Impressions (000) Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1010, 1, 10,'RG', 'Responses Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1011, 1, 11, 'RG (000)', 'Responses (000) Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1012, 1, 12, 'U', 'Units', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1013, 1, 13, 'U (000)', 'Units (000)', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1014, 1, 14, 'AQ', 'Acquisitions', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1015, 1, 15, 'AQ (000)', 'Acquisitions (000)', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (1016, 1, 16, 'OTH', 'Other', NULL, NULL)

-- broadcast
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (2001, 2, 1, 'OTH', 'Other', NULL, NULL)

-- interactive
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3001, 4, 1, 'CLK', 'Clicks Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3002, 4, 2, 'INS', 'Insertions', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3003, 4, 3, 'CLK (000)', 'Clicks (000) Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3004, 4, 4, 'U', 'Units', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3005, 4, 5, 'U (000)', 'Units (000)', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3006, 4, 6, 'AQ', 'Acquisitions', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3007, 4, 7, 'AQ (000)', 'Acquisitions (000)', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3008, 4, 8, 'GRP', 'GRP''s', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3009, 4, 9, 'GRP (000)', 'Engagements', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (3010, 4, 10, 'OTH', 'Other', NULL, NULL)

-- Outdoor
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4001, 5, 1, 'INS', 'Insertions', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4002, 5, 2, 'IMPS', 'Impressions Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4003, 5, 3, 'IMPS (000)', 'Impressions (000) Guaranteed', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4004, 5, 4, 'U', 'Units', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4005, 5, 5, 'U (000)', 'Units (000)', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4006, 5, 6, 'SHW', 'Showings', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4007, 5, 7, 'SCR', 'Screens', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4008, 5, 8, 'GRP', 'GRP''s', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4009, 5, 9, 'GRP (000)', 'Engagements', NULL, NULL)
INSERT tMediaUnitType(MediaUnitTypeKey, POKind, DisplayOrder, UnitTypeID, UnitTypeName, Qty1, Qty2) Values (4010, 5, 10, 'OTH', 'Other', NULL, NULL)

-- Run this on PAAdmin if more currencies are added
delete tCurrency

Insert tCurrency (CurrencyID, Description) Values('AED', 'Arab Emirates Dirham')
Insert tCurrency (CurrencyID, Description) Values('ARS', 'Argentine Peso')
Insert tCurrency (CurrencyID, Description) Values('AUD', 'Australian Dollar')
Insert tCurrency (CurrencyID, Description) Values('AWG', 'Aruban Florin')
Insert tCurrency (CurrencyID, Description) Values('BAM', 'Convertible Mark')
Insert tCurrency (CurrencyID, Description) Values('BBD', 'Barbadian Dollar')
Insert tCurrency (CurrencyID, Description) Values('BDT', 'Bangladeshi Taka')
Insert tCurrency (CurrencyID, Description) Values('BGN', 'Bulgarian Lev')
Insert tCurrency (CurrencyID, Description) Values('BHD', 'Bahraini Dinar')
Insert tCurrency (CurrencyID, Description) Values('BMD', 'Bermudian Dollar')
Insert tCurrency (CurrencyID, Description) Values('BOB', 'Bolivian Boliviano')
Insert tCurrency (CurrencyID, Description) Values('BRL', 'Brazilian Real')
Insert tCurrency (CurrencyID, Description) Values('BSD', 'Bahamian Dollar')
Insert tCurrency (CurrencyID, Description) Values('CAD', 'Canadian Dollar')
Insert tCurrency (CurrencyID, Description) Values('CHF', 'Swiss Franc')
Insert tCurrency (CurrencyID, Description) Values('CLP', 'Chilean Peso')
Insert tCurrency (CurrencyID, Description) Values('CNY', 'Chinese Yuan')
Insert tCurrency (CurrencyID, Description) Values('COP', 'Colombian Peso')
Insert tCurrency (CurrencyID, Description) Values('CZK', 'Czech Koruna')
Insert tCurrency (CurrencyID, Description) Values('DKK', 'Danish Krone')
Insert tCurrency (CurrencyID, Description) Values('EGP', 'Egyptian Pound')
Insert tCurrency (CurrencyID, Description) Values('EUR', 'Euro')
Insert tCurrency (CurrencyID, Description) Values('FJD', 'Fijian Dollar')
Insert tCurrency (CurrencyID, Description) Values('GBP', 'British Pound Sterling')
Insert tCurrency (CurrencyID, Description) Values('GHS', 'Ghana Cedi')
Insert tCurrency (CurrencyID, Description) Values('GMD', 'Gambian Dalasi')
Insert tCurrency (CurrencyID, Description) Values('GTQ', 'Guatemalan Quetzal')
Insert tCurrency (CurrencyID, Description) Values('HKD', 'Hong Kong Dollar')
Insert tCurrency (CurrencyID, Description) Values('HRK', 'Croatian Kuna')
Insert tCurrency (CurrencyID, Description) Values('HUF', 'Hungarian Forint')
Insert tCurrency (CurrencyID, Description) Values('IDR', 'Indonesian Rupiah')
Insert tCurrency (CurrencyID, Description) Values('ILS', 'Israeli Sheqel')
Insert tCurrency (CurrencyID, Description) Values('INR', 'Indian Rupee')
Insert tCurrency (CurrencyID, Description) Values('ISK', 'Icelandic Krona')
Insert tCurrency (CurrencyID, Description) Values('JMD', 'Jamaican Dollar')
Insert tCurrency (CurrencyID, Description) Values('JOD', 'Jordanian Dinar')
Insert tCurrency (CurrencyID, Description) Values('JPY', 'Japanese Yen')
Insert tCurrency (CurrencyID, Description) Values('KES', 'Kenyan Shilling')
Insert tCurrency (CurrencyID, Description) Values('KHR', 'Cambodian Riel')
Insert tCurrency (CurrencyID, Description) Values('KRW', 'South Korean Won')
Insert tCurrency (CurrencyID, Description) Values('KWD', 'Kuwaiti Dinar')
Insert tCurrency (CurrencyID, Description) Values('LAK', 'Lao Kip')
Insert tCurrency (CurrencyID, Description) Values('LBP', 'Lebanese Pound')
Insert tCurrency (CurrencyID, Description) Values('LKR', 'Sri Lankan Rupee')
Insert tCurrency (CurrencyID, Description) Values('LTL', 'Lithuanian Litas')
Insert tCurrency (CurrencyID, Description) Values('LVL', 'Latvian Lats')
Insert tCurrency (CurrencyID, Description) Values('MAD', 'Moroccan Dirham')
Insert tCurrency (CurrencyID, Description) Values('MDL', 'Moldovan Leu')
Insert tCurrency (CurrencyID, Description) Values('MGA', 'Malagasy Ariary')
Insert tCurrency (CurrencyID, Description) Values('MKD', 'Macedonian Denar')
Insert tCurrency (CurrencyID, Description) Values('MUR', 'Mauritian Rupee')
Insert tCurrency (CurrencyID, Description) Values('MVR', 'Maldivian Rufiyaa')
Insert tCurrency (CurrencyID, Description) Values('MXN', 'Mexican Peso')
Insert tCurrency (CurrencyID, Description) Values('MYR', 'Malaysian Ringgit')
Insert tCurrency (CurrencyID, Description) Values('NAD', 'Namibian Dollar')
Insert tCurrency (CurrencyID, Description) Values('NGN', 'Nigerian Naira')
Insert tCurrency (CurrencyID, Description) Values('NOK', 'Norwegian Krone')
Insert tCurrency (CurrencyID, Description) Values('NPR', 'Nepalese Rupee')
Insert tCurrency (CurrencyID, Description) Values('NZD', 'New Zealand Dollar')
Insert tCurrency (CurrencyID, Description) Values('OMR', 'Omani Rial')
Insert tCurrency (CurrencyID, Description) Values('PAB', 'Panamanian Balboa')
Insert tCurrency (CurrencyID, Description) Values('PEN', 'Peruvian Sol')
Insert tCurrency (CurrencyID, Description) Values('PHP', 'Philippine Peso')
Insert tCurrency (CurrencyID, Description) Values('PKR', 'Pakistani Rupee')
Insert tCurrency (CurrencyID, Description) Values('PLN', 'Polish Zloty')
Insert tCurrency (CurrencyID, Description) Values('PYG', 'Paraguayan Guaraní')
Insert tCurrency (CurrencyID, Description) Values('QAR', 'Qatari Riyal')
Insert tCurrency (CurrencyID, Description) Values('RON', 'Romanian Leu')
Insert tCurrency (CurrencyID, Description) Values('RSD', 'Serbian Dinar')
Insert tCurrency (CurrencyID, Description) Values('RUB', 'Russian Rouble')
Insert tCurrency (CurrencyID, Description) Values('SAR', 'Saudi Riyal')
Insert tCurrency (CurrencyID, Description) Values('SCR', 'Seychellois Rupee')
Insert tCurrency (CurrencyID, Description) Values('SEK', 'Swedish Krona')
Insert tCurrency (CurrencyID, Description) Values('SGD', 'Singapore Dollar')
Insert tCurrency (CurrencyID, Description) Values('SYP', 'Syrian Pound')
Insert tCurrency (CurrencyID, Description) Values('THB', 'Thai Baht')
Insert tCurrency (CurrencyID, Description) Values('TND', 'Tunisian Dinar')
Insert tCurrency (CurrencyID, Description) Values('TRY', 'Turkish Lira')
Insert tCurrency (CurrencyID, Description) Values('TWD', 'Taiwanese Dollar')
Insert tCurrency (CurrencyID, Description) Values('UAH', 'Ukraine Hryvnia')
Insert tCurrency (CurrencyID, Description) Values('UGX', 'Ugandan Shilling')
Insert tCurrency (CurrencyID, Description) Values('UYU', 'Uruguayan Peso')
Insert tCurrency (CurrencyID, Description) Values('USD', 'US Dollar')
Insert tCurrency (CurrencyID, Description) Values('VEF', 'Venezuelan Bolívar')
Insert tCurrency (CurrencyID, Description) Values('VND', 'Vietnamese Dong')
Insert tCurrency (CurrencyID, Description) Values('XAF', 'Central African Franc')
Insert tCurrency (CurrencyID, Description) Values('XCD', 'East Caribbean Dollar')
Insert tCurrency (CurrencyID, Description) Values('XOF', 'West African Franc')
Insert tCurrency (CurrencyID, Description) Values('XPF', 'CFP Franc')
Insert tCurrency (CurrencyID, Description) Values('ZAR', 'South African Rand')
GO
