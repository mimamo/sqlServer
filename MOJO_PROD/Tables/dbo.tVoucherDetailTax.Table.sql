USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVoucherDetailTax]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tVoucherDetailTax](
	[VoucherDetailTaxKey] [int] NULL,
	[VoucherDetailKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTaxAmount] [money] NULL
) ON [PRIMARY]
GO
