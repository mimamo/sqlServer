USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTransaction]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTransaction](
	[TransactionKey] [int] IDENTITY(1,1) NOT NULL,
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
	[Reversed] [tinyint] NOT NULL,
	[PostSide] [char](1) NULL,
	[ClientKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[SourceCompanyKey] [int] NULL,
	[Cleared] [tinyint] NOT NULL,
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
	[HCredit] [money] NULL,
 CONSTRAINT [PK_tTransaction] PRIMARY KEY NONCLUSTERED 
(
	[TransactionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_tTransaction_tGLAccount] FOREIGN KEY([GLAccountKey])
REFERENCES [dbo].[tGLAccount] ([GLAccountKey])
GO
ALTER TABLE [dbo].[tTransaction] CHECK CONSTRAINT [FK_tTransaction_tGLAccount]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_Debit]  DEFAULT ((0)) FOR [Debit]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_Credit]  DEFAULT ((0)) FOR [Credit]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_Reversed]  DEFAULT ((0)) FOR [Reversed]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_Cleared]  DEFAULT ((0)) FOR [Cleared]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_Overhead]  DEFAULT ((0)) FOR [Overhead]
GO
ALTER TABLE [dbo].[tTransaction] ADD  CONSTRAINT [DF_tTransaction_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
