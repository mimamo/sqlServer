USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJEMPPJT]    Script Date: 12/21/2015 14:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEMPPJT](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[ep_id01] [char](30) NOT NULL,
	[ep_id02] [char](30) NOT NULL,
	[ep_id03] [char](16) NOT NULL,
	[ep_id04] [char](16) NOT NULL,
	[ep_id05] [char](4) NOT NULL,
	[ep_id06] [float] NOT NULL,
	[ep_id07] [float] NOT NULL,
	[ep_id08] [smalldatetime] NOT NULL,
	[ep_id09] [smalldatetime] NOT NULL,
	[ep_id10] [int] NOT NULL,
	[effect_date] [smalldatetime] NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[labor_rate] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjemppjt0] PRIMARY KEY CLUSTERED 
(
	[employee] ASC,
	[project] ASC,
	[effect_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
