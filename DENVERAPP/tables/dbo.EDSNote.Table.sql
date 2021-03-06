USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[EDSNote]    Script Date: 12/21/2015 15:42:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDSNote](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[dtRevisedDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[nID] [int] NOT NULL,
	[sLevelName] [char](20) NOT NULL,
	[sNoteText] [text] NOT NULL,
	[sTableName] [char](20) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
