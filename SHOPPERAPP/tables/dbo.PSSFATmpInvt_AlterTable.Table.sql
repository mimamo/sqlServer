USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSFATmpInvt_AlterTable]    Script Date: 12/21/2015 16:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATmpInvt_AlterTable](
	[AssetDescr] [char](30) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BatId] [char](10) NOT NULL,
	[CountLocId] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateAcquire] [smalldatetime] NOT NULL,
	[DateCancel] [smalldatetime] NOT NULL,
	[EmpId] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[SerialNum] [char](20) NOT NULL,
	[SysLocId] [char](24) NOT NULL,
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
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [BatId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [CountLocId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [DateAcquire]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [DateCancel]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [EmpId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [SerialNum]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [SysLocId]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFATmpInvt_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
