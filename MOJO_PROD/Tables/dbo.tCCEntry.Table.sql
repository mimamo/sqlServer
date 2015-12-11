USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCCEntry]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCCEntry](
	[CCEntryKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[ItemKey] [int] NULL,
	[VoucherKey] [int] NULL,
	[TaskKey] [int] NULL,
	[Amount] [money] NULL,
	[TransactionDate] [smalldatetime] NULL,
	[FITID] [varchar](100) NULL,
	[REFNUM] [varchar](100) NULL,
	[PayeeName] [varchar](100) NULL,
	[Memo] [varchar](2000) NULL,
	[FID] [varchar](100) NULL,
	[TransactionPostedDate] [smalldatetime] NULL,
	[TransactionAccountID] [varchar](100) NULL,
	[TransactionType] [varchar](50) NULL,
	[GLAccountKey] [int] NULL,
	[ChargedByKey] [int] NULL,
	[VendorKey] [int] NULL,
	[CCVoucherKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[ExpenseAccountKey] [int] NULL,
	[Overhead] [tinyint] NULL,
	[ClassKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax2Amount] [money] NULL,
	[SplitProjects] [tinyint] NULL,
	[SplitVouchers] [tinyint] NULL,
	[Billable] [tinyint] NULL,
	[Receipt] [tinyint] NULL,
	[OriginalMemo] [varchar](2000) NULL,
 CONSTRAINT [PK_tCCEntry] PRIMARY KEY CLUSTERED 
(
	[CCEntryKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCCEntry] ADD  CONSTRAINT [DF_tCCEntry_Overhead]  DEFAULT ((0)) FOR [Overhead]
GO
ALTER TABLE [dbo].[tCCEntry] ADD  CONSTRAINT [DF_tCCEntry_SplitProjects]  DEFAULT ((0)) FOR [SplitProjects]
GO
ALTER TABLE [dbo].[tCCEntry] ADD  CONSTRAINT [DF_tCCEntry_SplitVouchers]  DEFAULT ((0)) FOR [SplitVouchers]
GO
ALTER TABLE [dbo].[tCCEntry] ADD  CONSTRAINT [DF_tCCEntry_Billable]  DEFAULT ((0)) FOR [Billable]
GO
