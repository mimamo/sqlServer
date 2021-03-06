USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTransactionUnpost]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTransactionUnpost](
	[UnpostLogKey] [int] NULL,
	[TransactionKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[TransactionDate] [smalldatetime] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Reference] [varchar](100) NULL,
	[GLAccountKey] [int] NOT NULL,
	[Debit] [money] NOT NULL,
	[Credit] [money] NOT NULL,
	[ClassKey] [int] NULL,
	[Memo] [varchar](500) NULL,
	[PostMonth] [int] NOT NULL,
	[PostYear] [int] NOT NULL,
	[Reversed] [tinyint] NULL,
	[PostSide] [char](1) NULL,
	[ClientKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[SourceCompanyKey] [int] NULL,
	[Cleared] [tinyint] NULL,
	[DepositKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[DetailLineKey] [int] NULL,
	[Section] [int] NULL,
	[Overhead] [tinyint] NULL,
	[ICTGLCompanyKey] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
	[HDebit] [money] NULL,
	[HCredit] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTransactionUnpost] ADD  CONSTRAINT [DF_tTransactionUnpost_Debit]  DEFAULT ((0)) FOR [Debit]
GO
ALTER TABLE [dbo].[tTransactionUnpost] ADD  CONSTRAINT [DF_tTransactionUnpost_Credit]  DEFAULT ((0)) FOR [Credit]
GO
ALTER TABLE [dbo].[tTransactionUnpost] ADD  CONSTRAINT [DF_tTransactionUnpost_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
