USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetAppliedInvoice]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetAppliedInvoice]

	(
		@CheckKey int,
		@ClientKey int,
		@Restrict tinyint
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/5/07   GWG 8.5     Added GL Company Restriction
*/

Declare @ParentCompanyKey int, @ParentCompany int, @GLCompanyKey int

Select @GLCompanyKey = GLCompanyKey from tCheck Where CheckKey = @CheckKey

if @Restrict = 0
BEGIN

	Select @ParentCompanyKey = ParentCompanyKey, @ParentCompany = ParentCompany from tCompany (nolock) Where CompanyKey = @ClientKey
	if ISNULL(@ParentCompanyKey, 0) = 0 and ISNULL(@ParentCompany, 0) = 0
		Select
			ca.CheckApplKey,
			i.InvoiceKey,
			i.InvoiceNumber,
			i.InvoiceDate,
			i.ARAccountKey,
			c.CustomerID,
			c.CompanyName,
			(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0)) as TotalAmount,
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
			ca.Amount,
			1 as Applied
		From
			tCheckAppl ca (nolock)
			inner Join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
			inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		Where 
			ca.CheckKey = @CheckKey and ca.InvoiceKey is not null

		UNION ALL

		Select
			0,
			i.InvoiceKey,
			i.InvoiceNumber,
			i.InvoiceDate,
			i.ARAccountKey,
			c.CustomerID,
			c.CompanyName,
			(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalAmount,
			(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
			0 as Amount,
			0 as Applied
		from tInvoice i (nolock)
			inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		Where ClientKey = @ClientKey and
			ABS(AmountReceived) < ABS(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0))
			and InvoiceStatus = 4
			and ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
			and i.InvoiceKey not in (Select InvoiceKey from tCheckAppl (nolock) Where CheckKey = @CheckKey and InvoiceKey is not null and Prepay = 0)
	else
		if @ParentCompany = 0
			Select
				ca.CheckApplKey,
				i.InvoiceKey,
				i.InvoiceNumber,
				i.InvoiceDate,
				i.ARAccountKey,
				c.CustomerID,
				c.CompanyName,
				(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0)) as TotalAmount,
				(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
				ca.Amount,
				1 as Applied
			From
				tCheckAppl ca (nolock)
				inner Join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
				inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			Where 
				ca.CheckKey = @CheckKey and ca.InvoiceKey is not null

			UNION ALL

			Select
				0,
				i.InvoiceKey,
				i.InvoiceNumber,
				i.InvoiceDate,
				i.ARAccountKey,
				c.CustomerID,
				c.CompanyName,
				(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalAmount,
				(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
				0 as Amount,
				0 as Applied
			from tInvoice i (nolock)
				inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			Where 
				(ClientKey in (Select CompanyKey from tCompany (nolock) Where ParentCompanyKey = @ParentCompanyKey) or
				ClientKey = @ParentCompanyKey) and
				ABS(AmountReceived) < ABS(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0))
				and InvoiceStatus = 4
				and ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
				and i.InvoiceKey not in (Select InvoiceKey from tCheckAppl (nolock) Where CheckKey = @CheckKey and InvoiceKey is not null and Prepay = 0)
		else
			Select
				ca.CheckApplKey,
				i.InvoiceKey,
				i.InvoiceNumber,
				i.InvoiceDate,
				i.ARAccountKey,
				c.CustomerID,
				c.CompanyName,
				(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0)) as TotalAmount,
				(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
				ca.Amount,
				1 as Applied
			From
				tCheckAppl ca (nolock)
				inner Join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
				inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			Where 
				ca.CheckKey = @CheckKey and ca.InvoiceKey is not null

			UNION ALL

			Select
				0,
				i.InvoiceKey,
				i.InvoiceNumber,
				i.InvoiceDate,
				i.ARAccountKey,
				c.CustomerID,
				c.CompanyName,
				(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalAmount,
				(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
				0 as Amount,
				0 as Applied
			from tInvoice i (nolock)
				inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
			Where 
				(ClientKey in (Select CompanyKey from tCompany (nolock) Where ParentCompanyKey = @ClientKey) or
				ClientKey = @ClientKey) and
				ABS(AmountReceived) < ABS(ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0))
				and InvoiceStatus = 4
				and ISNULL(i.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
				and i.InvoiceKey not in (Select InvoiceKey from tCheckAppl (nolock) Where CheckKey = @CheckKey and InvoiceKey is not null and Prepay = 0)

	
END
else
	Select
		ca.CheckApplKey,
		i.InvoiceKey,
		i.InvoiceNumber,
		i.InvoiceDate,
		i.ARAccountKey,
		c.CustomerID,
		c.CompanyName,
		(ISNULL(i.InvoiceTotalAmount, 0) - isnull(i.WriteoffAmount, 0) - isnull(i.DiscountAmount, 0) - isnull(i.RetainerAmount, 0)) as TotalAmount,
		(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen,
		ca.Amount,
		1 as Applied
	From
		tCheckAppl ca (nolock)
		inner Join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
		inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
	Where 
		ca.CheckKey = @CheckKey and ca.InvoiceKey is not null and Prepay = 0
GO
