USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSFABuildDet]    Script Date: 12/21/2015 14:26:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFABuildDet](
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BuildNbr] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[OldCustodian] [char](20) NOT NULL,
	[OldLocId] [char](24) NOT NULL,
	[OldProjectId] [char](30) NOT NULL,
	[OldTaskId] [char](32) NOT NULL,
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
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [BuildNbr]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [OldCustodian]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [OldLocId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [OldProjectId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [OldTaskId]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFABuildDet] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
