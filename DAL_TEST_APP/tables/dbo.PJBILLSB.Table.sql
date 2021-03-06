USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJBILLSB]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBILLSB](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[customer] [char](15) NOT NULL,
	[cust_percent] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[project] [char](16) NOT NULL,
	[sb_comment] [char](30) NOT NULL,
	[sb_id01] [char](30) NOT NULL,
	[sb_id02] [char](30) NOT NULL,
	[sb_id03] [char](20) NOT NULL,
	[sb_id04] [char](20) NOT NULL,
	[sb_id05] [char](10) NOT NULL,
	[sb_id06] [char](10) NOT NULL,
	[sb_id07] [char](4) NOT NULL,
	[sb_id08] [float] NOT NULL,
	[sb_id09] [smalldatetime] NOT NULL,
	[sb_id10] [int] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbillsb0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[customer] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
