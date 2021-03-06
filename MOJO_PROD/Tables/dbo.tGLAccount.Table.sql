USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLAccount]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tGLAccount](
	[GLAccountKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[AccountNumber] [varchar](100) NOT NULL,
	[AccountName] [varchar](200) NULL,
	[ParentAccountKey] [int] NULL,
	[AccountType] [smallint] NOT NULL,
	[Rollup] [tinyint] NOT NULL,
	[Description] [varchar](500) NULL,
	[BankAccountNumber] [varchar](50) NULL,
	[CurrentBalance] [money] NOT NULL,
	[NextCheckNumber] [bigint] NULL,
	[LastReconcileDate] [smalldatetime] NULL,
	[StatementDate] [smalldatetime] NULL,
	[StatementBalance] [money] NULL,
	[RecStatus] [smallint] NOT NULL,
	[Active] [tinyint] NOT NULL,
	[DisplayOrder] [int] NULL,
	[DisplayLevel] [int] NULL,
	[LinkID] [varchar](100) NULL,
	[PayrollExpense] [smallint] NULL,
	[FacilityExpense] [smallint] NULL,
	[LaborIncome] [smallint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[AccountTypeCash] [smallint] NULL,
	[VendorKey] [int] NULL,
	[CreditCardNumber] [varchar](100) NULL,
	[CreditCardPassword] [varchar](1000) NULL,
	[CreditCardLogin] [varchar](1000) NULL,
	[DefaultCheckFormatKey] [int] NULL,
	[FIName] [varchar](100) NULL,
	[FIID] [varchar](50) NULL,
	[FIOrg] [varchar](50) NULL,
	[FIUrl] [varchar](100) NULL,
	[NoJournalEntries] [tinyint] NULL,
	[MultiCompanyPayments] [tinyint] NULL,
	[RestrictToGLCompany] [tinyint] NULL,
	[DefaultCCGLCompanyKey] [int] NULL,
	[CCType] [varchar](50) NULL,
	[CCExpMonth] [tinyint] NULL,
	[CCExpYear] [smallint] NULL,
	[FIData] [varchar](100) NULL,
	[CurrencyID] [varchar](10) NULL,
	[CardPoolID] [varchar](500) NULL,
	[SenderID] [varchar](500) NULL,
	[CCDeliveryOption] [smallint] NULL,
	[ManualCCNumber] [varchar](100) NULL,
	[ManualCCExpMonth] [tinyint] NULL,
	[ManualCCExpYear] [smallint] NULL,
	[ManualCCV] [varchar](50) NULL,
	[BacsID] [int] NULL,
	[VCardUserID] [varchar](500) NULL,
	[VCardPW] [varchar](500) NULL,
	[VCardAuthToken] [varchar](500) NULL,
 CONSTRAINT [PK_tGLAccount] PRIMARY KEY NONCLUSTERED 
(
	[GLAccountKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tGLAccount] ADD  CONSTRAINT [DF_tGLAccount_AccountType]  DEFAULT ((0)) FOR [AccountType]
GO
ALTER TABLE [dbo].[tGLAccount] ADD  CONSTRAINT [DF_tGLAccount_Rollup]  DEFAULT ((0)) FOR [Rollup]
GO
ALTER TABLE [dbo].[tGLAccount] ADD  CONSTRAINT [DF_tGLAccount_CurrentBalance]  DEFAULT ((0)) FOR [CurrentBalance]
GO
ALTER TABLE [dbo].[tGLAccount] ADD  CONSTRAINT [DF_tGLAccount_RecStatus]  DEFAULT ((0)) FOR [RecStatus]
GO
ALTER TABLE [dbo].[tGLAccount] ADD  CONSTRAINT [DF_tGLAccount_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tGLAccount] ADD  CONSTRAINT [DF_tGLAccount_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
