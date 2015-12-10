USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceValidateNumber]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceValidateNumber]

	(
		@CompanyKey int,
		@ClientKey int,
		@InvoiceNumber varchar(35)
	)

AS --Encrypt

Declare @InvoiceKey int


Select @InvoiceKey = InvoiceKey
From tInvoice (nolock)
Where
	CompanyKey = @CompanyKey and
	ClientKey = @ClientKey and
	InvoiceNumber = @InvoiceNumber and
	InvoiceStatus = 4
	
return isnull(@InvoiceKey , 0)
GO
