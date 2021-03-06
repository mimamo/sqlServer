USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetPrepayments]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetPrepayments]

	(
		@InvoiceKey int,
		@Restrict tinyint
	)

  /*
  || When     Who  Rel       What
  || 10/7/08  GWG  10.0.1.0  Added a restirct to not show voided receipts
  || 09/01/09 RLB  10.5.0.9  bug (61612)correctly pulling parent company receipts
  || 06/15/12 GHL  10.5.5.7  (146561) Allow negative checks to be selected
  || 06/21/12 GHL  10.5.5.7  Added GL Company check 
  || 03/05/13 GHL  10.5.6.5  (170700) Added ClassKey from the check because the prepayment is a reversal
  ||                         we try to reverse what is on the check
  || 07/28/14 GHL  10.8.5.2  (224103) Added Description from the header 
  */
  
AS
Declare @ClientKey int, @ParentCompanyKey int,  @GLCompanyKey int



Select @ClientKey = ClientKey
      ,@GLCompanyKey = GLCompanyKey 
from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

SELECT @ParentCompanyKey = ParentCompanyKey
	FROM   tCompany (NOLOCK)
	WHERE  CompanyKey = @ClientKey
	
	SELECT @ParentCompanyKey = ISNULL(@ParentCompanyKey, 0)

if @Restrict = 0
	Select
		1 as Applied,
		ch.CheckKey,
		ch.ReferenceNumber,
		ch.CheckDate,
		ch.CheckAmount,
		ch.CheckAmount - (Select Sum(Amount) from tCheckAppl (nolock) Where CheckKey = ch.CheckKey) as UnappliedAmount,
		ca.CheckApplKey,
		ca.Amount,
		ch.Description,
		ch.ClassKey
	From
		tCheck ch (nolock)
		inner join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
	Where
		ca.InvoiceKey = @InvoiceKey and
		Prepay = 1
		
	UNION ALL

	Select
		0 as Applied,
		ch.CheckKey,
		ch.ReferenceNumber,
		ch.CheckDate,
		ch.CheckAmount,
		ch.CheckAmount - ISNULL(Sum(ca.Amount), 0) as UnappliedAmount,
		0,
		0,
		ch.Description,
		ch.ClassKey
	From
		tCheck ch (nolock)
		left outer join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
 	Where
		ch.ClientKey IN (SELECT CompanyKey from tCompany WHERE CompanyKey = @ClientKey OR CompanyKey = @ParentCompanyKey OR (@ParentCompanyKey <> 0 AND ParentCompanyKey = @ParentCompanyKey))  and
		ch.Posted = 1 and ISNULL(ch.VoidCheckKey, 0) = 0 and
		ch.CheckKey not in (Select CheckKey From tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay = 1)
	and ISNULL(ch.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)

	Group By
		ch.CheckKey, ch.ReferenceNumber, ch.CheckDate, ch.CheckAmount, ch.ClassKey, ch.Description
	Having ch.CheckAmount - ISNULL(Sum(ca.Amount), 0) <> 0

else

	Select
		1 as Applied,
		ch.CheckKey,
		ch.ReferenceNumber,
		ch.CheckDate,
		ch.CheckAmount,
		ch.CheckAmount - (Select Sum(Amount) from tCheckAppl (nolock) Where CheckKey = ch.CheckKey) as UnappliedAmount,
		ca.CheckApplKey,
		ca.Amount,
		ch.Description,
		ch.ClassKey
	From
		tCheck ch (nolock)
		inner join tCheckAppl ca (nolock) on ch.CheckKey = ca.CheckKey
	Where
		ca.InvoiceKey = @InvoiceKey and
		Prepay = 1
GO
