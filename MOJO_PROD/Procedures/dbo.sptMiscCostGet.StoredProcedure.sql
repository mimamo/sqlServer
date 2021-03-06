USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMiscCostGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMiscCostGet]
	@MiscCostKey int

AS --Encrypt

/*
  || When       Who Rel      What
  || 09/27/2010 MFT 10.5.3.5 Added ItemName, tDepartment, ClassName, Status, tProject
  || 10/15/2010 GWG 10.5.3.6 Fixed join to tProject
  || 12/22/2010 MFT 10.5.3.9 Added tInvoiceLine
  || 06/22/2011 RLB 10.5.4.5 (111726) Added Addedby
  || 08/30/2013 GHL 10.5.7.1 Added CurrencyID
*/

Declare @BillingDetail Int

if exists(Select 1 from tBillingDetail bd (nolock)
					inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
				Where bd.EntityKey = @MiscCostKey
				And   bd.Entity = 'tMiscCost'
				And   b.Status < 5)
	Select @BillingDetail = 1
else
	Select @BillingDetail = 0

DECLARE @CompanyKey int
DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @ExpenseDate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

if @MiscCostKey > 0 
begin
	select @CompanyKey = p.CompanyKey
	  ,@GLCompanyKey = isnull(p.GLCompanyKey, 0) 
      ,@CurrencyID = p.CurrencyID
	  ,@ExpenseDate = mc.ExpenseDate
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	from   tMiscCost mc (nolock)
	inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey 
	inner join tPreference pref (nolock) on p.CompanyKey = pref.CompanyKey
	where mc.MiscCostKey = @MiscCostKey     

	-- get the rate history for day/gl comp/curr needed to display on screen
	if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @ExpenseDate, @ExchangeRate output, @RateHistory output

end


	SELECT
		tMiscCost.*,
		@BillingDetail as BillingDetail,
		tTask.TaskID,
		tTask.TaskName,
		tProject.ProjectNumber,
		tProject.ProjectName,
		tProject.GLCompanyKey,
		tItem.ItemID,
		tItem.ItemName,
		tUser.FirstName,
		tUser.LastName,
		ISNULL(tUser.FirstName, '') + ' ' + ISNULL(tUser.LastName, '') as AddedBy,
		tClass.ClassID,
		tClass.ClassName,
		tDepartment.DepartmentName,
		CASE
			WHEN ISNULL(tMiscCost.InvoiceLineKey, -1) = 0 THEN 'Marked as Billed'
			WHEN ISNULL(tMiscCost.InvoiceLineKey, -1) > 0 THEN 'Billed'
			ELSE
				CASE ISNULL(WriteOff, 0)
					WHEN 0 THEN 'Unbilled'
					ELSE 'Written Off' END
			END +
			CASE
				WHEN ISNULL(WIPPostingInKey, 0) != 0 OR ISNULL(WIPPostingOutKey, 0) != 0 THEN ' Posted to WIP' ELSE ''
		END AS Status,
		InvoiceKey,
		isnull(@RateHistory, 0) as RateHistory
	FROM
		tMiscCost (nolock)
		Left outer join tUser (nolock) ON tMiscCost.EnteredByKey = tUser.UserKey
		LEFT OUTER JOIN tTask (nolock) ON tMiscCost.TaskKey = tTask.TaskKey
		left outer join tItem (nolock) on tMiscCost.ItemKey = tItem.ItemKey
		left outer join tClass (nolock) on tMiscCost.ClassKey = tClass.ClassKey
		left outer join tDepartment (nolock) on tMiscCost.DepartmentKey = tDepartment.DepartmentKey
		left outer join tProject (nolock) on tMiscCost.ProjectKey = tProject.ProjectKey
		left outer join tInvoiceLine (nolock) on tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey
	WHERE
		MiscCostKey = @MiscCostKey

	RETURN 1
GO
