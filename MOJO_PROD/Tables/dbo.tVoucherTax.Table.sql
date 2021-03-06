USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVoucherTax]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tVoucherTax](
	[VoucherKey] [int] NOT NULL,
	[SalesTaxKey] [int] NOT NULL,
	[SalesTaxAmount] [money] NOT NULL,
	[Type] [smallint] NULL,
	[VoucherDetailKey] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tVoucherTax] ADD  CONSTRAINT [DF_tVoucherTax_Type]  DEFAULT ((1)) FOR [Type]
GO
