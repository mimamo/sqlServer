USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tExpenseReceipt]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tExpenseReceipt](
	[ExpenseReceiptKey] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseEnvelopeKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ExpenseDate] [smalldatetime] NOT NULL,
	[ExpenseType] [int] NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[PaperReceipt] [tinyint] NULL,
	[ActualQty] [decimal](24, 4) NULL,
	[ActualUnitCost] [money] NULL,
	[ActualCost] [money] NULL,
	[Billable] [tinyint] NULL,
	[Markup] [decimal](24, 4) NULL,
	[BillableCost] [money] NULL,
	[Description] [varchar](100) NULL,
	[Comments] [varchar](500) NULL,
	[AmountBilled] [money] NULL,
	[InvoiceLineKey] [int] NULL,
	[WriteOff] [tinyint] NULL,
	[Downloaded] [tinyint] NULL,
	[WIPPostingInKey] [int] NOT NULL,
	[WIPPostingOutKey] [int] NOT NULL,
	[TransferComment] [varchar](500) NULL,
	[WriteOffReasonKey] [int] NULL,
	[DateBilled] [smalldatetime] NULL,
	[OnHold] [tinyint] NULL,
	[BilledComment] [varchar](2000) NULL,
	[UnitRate] [money] NULL,
	[VoucherDetailKey] [int] NULL,
	[ItemKey] [int] NULL,
	[TransferInDate] [smalldatetime] NULL,
	[TransferOutDate] [smalldatetime] NULL,
	[TransferFromKey] [int] NULL,
	[TransferToKey] [int] NULL,
	[WIPAmount] [money] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[BilledItem] [int] NULL,
	[PCurrencyID] [varchar](10) NULL,
	[PExchangeRate] [decimal](24, 7) NULL,
	[PTotalCost] [money] NULL,
	[GrossAmount] [money] NULL,
	[RootTransferFromKey] [int] NULL,
	[AdjustmentType] [smallint] NULL,
 CONSTRAINT [tExpenseReceipt_PK] PRIMARY KEY CLUSTERED 
(
	[ExpenseReceiptKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tExpenseReceipt]  WITH NOCHECK ADD  CONSTRAINT [tExpenseEnvelope_tExpenseReceipt_FK1] FOREIGN KEY([ExpenseEnvelopeKey])
REFERENCES [dbo].[tExpenseEnvelope] ([ExpenseEnvelopeKey])
GO
ALTER TABLE [dbo].[tExpenseReceipt] CHECK CONSTRAINT [tExpenseEnvelope_tExpenseReceipt_FK1]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_WriteOff]  DEFAULT ((0)) FOR [WriteOff]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_DownLoaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_WIPPostingInKey]  DEFAULT ((0)) FOR [WIPPostingInKey]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_WIPPostingOutKey]  DEFAULT ((0)) FOR [WIPPostingOutKey]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_WIPAmount]  DEFAULT ((0)) FOR [WIPAmount]
GO
ALTER TABLE [dbo].[tExpenseReceipt] ADD  CONSTRAINT [DF_tExpenseReceipt_PExchangeRate]  DEFAULT ((1)) FOR [PExchangeRate]
GO
