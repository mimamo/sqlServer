USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVoucherCCDetail]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tVoucherCCDetail](
	[VoucherKey] [int] NOT NULL,
	[VoucherCCKey] [int] NOT NULL,
	[CashTransactionLineKey] [int] NOT NULL,
	[Amount] [money] NOT NULL
) ON [PRIMARY]
GO
