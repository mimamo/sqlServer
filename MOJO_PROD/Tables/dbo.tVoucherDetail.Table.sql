USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVoucherDetail]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tVoucherDetail](
	[VoucherDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[VoucherKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[LineNumber] [int] NULL,
	[PurchaseOrderDetailKey] [int] NULL,
	[ClientKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ShortDescription] [varchar](2000) NULL,
	[ItemKey] [int] NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitCost] [money] NULL,
	[UnitDescription] [varchar](30) NULL,
	[TotalCost] [money] NULL,
	[Billable] [tinyint] NULL,
	[Markup] [decimal](24, 4) NULL,
	[BillableCost] [money] NULL,
	[AmountBilled] [money] NULL,
	[InvoiceLineKey] [int] NULL,
	[WriteOff] [tinyint] NULL,
	[PrebillAmount] [money] NULL,
	[ExpenseAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[QuantityBilled] [decimal](24, 4) NULL,
	[WIPPostingInKey] [int] NOT NULL,
	[WIPPostingOutKey] [int] NOT NULL,
	[TransferComment] [varchar](500) NULL,
	[WriteOffReasonKey] [int] NULL,
	[DatePaidByClient] [smalldatetime] NULL,
	[DateBilled] [smalldatetime] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[OnHold] [tinyint] NULL,
	[FinalForPO] [tinyint] NULL,
	[BilledComment] [varchar](2000) NULL,
	[LastVoucher] [tinyint] NULL,
	[UnitRate] [money] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [nvarchar](50) NULL,
	[OldExpenseAccountKey] [int] NULL,
	[AccruedExpenseOutAccountKey] [int] NULL,
	[SourceDate] [smalldatetime] NULL,
	[TransferInDate] [smalldatetime] NULL,
	[TransferOutDate] [smalldatetime] NULL,
	[TransferFromKey] [int] NULL,
	[TransferToKey] [int] NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[WIPAmount] [money] NULL,
	[OldWIPAmount] [money] NULL,
	[TargetGLCompanyKey] [int] NULL,
	[BilledItem] [int] NULL,
	[PCurrencyID] [varchar](10) NULL,
	[PExchangeRate] [decimal](24, 7) NULL,
	[PTotalCost] [money] NULL,
	[Commission] [decimal](24, 4) NULL,
	[GrossAmount] [money] NULL,
	[Exclude1099] [money] NULL,
	[RootTransferFromKey] [int] NULL,
	[AdjustmentType] [smallint] NULL,
 CONSTRAINT [PK_tVoucherDetail] PRIMARY KEY NONCLUSTERED 
(
	[VoucherDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tVoucherDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_tVoucherDetail_tVoucher] FOREIGN KEY([VoucherKey])
REFERENCES [dbo].[tVoucher] ([VoucherKey])
GO
ALTER TABLE [dbo].[tVoucherDetail] CHECK CONSTRAINT [FK_tVoucherDetail_tVoucher]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_WriteOff]  DEFAULT ((0)) FOR [WriteOff]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_PreInvoiced]  DEFAULT ((0)) FOR [PrebillAmount]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_WIPPostingInKey]  DEFAULT ((0)) FOR [WIPPostingInKey]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_WIPPostingOutKey]  DEFAULT ((0)) FOR [WIPPostingOutKey]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_Taxable]  DEFAULT ((0)) FOR [Taxable]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_Taxable2]  DEFAULT ((0)) FOR [Taxable2]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_SalesTaxAmount]  DEFAULT ((0)) FOR [SalesTaxAmount]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_SalesTax1Amount]  DEFAULT ((0)) FOR [SalesTax1Amount]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_SalesTax2Amount]  DEFAULT ((0)) FOR [SalesTax2Amount]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_WIPAmount]  DEFAULT ((0)) FOR [WIPAmount]
GO
ALTER TABLE [dbo].[tVoucherDetail] ADD  CONSTRAINT [DF_tVoucherDetail_PExchangeRate]  DEFAULT ((1)) FOR [PExchangeRate]
GO
