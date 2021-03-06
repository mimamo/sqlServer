USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tJournalEntry]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tJournalEntry](
	[JournalEntryKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[EntryDate] [smalldatetime] NOT NULL,
	[PostingDate] [smalldatetime] NOT NULL,
	[RecurringParentKey] [int] NOT NULL,
	[EnteredBy] [int] NOT NULL,
	[JournalNumber] [varchar](50) NOT NULL,
	[Posted] [tinyint] NOT NULL,
	[Description] [varchar](1000) NULL,
	[AutoReverse] [tinyint] NULL,
	[ReversingEntry] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[ExcludeCashBasis] [tinyint] NULL,
	[ExcludeAccrualBasis] [tinyint] NULL,
	[GLAccountRecKey] [int] NULL,
	[IntercompanyAccountSource] [tinyint] NULL,
	[CreatedDate] [smalldatetime] NULL,
	[PostedByKey] [int] NULL,
	[PostCreatedDate] [smalldatetime] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
 CONSTRAINT [PK_tJournalEntry] PRIMARY KEY CLUSTERED 
(
	[JournalEntryKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tJournalEntry] ADD  CONSTRAINT [DF_tJournalEntry_RecurringParentKey]  DEFAULT ((0)) FOR [RecurringParentKey]
GO
ALTER TABLE [dbo].[tJournalEntry] ADD  CONSTRAINT [DF_tJournalEntry_Posted]  DEFAULT ((0)) FOR [Posted]
GO
ALTER TABLE [dbo].[tJournalEntry] ADD  CONSTRAINT [DF_tJournalEntry_IncludeCashBasis]  DEFAULT ((0)) FOR [ExcludeCashBasis]
GO
ALTER TABLE [dbo].[tJournalEntry] ADD  CONSTRAINT [DF_tJournalEntry_ExcludeAccrualBasis]  DEFAULT ((0)) FOR [ExcludeAccrualBasis]
GO
ALTER TABLE [dbo].[tJournalEntry] ADD  CONSTRAINT [DF_tJournalEntry_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
