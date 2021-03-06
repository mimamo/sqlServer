USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCheck]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCheck](
	[CheckKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientKey] [int] NOT NULL,
	[CheckAmount] [money] NOT NULL,
	[CheckDate] [smalldatetime] NOT NULL,
	[PostingDate] [smalldatetime] NULL,
	[ReferenceNumber] [varchar](100) NULL,
	[Description] [varchar](500) NULL,
	[CashAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[Posted] [tinyint] NULL,
	[Downloaded] [tinyint] NULL,
	[PrepayAccountKey] [int] NULL,
	[DepositKey] [int] NULL,
	[CheckMethodKey] [int] NULL,
	[VoidCheckKey] [int] NULL,
	[CardHolderName] [varchar](250) NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[Address3] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](20) NULL,
	[CustomerContactKey] [int] NULL,
	[Comment] [varchar](500) NULL,
	[CCNumber] [varchar](200) NULL,
	[ExpMonth] [varchar](2) NULL,
	[ExpYear] [varchar](2) NULL,
	[CVV] [varchar](10) NULL,
	[AuthCode] [varchar](100) NULL,
	[GLCompanyKey] [int] NULL,
	[OpeningTransaction] [tinyint] NULL,
	[CompanyKey] [int] NULL,
	[RecurringParentKey] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
 CONSTRAINT [tCheck_PK] PRIMARY KEY CLUSTERED 
(
	[CheckKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCheck]  WITH CHECK ADD  CONSTRAINT [tCompany_tCheck_FK1] FOREIGN KEY([ClientKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tCheck] CHECK CONSTRAINT [tCompany_tCheck_FK1]
GO
ALTER TABLE [dbo].[tCheck] ADD  CONSTRAINT [DF_tCheck_Posted]  DEFAULT ((0)) FOR [Posted]
GO
ALTER TABLE [dbo].[tCheck] ADD  CONSTRAINT [DF_tCheck_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tCheck] ADD  CONSTRAINT [DF_tCheck_VoidCheckKey]  DEFAULT ((0)) FOR [VoidCheckKey]
GO
ALTER TABLE [dbo].[tCheck] ADD  CONSTRAINT [DF_tCheck_OpeningTransaction]  DEFAULT ((0)) FOR [OpeningTransaction]
GO
ALTER TABLE [dbo].[tCheck] ADD  CONSTRAINT [DF_tCheck_RecurringParentKey]  DEFAULT ((0)) FOR [RecurringParentKey]
GO
ALTER TABLE [dbo].[tCheck] ADD  CONSTRAINT [DF_tCheck_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
