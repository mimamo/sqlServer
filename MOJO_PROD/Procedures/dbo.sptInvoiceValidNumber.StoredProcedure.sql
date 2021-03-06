USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceValidNumber]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceValidNumber]
	@CompanyKey int,
	@InvoiceNumber varchar(35)
AS --Encrypt

	DECLARE	@InvoiceKey int
	
	SELECT	@InvoiceKey = InvoiceKey
	FROM	tInvoice (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		InvoiceNumber = @InvoiceNumber
	
	RETURN @InvoiceKey
GO
