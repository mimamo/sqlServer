USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSFind_AlterTable]    Script Date: 12/21/2015 16:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFind_AlterTable](
	[BackColor] [int] NOT NULL,
	[CAS] [smallint] NOT NULL,
	[CCheck] [char](20) NOT NULL,
	[CCombo] [char](20) NOT NULL,
	[CDate] [char](20) NOT NULL,
	[CFloat] [char](20) NOT NULL,
	[CInteger] [char](20) NOT NULL,
	[COption] [char](20) NOT NULL,
	[CString] [char](20) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[KeyAscii] [smallint] NOT NULL,
	[KeyLabel] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ((0)) FOR [BackColor]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ((0)) FOR [CAS]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [CCheck]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [CCombo]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [CDate]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [CFloat]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [CInteger]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [COption]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [CString]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ((0)) FOR [KeyAscii]
GO
ALTER TABLE [dbo].[PSSFind_AlterTable] ADD  DEFAULT ('') FOR [KeyLabel]
GO
