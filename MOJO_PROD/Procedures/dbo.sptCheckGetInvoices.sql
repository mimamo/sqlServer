USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckGetInvoices]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckGetInvoices]
	@CheckKey int
AS --Encrypt

	SELECT	InvoiceKey
	FROM	tCheckAppl (NOLOCK)
	WHERE	CheckKey = @CheckKey
GO
