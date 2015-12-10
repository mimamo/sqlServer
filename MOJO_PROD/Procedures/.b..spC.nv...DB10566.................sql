USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10566]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10566]

AS

-- Moving Culture from Session to tPreference
Update tPreference Set Culture = Case When CHARINDEX('<CULTURE>', Data) > 0 then Substring(Data, CHARINDEX('<CULTURE>', Data) + 9, 4 ) else '1033' end
From tPreference, tSession
Where tPreference.CompanyKey = tSession.EntityKey and tSession.Entity = 'style'


Update tCCEntry Set OriginalMemo = Memo

-- Delete billing schedule if no next billing date and no task
-- this prevents the billing worksheets from being generated
delete tBillingSchedule where NextBillDate is null and isnull(TaskKey, 0) = 0 and isnull(BillingKey, 0) = 0 

-- Updates for the new timeline widget and dashboard part  

update tActionLog set Action = 'Deleted'  where Entity = 'Purchase Order'  and Action = 'Delete'

update tActionLog set Action = 'Unapproved'  where Entity = 'Purchase Order' and Action = 'Unapprove'

update tActionLog set Action = 'Approved'  where Entity = 'Purchase Order' and Action = 'Purchase Order Approved'

update tActionLog set Action = 'Rejected'  where Entity = 'Purchase Order' and Action = 'Purchase Order Rejected'

update tActionLog set Action = 'Prebilled'  where Entity = 'Purchase Order' and Action = 'Purchase Order Prebilled'

update tActionLog set Action = 'Closed'  where Entity = 'Purchase Order' and Action = 'Purchase Order Closed'

update tActionLog set Action = 'Reopened'  where Entity = 'Purchase Order' and Action = 'Purchase Order Reopened'

update tActionLog set Action = 'Line Closed'  where Entity = 'Purchase Order' and Action = 'Purchase Order Line Closed'

update tActionLog set Action = 'Line Reopened'  where Entity = 'Purchase Order' and Action = 'Purchase Order Line Reopened'

update tActionLog set Action = 'Deleted'  where Entity = 'Broadcast Order'  and Action = 'Delete'

update tActionLog set Action = 'Unapproved'  where Entity = 'Broadcast Order' and Action = 'Unapprove'

update tActionLog set Action = 'Approved'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Approved'

update tActionLog set Action = 'Rejected'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Rejected'

update tActionLog set Action = 'Prebilled'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Prebilled'

update tActionLog set Action = 'Closed'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Closed'

update tActionLog set Action = 'Reopened'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Reopened'

update tActionLog set Action = 'Line Closed'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Line Closed'

update tActionLog set Action = 'Line Reopened'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Line Reopened'

update tActionLog set Action = 'Unapproved'  where Entity = 'Broadcast Order' and Action = 'Broadcast Order Unapprove'

update tActionLog set Action = 'Deleted'  where Entity = 'Insertion Order'  and Action = 'Delete'

update tActionLog set Action = 'Unapproved'  where Entity = 'Insertion Order' and Action = 'Unapprove'

update tActionLog set Action = 'Approved'  where Entity = 'Insertion Order' and Action = 'Insertion Order Approved'

update tActionLog set Action = 'Rejected'  where Entity = 'Insertion Order' and Action = 'Insertion Order Rejected'

update tActionLog set Action = 'Prebilled'  where Entity = 'Insertion Order' and Action = 'Insertion Order Prebilled'

update tActionLog set Action = 'Closed'  where Entity = 'Insertion Order' and Action = 'Insertion Order Closed'

update tActionLog set Action = 'Reopened'  where Entity = 'Insertion Order' and Action = 'Insertion Order Reopened'

update tActionLog set Action = 'Line Closed'  where Entity = 'Insertion Order' and Action = 'Insertion Order Line Closed'

update tActionLog set Action = 'Line Reopened'  where Entity = 'Insertion Order' and Action = 'Insertion Order Line Reopened'

update tActionLog set Action = 'Unapproved'  where Entity = 'Insertion Order' and Action = 'Insertion Order Unapprove'

update tActionLog set Action = 'Deleted'  where Entity = 'Estimate'  and Action = 'Delete'

update tActionLog set Action = 'Unapproved'  where Entity = 'Estimate' and Action = 'Estimate Unapproval'

update tActionLog set Action = 'Approved'  where Entity = 'Estimate' and Action = 'Estimate Approval'

update tActionLog set Action = 'Rejected' where Entity = 'Estimate' and Action = 'Estimate Rejection'

update tActionLog set Action = 'Submitted' where Entity = 'Estimate' and Action = 'Estimate Submitted'

update tActionLog set Entity = 'Billing Worksheet', Action = 'Approved' where Entity = 'Billing Worksheet Approvals' and Action = 'Billing Worksheets Approved'

