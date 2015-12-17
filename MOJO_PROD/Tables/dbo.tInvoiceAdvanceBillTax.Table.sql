USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceAdvanceBillTax]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tInvoiceAdvanceBillTax](
	[InvoiceKey] [int] NOT NULL,
	[AdvBillInvoiceKey] [int] NOT NULL,
	[SalesTaxKey] [int] NOT NULL,
	[Amount] [money] NOT NULL
) ON [PRIMARY]
GO
