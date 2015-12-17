USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVoucher]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tVoucher](
	[VoucherKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[VendorKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[InvoiceDate] [smalldatetime] NULL,
	[PostingDate] [smalldatetime] NULL,
	[InvoiceNumber] [varchar](50) NULL,
	[RecurringParentKey] [int] NULL,
	[DateReceived] [smalldatetime] NULL,
	[DateCreated] [smalldatetime] NULL,
	[APAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[CreatedByKey] [int] NULL,
	[TermsPercent] [decimal](24, 4) NULL,
	[TermsDays] [int] NULL,
	[TermsNet] [int] NULL,
	[DueDate] [smalldatetime] NULL,
	[Description] [text] NULL,
	[VoucherTotal] [money] NULL,
	[AmountPaid] [money] NULL,
	[ApprovedDate] [smalldatetime] NULL,
	[ApprovedByKey] [int] NULL,
	[Status] [smallint] NULL,
	[ApprovalComments] [varchar](500) NULL,
	[Posted] [tinyint] NULL,
	[Downloaded] [tinyint] NULL,
	[StatusReportKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[BottomLineInvoice] [tinyint] NULL,
	[InvoiceYear] [varchar](4) NULL,
	[InvoiceMonth] [varchar](2) NULL,
	[OpeningTransaction] [tinyint] NULL,
	[SalesTaxAmount] [money] NULL,
	[VoucherType] [smallint] NULL,
	[CreditCard] [tinyint] NULL,
	[BoughtFromKey] [int] NULL,
	[BoughtFrom] [varchar](250) NULL,
	[BoughtByKey] [int] NULL,
	[CCEntryKey] [int] NULL,
	[Receipt] [tinyint] NULL,
	[VoucherID] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
	[PCurrencyID] [varchar](10) NULL,
	[PExchangeRate] [decimal](24, 7) NULL,
	[DateSentToVendor] [smalldatetime] NULL,
	[DateViewedByVendor] [smalldatetime] NULL,
	[DateCCUsed] [smalldatetime] NULL,
	[CCNumber] [varchar](100) NULL,
	[CCExpMonth] [tinyint] NULL,
	[CCExpYear] [int] NULL,
	[CCV] [varchar](50) NULL,
	[AmexRefNumber] [varchar](50) NULL,
	[ViewedByName] [varchar](250) NULL,
	[CompanyMediaKey] [int] NULL,
	[SalesTax1AmountControl] [money] NULL,
	[SalesTax2AmountControl] [money] NULL,
	[VoucherTotalNoTaxesControl] [money] NULL,
	[PreAuthCCExpDate] [smalldatetime] NULL,
	[VCardID] [varchar](250) NULL,
 CONSTRAINT [PK_tVoucher] PRIMARY KEY NONCLUSTERED 
(
	[VoucherKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_RecurringParentKey]  DEFAULT ((0)) FOR [RecurringParentKey]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_AmountPaid]  DEFAULT ((0)) FOR [AmountPaid]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_Posted]  DEFAULT ((0)) FOR [Posted]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_SalesTax1Amount]  DEFAULT ((0)) FOR [SalesTax1Amount]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_SalesTax2Amount]  DEFAULT ((0)) FOR [SalesTax2Amount]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_OpeningTransaction]  DEFAULT ((0)) FOR [OpeningTransaction]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_SalesTaxAmount]  DEFAULT ((0)) FOR [SalesTaxAmount]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_CreditCard]  DEFAULT ((0)) FOR [CreditCard]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
ALTER TABLE [dbo].[tVoucher] ADD  CONSTRAINT [DF_tVoucher_PExchangeRate]  DEFAULT ((1)) FOR [PExchangeRate]
GO