update tActionLog set Entity = 'Billing Worksheet', Action = 'Reviewed' where Entity = 'Billing Worksheet Approvals' and Action = 'Billing Worksheets Reviewed'

update tActionLog set Entity = 'Billing Worksheet', Action = 'Rejected' where Entity = 'Billing Worksheet Approvals' and Action = 'Billing Worksheets Rejected'

update tActionLog set Entity = 'Billing Worksheet', Action = 'Unapproved' where Entity = 'Billing Worksheet Approvals' and Action = 'Billing Worksheets Un-Approved'

update tActionLog set Action = 'Deleted' where Entity = 'Expense Report' and Action = 'Delete'

update tActionLog set Action = 'Approved' where Entity = 'Expense Report' and Action = 'Expense Report Approved'

update tActionLog set Action = 'Unapproved' where Entity = 'Expense Report' and Action = 'Expense Report Unapproved'

update tActionLog set Action = 'Rejected' where Entity = 'Expense Report' and Action = 'Expense Report Rejected'

update tActionLog set Action = 'Deleted' where Entity = 'TimeSheet' and Action = 'Delete'

update tActionLog set Action = 'Approved' where Entity = 'TimeSheet' and Action = 'TimeSheet Approved'

update tActionLog set Action = 'Unposted' where Entity = 'Credit Card Charge' and Action = 'Unpost'

update tActionLog set Action = 'Unposted' where Entity = 'Credit Card Charge' and Action = 'Unapproved'

update tActionLog set Action = 'Unposted' where Entity = 'Client Invoice' and Action = 'Unpost'

update tActionLog set Action = 'Deleted' where Entity = 'Client Invoice' and Action = 'Delete'

update tActionLog set Action = 'Unapproved' where Entity = 'Client Invoice' and Action = 'Unapprove'

update tActionLog set Action = 'Unapplied' where Entity = 'Client Invoice' and Action = 'Unapply'

update tActionLog set Action = 'Voided' where Entity = 'Client Invoice' and Action = 'Void'

update tActionLog set Action = 'Unposted' where Entity = 'Receipt' and Action = 'Unpost'

update tActionLog set Action = 'Voided' where Entity = 'Receipt' and Action = 'Void'

update tActionLog set Action = 'Unposted' where Entity = 'Credit Card Charge' and Action = 'Unpost'

update tActionLog set Action = 'Unapproved' where Entity = 'Credit Card Charge' and Action = 'Unapprove'

update tActionLog set Action = 'Deleted' where Entity = 'Journal Entry' and Action = 'Delete'

update tActionLog set Action = 'Deleted Void' where Entity = 'Payment' and Action = 'Delete Void'

update tActionLog set Action = 'File Deleted' where Entity = 'File' and Action = 'File Delete'

update tActionLog set Action = 'Unapproved' where Entity = 'Vendor Invoice' and Action = 'Unapprove'

update tActionLog set Action = 'Unlocked Project' where Entity = 'Project' and Action = 'Unlock Project'

update tActionLog set Action = 'Unapplied' where Action = 'Unapply'

update tActionLog set Action = 'Unposted' where Action = 'Unpost'

update tActionLog set Action = 'File Deleted' where Action = 'File Delete'

update tActionLog set Action = 'Deleted' where Action = 'Delete'

update tActionLog set Action = 'Unapproved' where Action = 'Purchase Order Unapproved'

update tActionLog set EntityKey = 0 where Action = 'Specification Added'

update tActionLog set EntityKey = 0 where Action = 'Specification Updated'

update tActionLog set EntityKey = 0 where Action = 'Specification Deleted'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Deliverable Round Added'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Deliverable Round Canceled'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Deliverable Round Deleted'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Project Deliverable Added'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Project Deliverable Deleted'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Round Approved'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Round Approved With Changes'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Round Comment Added'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Round Completed'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Round Rejected'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Project Deliverable Deleted'

update tActionLog set Entity = 'Deliverable', EntityKey = 0 where Entity = 'Project' and Action = 'Project Deliverable Deleted'


Insert tWidgetSecurity(WidgetKey, SecurityGroupKey, CanEdit, CanView)
Select 40, SecurityGroupKey, 1, 1 
	From tSecurityGroup sg
	inner join tCompany c on sg.CompanyKey = c.CompanyKey
	Where c.Locked = 0 and sg.SecurityGroupKey not in (Select SecurityGroupKey from tWidgetSecurity (nolock) Where WidgetKey = 40)

EXEC sptWebDavFileConvert

-- Update for Credit Card BroughtFrom fix
update tVoucher set tVoucher.BoughtFrom = tCompany.CompanyName
from tVoucher (nolock)
inner join tCompany (nolock) on tVoucher.BoughtFromKey = tCompany.CompanyKey
where tVoucher.CreditCard = 1
GO
