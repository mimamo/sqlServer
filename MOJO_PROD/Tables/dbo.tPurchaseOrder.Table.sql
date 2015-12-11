USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPurchaseOrder]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPurchaseOrder](
	[PurchaseOrderKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[POKind] [smallint] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[PurchaseOrderTypeKey] [int] NOT NULL,
	[PurchaseOrderNumber] [varchar](30) NULL,
	[MediaEstimateKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ItemKey] [int] NULL,
	[ClassKey] [int] NULL,
	[VendorKey] [int] NULL,
	[CompanyMediaKey] [int] NULL,
	[Contact] [varchar](200) NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[Address3] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](20) NULL,
	[Country] [varchar](50) NULL,
	[DateCreated] [smalldatetime] NULL,
	[CreatedByKey] [int] NULL,
	[PODate] [smalldatetime] NULL,
	[DueDate] [smalldatetime] NULL,
	[OrderedBy] [varchar](200) NULL,
	[SpecialInstructions] [varchar](max) NULL,
	[DeliveryInstructions] [varchar](1000) NULL,
	[DeliverTo1] [varchar](100) NULL,
	[DeliverTo2] [varchar](100) NULL,
	[DeliverTo3] [varchar](100) NULL,
	[DeliverTo4] [varchar](100) NULL,
	[Revision] [int] NULL,
	[ApprovedDate] [smalldatetime] NULL,
	[ApprovedByKey] [int] NULL,
	[ApprovalComments] [varchar](500) NULL,
	[Status] [smallint] NULL,
	[Closed] [tinyint] NULL,
	[Printed] [tinyint] NULL,
	[Downloaded] [tinyint] NULL,
	[BillAt] [smallint] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[LastUpdateBy] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[HeaderTextKey] [int] NULL,
	[FooterTextKey] [int] NULL,
	[OrderDisplayMode] [smallint] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[PurchaseOrderTotal] [money] NULL,
	[FlightStartDate] [smalldatetime] NULL,
	[FlightEndDate] [smalldatetime] NULL,
	[FlightInterval] [tinyint] NULL,
	[PrintClientOnOrder] [tinyint] NULL,
	[PrintTraffic] [tinyint] NULL,
	[GLCompanyKey] [int] NULL,
	[CompanyAddressKey] [int] NULL,
	[UseClientCosting] [tinyint] NULL,
	[SalesTaxAmount] [money] NULL,
	[PrintOption] [tinyint] NULL,
	[MediaWorksheetKey] [int] NULL,
	[MediaCategoryKey] [int] NULL,
	[MediaMarketKey] [int] NULL,
	[OrderingStatus] [varchar](50) NULL,
	[InternalID] [int] NULL,
	[DateSent] [smalldatetime] NULL,
	[MediaPrintSpaceKey] [int] NULL,
	[CompanyMediaPrintContractKey] [int] NULL,
	[CompanyMediaRateCardKey] [int] NULL,
	[MediaUnitTypeKey] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
	[PExchangeRate] [decimal](24, 7) NULL,
	[PCurrencyID] [varchar](10) NULL,
	[Emailed] [tinyint] NULL,
	[MediaPrintPositionKey] [int] NULL,
	[MediaPrintSpaceID] [varchar](500) NULL,
	[Cancelled] [tinyint] NULL,
	[MediaPrintPositionID] [varchar](500) NULL,
	[PlacementTag] [varchar](500) NULL,
	[Description] [varchar](max) NULL,
	[MediaAffiliateKey] [int] NULL,
	[MediaDayKey] [int] NULL,
	[MediaDayPartKey] [int] NULL,
	[MediaLen] [int] NULL,
	[BillingBase] [smallint] NULL,
	[BillingAdjPercent] [decimal](24, 4) NULL,
	[BillingAdjBase] [smallint] NULL,
	[MediaWorksheetDemoKey] [int] NULL,
	[ShowAdjustmentsAsSingleLine] [tinyint] NULL,
	[MediaOrderKey] [int] NULL,
	[DownloadDate] [smalldatetime] NULL,
 CONSTRAINT [PK_tPurchaseOrder] PRIMARY KEY NONCLUSTERED 
(
	[PurchaseOrderKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPurchaseOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_tPurchaseOrder_tCompanyMedia] FOREIGN KEY([CompanyMediaKey])
REFERENCES [dbo].[tCompanyMedia] ([CompanyMediaKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tPurchaseOrder] NOCHECK CONSTRAINT [FK_tPurchaseOrder_tCompanyMedia]
GO
ALTER TABLE [dbo].[tPurchaseOrder]  WITH NOCHECK ADD  CONSTRAINT [FK_tPurchaseOrder_tMediaWorksheet] FOREIGN KEY([MediaWorksheetKey])
REFERENCES [dbo].[tMediaWorksheet] ([MediaWorksheetKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tPurchaseOrder] NOCHECK CONSTRAINT [FK_tPurchaseOrder_tMediaWorksheet]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_POKind]  DEFAULT ((0)) FOR [POKind]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_CreatedByKey]  DEFAULT ((0)) FOR [CreatedByKey]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_Closed]  DEFAULT ((0)) FOR [Closed]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_BillAt]  DEFAULT ((0)) FOR [BillAt]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_SalesTax1Amount]  DEFAULT ((0)) FOR [SalesTax1Amount]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_SalesTax2Amount]  DEFAULT ((0)) FOR [SalesTax2Amount]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_PurchaseOrderTotal]  DEFAULT ((0)) FOR [PurchaseOrderTotal]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_SalesTaxAmount]  DEFAULT ((0)) FOR [SalesTaxAmount]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_PExchangeRate]  DEFAULT ((1)) FOR [PExchangeRate]
GO
ALTER TABLE [dbo].[tPurchaseOrder] ADD  CONSTRAINT [DF_tPurchaseOrder_ShowAdjustmentsAsSingleLine]  DEFAULT ((1)) FOR [ShowAdjustmentsAsSingleLine]
GO
