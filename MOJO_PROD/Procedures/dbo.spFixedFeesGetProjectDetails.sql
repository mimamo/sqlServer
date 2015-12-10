USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesGetProjectDetails]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesGetProjectDetails]
	(
	@ProjectKey int
	,@EstimateKey int = 0 -- All Estimates
	,@InvoiceBy varchar(50) = 'OneLine' -- OneLine, Task, Item/Service, BillingItem
	)
AS
	SET NOCOUNT ON

 /*
  || When     Who Rel   What
  || 03/20/13 GHL 10.523 Creation for new Flex Fixed Fee billing functionality for projects
  || 03/27/13 GHL 10.566 Added invoices
  || 09/11/14 GHL 10.584 Changing query for invoices to il.ProjectKey = @ProjectKey and
  ||                     removed restrictions on LineType (to see Mass Billing invoices) 
  */


  -- This will return 3 fields: RemainingAmount, BudgetAmount, BilledAmount
  exec sptProjectGetEstimateDataForFF @ProjectKey, @EstimateKey

  -- for the list of estimates in a DropDown
  exec sptEstimateGetDD @ProjectKey

  if @InvoiceBy in ( 'OneLine', 'Task')
  begin
		If @EstimateKey = 0 
			-- @IncludeNullTaskLines= 1
			exec spRptTaskSummary @ProjectKey, 1
		Else
			-- @IncludeNullTaskLines= 1
			exec spRptTaskSummaryByEstimate @ProjectKey, @EstimateKey, 1
  end          

  if @InvoiceBy = 'Item/Service'
  begin
		If @EstimateKey = 0 
			exec spRptServiceSummary @ProjectKey
		Else
			exec spRptServiceSummaryByEstimate @ProjectKey, @EstimateKey


		If @EstimateKey = 0 
			exec spRptExpenseSummary @ProjectKey
		Else
			exec spRptExpenseSummaryByEstimate @ProjectKey, @EstimateKey

  end          

  if @InvoiceBy = 'BillingItem'
  begin
		If @EstimateKey = 0 
			exec spRptBillingItemSummary @ProjectKey
		Else
			exec spRptBillingItemSummaryByEstimate @ProjectKey, @EstimateKey

  end          

  Select
		il.InvoiceLineKey
		,i.InvoiceKey
		,i.InvoiceNumber
		,i.InvoiceDate
		,i.AdvanceBill
		,il.EstimateKey
		,il.LineSubject
		,il.Quantity
		,il.UnitAmount
		,il.TotalAmount
		,il.BillFrom
		,'edit' as EditIcon
		,'Click here or double click on the line subject to view the invoice header.' as EditToolTip
	From
		tInvoice i (nolock)
		inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
	Where
		il.ProjectKey = @ProjectKey
	
	Order By 
		i.InvoiceDate, i.InvoiceNumber, il.InvoiceOrder

  RETURN 1
GO
