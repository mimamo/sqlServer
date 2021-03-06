USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTransactionOrderAccrual]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTransactionOrderAccrual](
	[PurchaseOrderDetailKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[VoucherDetailKey] [int] NULL,
	[AccrualAmount] [money] NULL,
	[UnaccrualAmount] [money] NULL,
	[TransactionKey] [int] NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[PostingDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTransactionOrderAccrual] ADD  CONSTRAINT [DF_tTransactionOrderAccrual_AccrualAmount]  DEFAULT ((0)) FOR [AccrualAmount]
GO
ALTER TABLE [dbo].[tTransactionOrderAccrual] ADD  CONSTRAINT [DF_tTransactionOrderAccrual_UnaccrualAmount]  DEFAULT ((0)) FOR [UnaccrualAmount]
GO
