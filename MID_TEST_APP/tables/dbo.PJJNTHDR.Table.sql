USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJJNTHDR]    Script Date: 12/21/2015 14:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJJNTHDR](
	[check_name] [char](80) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[jh_id01] [char](30) NOT NULL,
	[jh_id02] [char](16) NOT NULL,
	[jh_id03] [char](4) NOT NULL,
	[jh_id04] [float] NOT NULL,
	[jh_id05] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[project] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[vendid] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjjnthdr0] PRIMARY KEY CLUSTERED 
(
	[vendid] ASC,
	[project] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
