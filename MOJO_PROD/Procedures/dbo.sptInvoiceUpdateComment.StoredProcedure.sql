USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceUpdateComment]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceUpdateComment]

	(
		@InvoiceKey int,
		@ApprovalComments varchar(500)
	)

AS --Encrypt

	Update
		tInvoice
	Set
		ApprovalComments = @ApprovalComments
	Where
		InvoiceKey = @InvoiceKey
GO
