USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectRollup]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectRollup](
	[ProjectKey] [int] NOT NULL,
	[Hours] [decimal](24, 4) NOT NULL,
	[HoursApproved] [decimal](24, 4) NOT NULL,
	[LaborNet] [money] NOT NULL,
	[LaborNetApproved] [money] NOT NULL,
	[LaborGross] [money] NOT NULL,
	[LaborGrossApproved] [money] NOT NULL,
	[LaborUnbilled] [money] NOT NULL,
	[LaborWriteOff] [money] NOT NULL,
	[MiscCostNet] [money] NOT NULL,
	[MiscCostGross] [money] NOT NULL,
	[MiscCostUnbilled] [money] NOT NULL,
	[MiscCostWriteOff] [money] NOT NULL,
	[ExpReceiptNet] [money] NOT NULL,
	[ExpReceiptNetApproved] [money] NOT NULL,
	[ExpReceiptGross] [money] NOT NULL,
	[ExpReceiptGrossApproved] [money] NOT NULL,
	[ExpReceiptUnbilled] [money] NOT NULL,
	[ExpReceiptWriteOff] [money] NOT NULL,
	[VoucherNet] [money] NOT NULL,
	[VoucherNetApproved] [money] NOT NULL,
	[VoucherGross] [money] NOT NULL,
	[VoucherGrossApproved] [money] NOT NULL,
	[VoucherUnbilled] [money] NOT NULL,
	[VoucherWriteOff] [money] NOT NULL,
	[OpenOrderNet] [money] NOT NULL,
	[OpenOrderNetApproved] [money] NOT NULL,
	[OpenOrderGross] [money] NOT NULL,
	[OpenOrderGrossApproved] [money] NOT NULL,
	[OrderPrebilled] [money] NOT NULL,
	[BilledAmount] [money] NOT NULL,
	[AdvanceBilled] [money] NOT NULL,
	[AdvanceBilledOpen] [money] NOT NULL,
	[VoucherOutsideCostsGross] [money] NULL,
	[VoucherOutsideCostsGrossApproved] [money] NULL,
	[UpdateStarted] [datetime] NULL,
	[UpdateEnded] [datetime] NULL,
	[UpdateString] [varchar](250) NULL,
	[BilledAmountNoTax] [money] NULL,
	[EstQty] [decimal](24, 4) NULL,
	[EstNet] [money] NULL,
	[EstGross] [money] NULL,
	[EstCOQty] [decimal](24, 4) NULL,
	[EstCONet] [money] NULL,
	[EstCOGross] [money] NULL,
	[HoursBilled] [decimal](24, 4) NULL,
	[HoursInvoiced] [decimal](24, 4) NULL,
	[LaborInvoiced] [money] NULL,
	[LaborBilled] [money] NULL,
	[MiscCostBilled] [money] NULL,
	[MiscCostInvoiced] [money] NULL,
	[ExpReceiptBilled] [money] NULL,
	[ExpReceiptInvoiced] [money] NULL,
	[VoucherBilled] [money] NULL,
	[VoucherInvoiced] [money] NULL,
	[BilledAmountApproved] [money] NULL,
	[OpenOrderUnbilled] [money] NULL,
	[TransferInLabor] [money] NULL,
	[TransferOutLabor] [money] NULL,
	[TransferInExpense] [money] NULL,
	[TransferOutExpense] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectRollup]  WITH NOCHECK ADD  CONSTRAINT [FK_tProjectRollup_tProject] FOREIGN KEY([ProjectKey])
REFERENCES [dbo].[tProject] ([ProjectKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tProjectRollup] CHECK CONSTRAINT [FK_tProjectRollup_tProject]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_Hours]  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_HoursApproved]  DEFAULT ((0)) FOR [HoursApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_LaborNet]  DEFAULT ((0)) FOR [LaborNet]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_LaborNetApproved]  DEFAULT ((0)) FOR [LaborNetApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_LaborGross]  DEFAULT ((0)) FOR [LaborGross]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_LaborGrossApproved]  DEFAULT ((0)) FOR [LaborGrossApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_LaborUnbilled]  DEFAULT ((0)) FOR [LaborUnbilled]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_LaborWriteOff]  DEFAULT ((0)) FOR [LaborWriteOff]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_MiscCostNet]  DEFAULT ((0)) FOR [MiscCostNet]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_MiscCostGross]  DEFAULT ((0)) FOR [MiscCostGross]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_MiscCostUnbilled]  DEFAULT ((0)) FOR [MiscCostUnbilled]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_MiscCostWriteOff]  DEFAULT ((0)) FOR [MiscCostWriteOff]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_ExpReceiptNet]  DEFAULT ((0)) FOR [ExpReceiptNet]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_ExpReceiptNetApproved]  DEFAULT ((0)) FOR [ExpReceiptNetApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_ExpReceiptGross]  DEFAULT ((0)) FOR [ExpReceiptGross]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_ExpReceiptGrossApproved]  DEFAULT ((0)) FOR [ExpReceiptGrossApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_ExpReceiptUnbilled]  DEFAULT ((0)) FOR [ExpReceiptUnbilled]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_ExpReceiptWriteOff]  DEFAULT ((0)) FOR [ExpReceiptWriteOff]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_VoucherNet]  DEFAULT ((0)) FOR [VoucherNet]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_VoucherNetApproved]  DEFAULT ((0)) FOR [VoucherNetApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_VoucherGross]  DEFAULT ((0)) FOR [VoucherGross]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_VoucherGrossApproved]  DEFAULT ((0)) FOR [VoucherGrossApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_VoucherUnbilled]  DEFAULT ((0)) FOR [VoucherUnbilled]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_VoucherWriteOff]  DEFAULT ((0)) FOR [VoucherWriteOff]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_OpenOrderNet]  DEFAULT ((0)) FOR [OpenOrderNet]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_OpenOrderNetApproved]  DEFAULT ((0)) FOR [OpenOrderNetApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_OpenOrderGross]  DEFAULT ((0)) FOR [OpenOrderGross]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_OpenOrderGrossApproved]  DEFAULT ((0)) FOR [OpenOrderGrossApproved]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_OrderPrebilled]  DEFAULT ((0)) FOR [OrderPrebilled]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_BilledAmount]  DEFAULT ((0)) FOR [BilledAmount]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_AdvanceBilled]  DEFAULT ((0)) FOR [AdvanceBilled]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectLookup_AdvanceBilledOpen]  DEFAULT ((0)) FOR [AdvanceBilledOpen]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectRollup_BilledAmountNoTax]  DEFAULT ((0)) FOR [BilledAmountNoTax]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectRollup_EstQty]  DEFAULT ((0)) FOR [EstQty]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectRollup_EstCOQty]  DEFAULT ((0)) FOR [EstCOQty]
GO
ALTER TABLE [dbo].[tProjectRollup] ADD  CONSTRAINT [DF_tProjectRollup_BilledAmountApproved]  DEFAULT ((0)) FOR [BilledAmountApproved]
GO
