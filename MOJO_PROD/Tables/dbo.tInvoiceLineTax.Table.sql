USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceLineTax]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tInvoiceLineTax](
	[InvoiceLineTaxKey] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceLineKey] [int] NOT NULL,
	[SalesTaxKey] [int] NOT NULL,
	[SalesTaxAmount] [money] NOT NULL,
 CONSTRAINT [PK_tInvoiceLineTax] PRIMARY KEY CLUSTERED 
(
	[InvoiceLineTaxKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
