USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetList]

	(
		@CompanyKey int,
		@SearchOption int,
		@SearchPhrase varchar(300)
	)

AS --Encrypt

Declare @Key int

If @SearchOption = 1  --Project Number
BEGIN
	Select @Key = ProjectKey from tProject (nolock) Where CompanyKey = @CompanyKey and ProjectNumber = @SearchPhrase
	
	if ISNULL(@Key, 0) = 0
		return 1
	else
		Select * from vInvoice
		Where
			CompanyKey = @CompanyKey and 
			InvoiceKey in (Select Distinct InvoiceKey from tInvoiceLine (nolock) Where ProjectKey = @Key)
		Order By InvoiceDate DESC
		
END

If @SearchOption = 2  -- Invoice Number
	Select * from vInvoice Where CompanyKey = @CompanyKey and InvoiceNumber like @SearchPhrase + '%'
		Order By InvoiceDate DESC

If @SearchOption = 3  -- Client Name
	Select * from vInvoice Where CompanyKey = @CompanyKey and BCompanyName like @SearchPhrase + '%'
		Order By InvoiceDate DESC

If @SearchOption = 4  -- Client Number
	Select * from vInvoice Where CompanyKey = @CompanyKey and CustomerID like @SearchPhrase + '%'
		Order By InvoiceDate DESC

If @SearchOption = 5  -- Invoice Date
	Select * from vInvoice Where CompanyKey = @CompanyKey and InvoiceDate = Cast(@SearchPhrase as smalldatetime)
		Order By InvoiceDate DESC
GO
