USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceTax]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tInvoiceTax](
	[InvoiceKey] [int] NOT NULL,
	[InvoiceLineKey] [int] NOT NULL,
	[SalesTaxKey] [int] NOT NULL,
	[SalesTaxAmount] [money] NOT NULL,
	[Type] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tInvoiceTax] ADD  CONSTRAINT [DF_tInvoiceTax_Type]  DEFAULT ((1)) FOR [Type]
GO
