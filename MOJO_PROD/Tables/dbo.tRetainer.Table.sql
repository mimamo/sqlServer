USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRetainer]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRetainer](
	[RetainerKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[Frequency] [smallint] NULL,
	[NumberOfPeriods] [int] NOT NULL,
	[AmountPerPeriod] [money] NOT NULL,
	[LastBillingDate] [smalldatetime] NULL,
	[IncludeLabor] [tinyint] NULL,
	[IncludeExpense] [tinyint] NULL,
	[CustomFieldKey] [int] NULL,
	[Active] [tinyint] NULL,
	[LineFormat] [smallint] NULL,
	[InvoiceApprovedBy] [int] NULL,
	[InvoiceExpensesSeperate] [tinyint] NULL,
	[SalesAccountKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[Description] [text] NULL,
	[ClassKey] [int] NULL,
	[ContactKey] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[BillingManagerKey] [int] NULL,
	[CostPerPeriod] [money] NULL,
 CONSTRAINT [PK_tRetainer] PRIMARY KEY CLUSTERED 
(
	[RetainerKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
