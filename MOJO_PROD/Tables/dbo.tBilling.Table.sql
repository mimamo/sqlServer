USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBilling]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBilling](
	[BillingKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[BillingID] [int] NOT NULL,
	[BillingMethod] [smallint] NOT NULL,
	[ProjectKey] [int] NULL,
	[EstimateKey] [int] NULL,
	[ClassKey] [int] NULL,
	[InvoiceComment] [varchar](500) NULL,
	[WorkSheetComment] [varchar](4000) NULL,
	[ApprovalComments] [varchar](2000) NULL,
	[Status] [smallint] NULL,
	[ParentWorksheet] [tinyint] NULL,
	[ParentWorksheetKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[TermsKey] [int] NULL,
	[DefaultARLineFormat] [smallint] NULL,
	[DefaultSalesAccountKey] [int] NULL,
	[FixedFeeDisplay] [smallint] NULL,
	[FixedFeeCalcMethod] [smallint] NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[LineFormat] [smallint] NULL,
	[Approver] [int] NULL,
	[AdvanceBill] [tinyint] NULL,
	[DisplayOrder] [int] NULL,
	[GroupEntity] [varchar](50) NULL,
	[GroupEntityKey] [int] NULL,
	[RetainerAmount] [money] NULL,
	[RetainerDescription] [varchar](1500) NULL,
	[FFTotal] [money] NULL,
	[LaborTotal] [money] NULL,
	[ExpenseTotal] [money] NULL,
	[WOTotal] [money] NULL,
	[MBTotal] [money] NULL,
	[HoldTotal] [money] NULL,
	[OffHoldTotal] [money] NULL,
	[TransferTotal] [money] NULL,
	[DoNotBillTotal] [money] NULL,
	[DateCreated] [smalldatetime] NULL,
	[DueDate] [smalldatetime] NULL,
	[DateReviewed] [smalldatetime] NULL,
	[InvoiceKey] [int] NULL,
	[ErrorMsg] [varchar](500) NULL,
	[GeneratedLabor] [money] NULL,
	[GeneratedExpense] [money] NULL,
	[AddressKey] [int] NULL,
	[PrimaryContactKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[FixedFeeGroupByBI] [tinyint] NULL,
	[LayoutKey] [int] NULL,
	[DefaultAsOfDate] [smalldatetime] NULL,
	[CurrencyID] [varchar](10) NULL,
 CONSTRAINT [PK_tBilling] PRIMARY KEY CLUSTERED 
(
	[BillingKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tBilling] ADD  CONSTRAINT [DF_tBilling_FixedFeeCalcMethod]  DEFAULT ((0)) FOR [FixedFeeCalcMethod]
GO
ALTER TABLE [dbo].[tBilling] ADD  CONSTRAINT [DF_tBilling_GeneratedLabor]  DEFAULT ((0)) FOR [GeneratedLabor]
GO
ALTER TABLE [dbo].[tBilling] ADD  CONSTRAINT [DF_tBilling_GeneratedExpense]  DEFAULT ((0)) FOR [GeneratedExpense]
GO
