USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSFABonusHdr_AlterTable]    Script Date: 12/21/2015 16:12:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFABonusHdr_AlterTable](
	[BonusDeprCd] [char](10) NOT NULL,
	[BonusDeprDesc] [char](60) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[State] [char](3) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [BonusDeprCd]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [BonusDeprDesc]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSFABonusHdr_AlterTable] ADD  DEFAULT ('') FOR [State]
GO
