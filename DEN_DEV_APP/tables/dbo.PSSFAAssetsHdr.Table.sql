USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFAAssetsHdr]    Script Date: 12/21/2015 14:05:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAssetsHdr](
	[AllSubsInBuild] [char](1) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[Closed] [smallint] NOT NULL,
	[CpnyAssetNo] [char](30) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[LastAssetSubId] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[TotValue] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [AllSubsInBuild]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ((0)) FOR [Closed]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [CpnyAssetNo]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [LastAssetSubId]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ((0.00)) FOR [TotValue]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFAAssetsHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
