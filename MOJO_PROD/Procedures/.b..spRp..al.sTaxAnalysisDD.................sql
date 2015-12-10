USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSalesTaxAnalysisDD]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptSalesTaxAnalysisDD] 
(
		@CompanyKey int,
		@SalesTaxKey int, 
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@ShowCollected tinyint,
		@ShowPaid tinyint,
		@PaidInvoicesOnly tinyint,
		@ShowTaxAppliedLinesOnly tinyint,
		@GLCompanyKey int = -1, -- -1 All, 0 Blank, >0
		@UserKey int = null,
		@CurrencyID varchar(10) = null 
	)
AS
BEGIN
  /*
  || When     Who Rel     What
  || 03/03/15 GHL 10.590  (247006) Created to show details for the 'Collected w/o Tax' amount 
  ||                      on the bottom grid
  */
	
	SET NOCOUNT ON
	
CREATE TABLE #taxes_summary (
	SalesTaxKey int null
	,SalesTaxID VARCHAR(100) NULL, SalesTaxName VARCHAR(100) NULL, SalesTaxFullName VARCHAR(200) NULL
    ,TaxCollected MONEY NULL, TaxPaid MONEY NULL, VAT MONEY NULL
    ,SalesTaxableAmount MONEY NULL,PurchaseTaxableAmount MONEY NULL, InvoiceTotalAmount MONEY NULL) 	

-- This is a new summary table added 4/25/11
CREATE TABLE #summary (
	TotalName varchar(30) null
	,Collected money null
	,Paid money null
	,Net money null
)

-- used to capture details for the Total w/o Tax
CREATE TABLE #details (InvoiceKey int null
    , Source varchar(25) null
    , InvoiceDate smalldatetime null
    , PostingDate smalldatetime null
    ,InvoiceNumber varchar(100) null
    ,Amount money null
)

exec spRptSalesTaxAnalysis @CompanyKey,@SalesTaxKey, @StartDate ,@EndDate ,@ShowCollected ,@ShowPaid ,@PaidInvoicesOnly ,
		@ShowTaxAppliedLinesOnly,@GLCompanyKey, @UserKey ,@CurrencyID, 1
		
  
update #details
set    #details.InvoiceNumber = i.InvoiceNumber
       ,#details.InvoiceDate = i.InvoiceDate
       ,#details.PostingDate = i.PostingDate
from   tInvoice i (nolock)
where  #details.Source <> 'Check'
and    #details.InvoiceKey = i.InvoiceKey
 
update #details
set    #details.InvoiceNumber = c.ReferenceNumber
       ,#details.InvoiceDate = c.CheckDate
       ,#details.PostingDate = c.PostingDate
from   tCheck c (nolock)
where  #details.Source = 'Check'
and    #details.InvoiceKey = c.CheckKey
 
--select SUM(Amount) from #details  
select * from #details order by InvoiceNumber
  
END
GO
