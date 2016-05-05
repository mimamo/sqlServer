USE [MOJo_dev]
GO

/****** Object:  Table [dbo].[tCompany]    Script Date: 05/02/2016 10:06:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tCompany](
	[CompanyKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](200) NULL,
	[VendorID] [varchar](50) NULL,
	[CustomerID] [varchar](50) NULL,
	[LinkID] [varchar](100) NULL,
	[PrimaryContact] [int] NULL,
	[Vendor] [tinyint] NULL,
	[BillableClient] [tinyint] NULL,
	[Type1099] [smallint] NULL,
	[Box1099] [varchar](10) NULL,
	[EINNumber] [varchar](100) NULL,
	[DefaultExpenseAccountKey] [int] NULL,
	[DefaultSalesAccountKey] [int] NULL,
	[TermsPercent] [decimal](24, 4) NULL,
	[TermsDays] [int] NULL,
	[TermsNet] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[InvoiceTemplateKey] [int] NULL,
	[EstimateTemplateKey] [int] NULL,
	[GetRateFrom] [smallint] NULL,
	[TimeRateSheetKey] [int] NULL,
	[HourlyRate] [money] NULL,
	[GetMarkupFrom] [smallint] NULL,
	[ItemRateSheetKey] [int] NULL,
	[ItemMarkup] [decimal](24, 4) NULL,
	[IOCommission] [decimal](24, 4) NULL,
	[BCCommission] [decimal](24, 4) NULL,
	[IOBillAt] [smallint] NULL,
	[BCBillAt] [smallint] NULL,
	[WebSite] [varchar](100) NULL,
	[OwnerCompanyKey] [int] NULL,
	[ParentCompany] [tinyint] NOT NULL,
	[ParentCompanyKey] [int] NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Active] [tinyint] NULL,
	[Locked] [tinyint] NULL,
	[RootFolderKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[AccountManagerKey] [int] NULL,
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
	[CompanyTypeKey] [int] NULL,
	[ContactOwnerKey] [int] NULL,
	[Comments] [text] NULL,
	[VendorDownloaded] [tinyint] NULL,
	[ClientDownloaded] [tinyint] NULL,
	[NextProjectNum] [int] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[PaymentTermsKey] [int] NULL,
	[CustomLogo] [varchar](100) NULL,
	[DefaultARLineFormat] [smallint] NULL,
	[DefaultTeamKey] [int] NULL,
	[DefaultAPAccountKey] [int] NULL,
	[CardHolderName] [varchar](250) NULL,
	[CCNumber] [varchar](200) NULL,
	[ExpMonth] [varchar](2) NULL,
	[ExpYear] [varchar](2) NULL,
	[CVV] [varchar](10) NULL,
	[DefaultMemo] [varchar](500) NULL,
	[DefaultRetainerKey] [int] NULL,
	[OneInvoicePer] [smallint] NULL,
	[DefaultBillingMethod] [smallint] NULL,
	[DefaultExpensesNotIncluded] [tinyint] NULL,
	[DefaultAddressKey] [int] NULL,
	[BillingAddressKey] [int] NULL,
	[PaymentAddressKey] [int] NULL,
	[OnHold] [tinyint] NULL,
	[StateEINNumber] [varchar](30) NULL,
	[Overhead] [tinyint] NULL,
	[GLCompanyKey] [int] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[CMFolderKey] [int] NULL,
	[SourceKey] [int] NULL,
	[LastActivityKey] [int] NULL,
	[NextActivityKey] [int] NULL,
	[SalesPersonKey] [int] NULL,
	[WWPCurrentLevel] [int] NULL,
	[DateConverted] [smalldatetime] NULL,
	[DBA] [varchar](200) NULL,
	[LayoutKey] [int] NULL,
	[VendorSalesTaxKey] [int] NULL,
	[VendorSalesTax2Key] [int] NULL,
	[NextCampaignNum] [int] NULL,
	[DefaultVoucherType] [smallint] NULL,
	[OfficeKey] [int] NULL,
	[CCPayeeName] [varchar](50) NULL,
	[DefaultAPApproverKey] [int] NULL,
	[OverheadVendor] [tinyint] NULL,
	[BillingName] [varchar](200) NULL,
	[CCAccepted] [tinyint] NULL,
	[ParentCompanyDivisionKey] [int] NULL,
	[AlternatePayerKey] [int] NULL,
	[UseDBAForPayment] [tinyint] NULL,
	[OnePaymentPerVoucher] [tinyint] NULL,
	[WebDavClientID] [varchar](100) NULL,
	[WebDavCompanyName] [varchar](200) NULL,
	[BillingManagerKey] [int] NULL,
	[PrintVendor] [tinyint] NULL,
	[BroadcastVendor] [tinyint] NULL,
	[InteractiveVendor] [tinyint] NULL,
	[OutdoorVendor] [tinyint] NULL,
	[BillingBase] [smallint] NULL,
	[BillingAdjPercent] [decimal](24, 4) NULL,
	[BillingAdjBase] [smallint] NULL,
	[CommissionOnly] [tinyint] NULL,
	[CurrencyID] [varchar](10) NULL,
	[TimeZoneIndex] [int] NULL,
	[BillingEmailContact] [int] NULL,
	[RequireProduct] [tinyint] NULL,
	[RequireDivision] [tinyint] NULL,
	[TitleRateSheetKey] [int] NULL,
	[EmailCCToAddress] [varchar](200) NULL,
	[CCAccountKey] [int] NULL,
	[LockLaborRate] [tinyint] NOT NULL,
	[LockMarkupFrom] [tinyint] NOT NULL,
	[BankAccountNumber] [varchar](500) NULL,
	[BankRoutingNumber] [varchar](500) NULL,
	[BankAccountName] [varchar](100) NULL,
	[AllTrackBudgetTasksOnInvoice] [tinyint] NULL,
	[DoBackup] [smallint] NULL,
	[ProjectColor] [varchar](10) NULL,
	[FATCAFilingRequirement] [tinyint] NULL,
 CONSTRAINT [tCompany_PK] PRIMARY KEY CLUSTERED 
(
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_Type1099]  DEFAULT ((0)) FOR [Type1099]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_TermsPercent]  DEFAULT ((0)) FOR [TermsPercent]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_TermsDays]  DEFAULT ((0)) FOR [TermsDays]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_TermsNet]  DEFAULT ((30)) FOR [TermsNet]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_GetRateFrom]  DEFAULT ((2)) FOR [GetRateFrom]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_GetMarkupFrom]  DEFAULT ((2)) FOR [GetMarkupFrom]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_ItemMarkup]  DEFAULT ((0)) FOR [ItemMarkup]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_IOBillAt]  DEFAULT ((0)) FOR [IOBillAt]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_BCBillAt]  DEFAULT ((0)) FOR [BCBillAt]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_ParentCompany]  DEFAULT ((0)) FOR [ParentCompany]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_NextProjectNum]  DEFAULT ((1)) FOR [NextProjectNum]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_DateUpdated]  DEFAULT (getdate()) FOR [DateUpdated]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_NextCampaignNum]  DEFAULT ((1)) FOR [NextCampaignNum]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_OverheadVendor]  DEFAULT ((0)) FOR [OverheadVendor]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_OnePaymentPerVoucher]  DEFAULT ((0)) FOR [OnePaymentPerVoucher]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_LockLaborRate]  DEFAULT ((0)) FOR [LockLaborRate]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_LockMarkupFrom]  DEFAULT ((0)) FOR [LockMarkupFrom]
GO

ALTER TABLE [dbo].[tCompany] ADD  CONSTRAINT [DF_tCompany_AllTrackBudgetTasksOnInvoice]  DEFAULT ((0)) FOR [AllTrackBudgetTasksOnInvoice]
GO



