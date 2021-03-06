USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoice]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tInvoice](
	[InvoiceKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[ParentInvoice] [tinyint] NOT NULL,
	[ParentInvoiceKey] [int] NULL,
	[PercentageSplit] [decimal](24, 4) NULL,
	[ContactName] [varchar](100) NULL,
	[BillingContactKey] [int] NULL,
	[AdvanceBill] [tinyint] NOT NULL,
	[InvoiceNumber] [varchar](35) NULL,
	[InvoiceDate] [smalldatetime] NULL,
	[DueDate] [smalldatetime] NULL,
	[PostingDate] [smalldatetime] NULL,
	[RecurringParentKey] [int] NULL,
	[TermsKey] [int] NULL,
	[ARAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[RetainerAmount] [money] NULL,
	[WriteoffAmount] [money] NULL,
	[DiscountAmount] [money] NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax1Amount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[TotalNonTaxAmount] [money] NULL,
	[InvoiceTotalAmount] [money] NULL,
	[AmountReceived] [money] NULL,
	[HeaderComment] [text] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[InvoiceStatus] [smallint] NOT NULL,
	[ApprovedDate] [smalldatetime] NULL,
	[ApprovedByKey] [int] NULL,
	[ApprovalComments] [varchar](500) NULL,
	[Posted] [tinyint] NULL,
	[Downloaded] [tinyint] NULL,
	[Printed] [tinyint] NULL,
	[InvoiceTemplateKey] [int] NULL,
	[UserDefined1] [varchar](250) NULL,
	[UserDefined2] [varchar](250) NULL,
	[UserDefined3] [varchar](250) NULL,
	[UserDefined4] [varchar](250) NULL,
	[UserDefined5] [varchar](250) NULL,
	[UserDefined6] [varchar](250) NULL,
	[UserDefined7] [varchar](250) NULL,
	[UserDefined8] [varchar](250) NULL,
	[UserDefined9] [varchar](250) NULL,
	[UserDefined10] [varchar](250) NULL,
	[EstimateKey] [int] NULL,
	[RetainerKey] [int] NULL,
	[PrimaryContactKey] [int] NULL,
	[AddressKey] [int] NULL,
	[Emailed] [tinyint] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[OpeningTransaction] [tinyint] NULL,
	[LayoutKey] [int] NULL,
	[CampaignKey] [int] NULL,
	[MediaEstimateKey] [int] NULL,
	[AlternatePayerKey] [int] NULL,
	[BillingGroupKey] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
	[VoidInvoiceKey] [int] NULL,
	[DateCreated] [smalldatetime] NULL,
	[CreatedByKey] [int] NULL,
	[BillingKey] [int] NULL,
 CONSTRAINT [tInvoice_PK] PRIMARY KEY CLUSTERED 
(
	[InvoiceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_ParentInvoice]  DEFAULT ((0)) FOR [ParentInvoice]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_AdvanceBill]  DEFAULT ((0)) FOR [AdvanceBill]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_RecurringParentKey]  DEFAULT ((0)) FOR [RecurringParentKey]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_SalesTax1Amount]  DEFAULT ((0)) FOR [SalesTax1Amount]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_SalesTax2Amount]  DEFAULT ((0)) FOR [SalesTax2Amount]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_AmountReceived]  DEFAULT ((0)) FOR [AmountReceived]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_Posted]  DEFAULT ((0)) FOR [Posted]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_OpeningTransaction]  DEFAULT ((0)) FOR [OpeningTransaction]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
ALTER TABLE [dbo].[tInvoice] ADD  CONSTRAINT [DF_tInvoice_VoidInvoiceKey]  DEFAULT ((0)) FOR [VoidInvoiceKey]
GO
