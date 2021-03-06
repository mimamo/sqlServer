USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJWAGEPR]    Script Date: 12/21/2015 13:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJWAGEPR](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[group_code] [char](2) NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[labor_rate] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[prev_wage_cd] [char](4) NOT NULL,
	[pw_id01] [char](30) NOT NULL,
	[pw_id02] [char](30) NOT NULL,
	[pw_id03] [char](16) NOT NULL,
	[pw_id04] [char](16) NOT NULL,
	[pw_id05] [char](4) NOT NULL,
	[pw_id06] [float] NOT NULL,
	[pw_id07] [float] NOT NULL,
	[pw_id08] [smalldatetime] NOT NULL,
	[pw_id09] [smalldatetime] NOT NULL,
	[pw_id10] [int] NOT NULL,
	[pw_id11] [char](30) NOT NULL,
	[pw_id12] [char](30) NOT NULL,
	[pw_id13] [char](16) NOT NULL,
	[pw_id14] [char](16) NOT NULL,
	[pw_id15] [char](4) NOT NULL,
	[pw_id16] [float] NOT NULL,
	[pw_id17] [float] NOT NULL,
	[pw_id18] [smalldatetime] NOT NULL,
	[pw_id19] [smalldatetime] NOT NULL,
	[pw_id20] [int] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjwagepr0] PRIMARY KEY CLUSTERED 
(
	[prev_wage_cd] ASC,
	[labor_class_cd] ASC,
	[group_code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
