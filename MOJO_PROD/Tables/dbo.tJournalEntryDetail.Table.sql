USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tJournalEntryDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tJournalEntryDetail](
	[JournalEntryDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[JournalEntryKey] [int] NOT NULL,
	[GLAccountKey] [int] NOT NULL,
	[ClientKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[ClassKey] [int] NULL,
	[Memo] [varchar](500) NULL,
	[DebitAmount] [money] NOT NULL,
	[CreditAmount] [money] NOT NULL,
	[AllocateBatchKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [nvarchar](50) NULL,
	[TargetGLCompanyKey] [int] NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
 CONSTRAINT [PK_tJournalEntryDetail] PRIMARY KEY CLUSTERED 
(
	[JournalEntryDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tJournalEntryDetail] ADD  CONSTRAINT [DF_tJournalEntryDetail_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
