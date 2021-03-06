USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSFATransfers_AlterTable]    Script Date: 12/21/2015 16:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATransfers_AlterTable](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[GLCpnyId] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NewAssetId] [char](10) NOT NULL,
	[NewAssetSubId] [char](10) NOT NULL,
	[NewCpnyId] [char](10) NOT NULL,
	[NewFABatNbr] [char](10) NOT NULL,
	[OldAssetId] [char](10) NOT NULL,
	[OldAssetSubId] [char](10) NOT NULL,
	[OldCpnyId] [char](10) NOT NULL,
	[OldFABatNbr] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
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
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [GLCpnyId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [NewAssetId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [NewAssetSubId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [NewCpnyId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [NewFABatNbr]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [OldAssetId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [OldAssetSubId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [OldCpnyId]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [OldFABatNbr]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFATransfers_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
