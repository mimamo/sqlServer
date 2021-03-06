USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrderDetailTax]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPurchaseOrderDetailTax](
	[PurchaseOrderDetailKey] [int] NOT NULL,
	[SalesTaxKey] [int] NOT NULL,
	[SalesTaxAmount] [money] NOT NULL,
 CONSTRAINT [IX_tPurchaseOrderDetailTax] UNIQUE NONCLUSTERED 
(
	[PurchaseOrderDetailKey] ASC,
	[SalesTaxKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetailTax] ADD  CONSTRAINT [DF_tPurchaseOrderDetailTax_SalesTaxAmount]  DEFAULT ((0)) FOR [SalesTaxAmount]
GO
