USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSFAMissing_AlterTable]    Script Date: 12/21/2015 16:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAMissing_AlterTable](
	[AssetDescr] [char](50) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrLocId] [char](24) NOT NULL,
	[Dept] [char](24) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MissingId] [char](40) NOT NULL,
	[ScanDate] [smalldatetime] NOT NULL,
	[ScanUser] [char](20) NOT NULL,
	[SerialNo] [char](20) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [CurrLocId]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [MissingId]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [ScanDate]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [ScanUser]
GO
ALTER TABLE [dbo].[PSSFAMissing_AlterTable] ADD  DEFAULT ('') FOR [SerialNo]
GO
