USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSSignatures_AlterTable]    Script Date: 12/21/2015 13:44:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSSignatures_AlterTable](
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[InvtId] [char](30) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[SigDate] [smalldatetime] NOT NULL,
	[SigId] [char](30) NOT NULL,
	[SigPicture] [image] NOT NULL,
	[SigString] [text] NOT NULL,
	[SigType] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [InvtId]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [SigDate]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [SigId]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT (0x00) FOR [SigPicture]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [SigString]
GO
ALTER TABLE [dbo].[PSSSignatures_AlterTable] ADD  DEFAULT ('') FOR [SigType]
GO
