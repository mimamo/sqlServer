USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJSECURE]    Script Date: 12/21/2015 13:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJSECURE](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[key_value] [char](64) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[password] [char](255) NOT NULL,
	[pw_type_cd] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjsecure0] PRIMARY KEY CLUSTERED 
(
	[pw_type_cd] ASC,
	[key_value] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
