USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJTEXT]    Script Date: 12/21/2015 13:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTEXT](
	[category_cd] [char](2) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[flag1] [char](1) NOT NULL,
	[flag2] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[msg_num] [char](4) NOT NULL,
	[msg_text] [char](255) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtext0] PRIMARY KEY CLUSTERED 
(
	[msg_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
