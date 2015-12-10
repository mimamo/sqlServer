USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetPrepaymentsForClient]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetPrepaymentsForClient]
	(
	@ClientKey int		-- pass client in case InvoiceKey is 0
	,@GLCompanyKey int	-- pass gl company in case InvoiceKey is 0
	,@InvoiceKey int
	,@CurrencyID varchar(10) = null
	)

AS --Encrypt

  /*
  || When     Who  Rel       What
  || 10/05/10 GHL  10.5.3.6  Cloned sptInvoiceGetPrepayments for a client
  ||                         For new UI in wmj
  || 06/15/12 GHL  10.5.5.7  (146561) Allow negative checks to be selected
  || 06/21/12 GHL  10.5.5.7  Added GL Company check 
  || 03/05/13 GHL  10.5.6.5  (170700) Added ClassKey from the check because the prepayment is a reversal
  ||                         we try to reverse what is on the check
  || 09/27/13 GHL  10.572    Added support for multi currencies
  || 07/28/14 GHL  10.8.5.2  (224103) Added Description from the header 
  */
  
Declare @ParentCompanyKey int

SELECT @ParentCompanyKey = ParentCompanyKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @ClientKey
	
SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)

Select 
	0 as Applied,
	ch.CheckKey,
	ch.ReferenceNumber,
	ch.CheckDate,
	ch.CheckAmount,
	ch.CheckAmount - ISNULL(Sum(ca.Amount), 0) as UnappliedAmount,
	0 as CheckApplKey,
	0 as Amount,
	ch.Description,
	ch.ClassKey
From
	tCheck ch (nolock)
	left outer join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
Where
	ch.ClientKey IN (SELECT CompanyKey from tCompany 
					WHERE CompanyKey = @ClientKey 
					OR CompanyKey = @ParentCompanyKey 
					OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey))  
	and  ch.Posted = 1 
	and ISNULL(ch.VoidCheckKey, 0) = 0 
	and ch.CheckKey not in (Select CheckKey From tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay=1)

	-- same GL company 
	and ISNULL(ch.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) 
	
	-- same currency
	and	ISNULL(ch.CurrencyID, '') = ISNULL(@CurrencyID, '')    

Group By
	ch.CheckKey, ch.ReferenceNumber, ch.CheckDate, ch.CheckAmount, ch.ClassKey, ch.Description
Having ch.CheckAmount - ISNULL(Sum(ca.Amount), 0) <> 0
GO
