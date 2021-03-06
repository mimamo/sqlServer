USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrderDetail]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPurchaseOrderDetail](
	[PurchaseOrderDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[PurchaseOrderKey] [int] NULL,
	[LineNumber] [int] NULL,
	[LinkID] [varchar](100) NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ClassKey] [int] NULL,
	[ShortDescription] [varchar](max) NULL,
	[LongDescription] [varchar](6000) NULL,
	[ItemKey] [int] NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitCost] [money] NULL,
	[UnitDescription] [varchar](30) NULL,
	[TotalCost] [money] NULL,
	[Billable] [tinyint] NULL,
	[Markup] [decimal](24, 4) NULL,
	[BillableCost] [money] NULL,
	[AppliedCost] [money] NULL,
	[MakeGoodKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[QuoteReplyDetailKey] [int] NULL,
	[InvoiceLineKey] [int] NULL,
	[AmountBilled] [money] NULL,
	[DateBilled] [smalldatetime] NULL,
	[Closed] [tinyint] NULL,
	[DetailOrderDate] [smalldatetime] NULL,
	[DetailOrderEndDate] [smalldatetime] NULL,
	[UserDate1] [smalldatetime] NULL,
	[UserDate2] [smalldatetime] NULL,
	[UserDate3] [smalldatetime] NULL,
	[UserDate4] [smalldatetime] NULL,
	[UserDate5] [smalldatetime] NULL,
	[UserDate6] [smalldatetime] NULL,
	[OrderDays] [varchar](50) NULL,
	[OrderTime] [varchar](50) NULL,
	[OrderLength] [varchar](50) NULL,
	[OnHold] [tinyint] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[BilledComment] [varchar](2000) NULL,
	[TransferComment] [varchar](500) NULL,
	[AccruedCost] [money] NULL,
	[AdjustmentNumber] [int] NULL,
	[MediaRevisionReasonKey] [int] NULL,
	[UnitRate] [money] NULL,
	[AutoAdjustment] [tinyint] NULL,
	[DateClosed] [smalldatetime] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[AccruedExpenseInAccountKey] [int] NULL,
	[TransferInDate] [smalldatetime] NULL,
	[TransferOutDate] [smalldatetime] NULL,
	[TransferFromKey] [int] NULL,
	[TransferToKey] [int] NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[BilledItem] [int] NULL,
	[CostToClient] [money] NULL,
	[LineType] [varchar](50) NULL,
	[Columns] [int] NULL,
	[Inches] [decimal](24, 4) NULL,
	[Commission] [decimal](24, 4) NULL,
	[MediaPremiumKey] [int] NULL,
	[PremiumAmountType] [varchar](50) NULL,
	[PremiumPct] [decimal](24, 4) NULL,
	[PCurrencyID] [varchar](10) NULL,
	[PExchangeRate] [decimal](24, 7) NULL,
	[PTotalCost] [money] NULL,
	[PAppliedCost] [money] NULL,
	[Quantity1] [decimal](24, 4) NULL,
	[Quantity2] [decimal](24, 4) NULL,
	[GrossAmount] [money] NULL,
	[OldDetailOrderDate] [smalldatetime] NULL,
	[OldShortDescription] [varchar](max) NULL,
	[OldMediaPrintSpaceKey] [int] NULL,
	[OldMediaPrintPositionKey] [int] NULL,
	[OldCompanyMediaPrintContractKey] [int] NULL,
	[OldMediaPrintSpaceID] [varchar](500) NULL,
	[CommissionablePremium] [tinyint] NULL,
	[DetailVendorKey] [int] NULL,
	[Bucket] [int] NULL,
	[OldMediaPrintPositionID] [varchar](500) NULL,
	[Cancelled] [tinyint] NULL,
	[RootTransferFromKey] [int] NULL,
 CONSTRAINT [PK_tPurchaseOrderDetail] PRIMARY KEY NONCLUSTERED 
(
	[PurchaseOrderDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_MakeGood]  DEFAULT ((0)) FOR [MakeGoodKey]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_AmountBilled]  DEFAULT ((0)) FOR [AmountBilled]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_Closed]  DEFAULT ((0)) FOR [Closed]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_Taxable]  DEFAULT ((0)) FOR [Taxable]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_Taxable2]  DEFAULT ((0)) FOR [Taxable2]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_AdjustmentNumber]  DEFAULT ((0)) FOR [AdjustmentNumber]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_SalesTaxAmount]  DEFAULT ((0)) FOR [SalesTaxAmount]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_SalesTax1Amount]  DEFAULT ((0)) FOR [SalesTax1Amount]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_SalesTax2Amount]  DEFAULT ((0)) FOR [SalesTax2Amount]
GO
ALTER TABLE [dbo].[tPurchaseOrderDetail] ADD  CONSTRAINT [DF_tPurchaseOrderDetail_PExchangeRate]  DEFAULT ((1)) FOR [PExchangeRate]
GO
