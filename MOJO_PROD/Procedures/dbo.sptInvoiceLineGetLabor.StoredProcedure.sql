USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetLabor]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineGetLabor]
 @InvoiceLineKey int
 ,@InvoiceKey int = null
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/17/06 CRG 8.35  Now showing Billing Detail comments if available.
|| 10/31/06 GHL 8.35  Added top 1 to fix subquery
|| 11/29/06 GHL 8.4   Getting now service description from BilledService instead of Service
||                    When labor has been billed
|| 08/02/07 GHL 8.5   Pulling now transactions only linked to the line (not all transactions for project)
||                    Added ProjectKey to facilitate project rollup on screen
|| 05/04/09 GHL 10.024 (52605) Getting now BillingComments from tTime.BilledComment
||                    tTime.BilledComment should be set when we generate the invoice 
||                    from a billing WS tBillingDetail.Comments 
|| 04/30/10 GHL 10.522 Added InvoiceKey param to pull records for whole invoice
|| 04/19/12 GHL 10.555 (140727) Added Billed Service info to edit on flex screen
|| 06/01/12 GHL 10.556 Modified BillingComment to make it consistent with sptInvoiceLineTimeGet
|| 11/19/12 GHL 10.562 (160017) Added BillableCost for Flex screen (must be similar to sptInvoiceLineGetTransactions)
|| 01/22/15 GHL 10.588 For Abelson Taylor, added titles
*/

Declare @LocalInvoiceKey int, @Percentage decimal(24,4), @ParentInvoiceKey int

If isnull(@InvoiceKey, 0) = 0
begin 
	Select @LocalInvoiceKey = tInvoiceLine.InvoiceKey 
	from tInvoiceLine (nolock) inner join tInvoice (nolock) on tInvoiceLine.InvoiceKey = tInvoice.InvoiceKey
	Where tInvoiceLine.InvoiceLineKey = @InvoiceLineKey
end 
else
	Select @LocalInvoiceKey = @InvoiceKey

Select @Percentage = ISNULL(PercentageSplit, 0)
     , @ParentInvoiceKey = ISNULL(ParentInvoiceKey, 0) 
from tInvoice (nolock) Where InvoiceKey = @LocalInvoiceKey

if @ParentInvoiceKey = 0
	Select @Percentage = 1
else
	Select @Percentage = @Percentage / 100

IF ISNULL(@InvoiceKey, 0) = 0
 SELECT 
	t.InvoiceLineKey,
	t.ProjectKey,
	t.TaskKey,
	t.TimeKey, 
	ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS Person,
	t.WorkDate,
	t.ActualHours * @Percentage as ActualHours,
	t.ActualRate as ActualRate,
	ROUND(t.ActualHours * t.ActualRate * @Percentage, 2) as ActualAmount,
	ROUND(t.ActualHours * t.ActualRate * @Percentage, 2) as BillableCost, -- Added for flex screen
	t.BilledHours * @Percentage as BilledHours,
	t.BilledRate * @Percentage as BilledRate,
	ROUND(ISNULL(t.BilledHours, 0) * ISNULL(t.BilledRate, 0) * @Percentage, 2) as BilledAmount,
	
	-- for flex lookup
	isnull(t.BilledService, t.ServiceKey) as BilledService,
	case when t.BilledService is null then s.Description else bs.Description end as BilledServiceDescription,
	case when t.BilledService is null then s.ServiceCode else bs.ServiceCode end as BilledServiceCode,  

	-- this is the way it was done in ASPX
	t.RateLevel,
	Case  
		WHEN t.BilledService IS NULL THEN
		Case t.RateLevel 
			When 1 then ISNULL(s.Description1, s.Description)
			When 2 then ISNULL(s.Description2, s.Description)
			When 3 then ISNULL(s.Description3, s.Description)
			When 4 then ISNULL(s.Description4, s.Description)
			When 5 then ISNULL(s.Description5, s.Description)
			Else s.Description
		END 
		ELSE
		Case t.RateLevel 
			When 1 then ISNULL(bs.Description1, bs.Description)
			When 2 then ISNULL(bs.Description2, bs.Description)
			When 3 then ISNULL(bs.Description3, bs.Description)
			When 4 then ISNULL(bs.Description4, bs.Description)
			When 5 then ISNULL(bs.Description5, bs.Description)
			Else bs.Description
		END
	END 	
	as ServiceDescription,

	t.Comments,
	isnull(t.BilledComment, t.Comments) as BillingComments,
	isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName,
	tt.TitleName
 FROM tTime t (NOLOCK)
	inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
	left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
	left outer join tService bs (nolock) on t.BilledService = bs.ServiceKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tTitle tt (nolock) on t.TitleKey = tt.TitleKey 
 WHERE t.InvoiceLineKey = @InvoiceLineKey

ELSE
 SELECT 
	t.InvoiceLineKey,
	t.ProjectKey,
	t.TaskKey,
	t.TimeKey, 
	ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS Person,
	t.WorkDate,
	t.ActualHours * @Percentage as ActualHours,
	t.ActualRate as ActualRate,
	ROUND(t.ActualHours * t.ActualRate * @Percentage, 2) as ActualAmount,
	ROUND(t.ActualHours * t.ActualRate * @Percentage, 2) as BillableCost, -- Added for flex screen
	t.BilledHours * @Percentage as BilledHours,
	t.BilledRate * @Percentage as BilledRate,
	ROUND(ISNULL(t.BilledHours, 0) * ISNULL(t.BilledRate, 0) * @Percentage, 2) as BilledAmount,
	
	-- for flex lookup
	isnull(t.BilledService, t.ServiceKey) as BilledService,
	case when t.BilledService is null then s.Description else bs.Description end as BilledServiceDescription,
	case when t.BilledService is null then s.ServiceCode else bs.ServiceCode end as BilledServiceCode,  

	-- this is the way it was done in ASPX
	t.RateLevel,
	Case  
		WHEN t.BilledService IS NULL THEN
		Case t.RateLevel 
			When 1 then ISNULL(s.Description1, s.Description)
			When 2 then ISNULL(s.Description2, s.Description)
			When 3 then ISNULL(s.Description3, s.Description)
			When 4 then ISNULL(s.Description4, s.Description)
			When 5 then ISNULL(s.Description5, s.Description)
			Else s.Description
		END 
		ELSE
		Case t.RateLevel 
			When 1 then ISNULL(bs.Description1, bs.Description)
			When 2 then ISNULL(bs.Description2, bs.Description)
			When 3 then ISNULL(bs.Description3, bs.Description)
			When 4 then ISNULL(bs.Description4, bs.Description)
			When 5 then ISNULL(bs.Description5, bs.Description)
			Else bs.Description
		END
	END 	
	as ServiceDescription,
	t.Comments,
	isnull(t.BilledComment, t.Comments) as BillingComments,
	isnull(p.ProjectNumber+' - ','') + isnull(left(p.ProjectName, 25),'') as ProjectFullName,
	tt.TitleName
 FROM tTime t (NOLOCK)
	inner join tUser u (NOLOCK) on t.UserKey = u.UserKey
	left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
	left outer join tService bs (nolock) on t.BilledService = bs.ServiceKey
	left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
	left outer join tTitle tt (nolock) on t.TitleKey = tt.TitleKey 
 WHERE il.InvoiceKey = @InvoiceKey
GO
