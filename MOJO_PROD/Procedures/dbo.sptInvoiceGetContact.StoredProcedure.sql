USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetContact]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetContact]
	@InvoiceKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/24/14 GHL 10.582  (222235) Check if we email to client's BillingEmailContact or invoice's PrimaryContactKey
|| 10/20/14 WDF 10.586  (232644) Pull InvoiceEmails from Contact tUser
*/
	declare @BillingEmailContactName varchar(250)
	declare @BillingEmailContactEmail varchar(100)

	select @BillingEmailContactName = u.UserName
		  ,@BillingEmailContactEmail = u.Email
	from   tInvoice i (nolock)
	inner join tCompany cli (nolock) on i.ClientKey = cli.CompanyKey
	left outer join vUserName u (nolock) on cli.BillingEmailContact = u.UserKey
	where i.InvoiceKey = @InvoiceKey
	
	if isnull(@BillingEmailContactEmail, '') <> ''
		-- there is a valid email where to send the invoice to
		select @BillingEmailContactEmail as Email
			  ,null as [InvoiceEmails]
		      ,@BillingEmailContactName as ContactName
			  ,i.InvoiceNumber, i.HeaderComment, i.InvoiceStatus 
		from   tInvoice i (nolock)
		where i.InvoiceKey = @InvoiceKey
	else
		-- business as usual, get contact from invoice
		SELECT	u.Email, u.InvoiceEmails, i.ContactName, i.InvoiceNumber, i.HeaderComment, i.InvoiceStatus 
		FROM	tUser u (NOLOCK)
		INNER JOIN tInvoice i (NOLOCK) ON i.PrimaryContactKey = u.UserKey
		WHERE	i.InvoiceKey = @InvoiceKey
GO
