USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSFileAttachObj_AlterTable]    Script Date: 12/21/2015 14:10:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFileAttachObj_AlterTable](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[KeyField] [char](100) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[TableName] [char](30) NOT NULL,
	[URL] [char](255) NOT NULL,
	[URLImage] [image] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [KeyField]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [TableName]
GO
ALTER TABLE [dbo].[PSSFileAttachObj_AlterTable] ADD  DEFAULT ('') FOR [URL]
GO
