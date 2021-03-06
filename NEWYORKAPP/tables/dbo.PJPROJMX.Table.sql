USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PJPROJMX]    Script Date: 12/21/2015 16:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPROJMX](
	[acct] [char](16) NOT NULL,
	[acct_billing] [char](16) NOT NULL,
	[acct_overmax] [char](16) NOT NULL,
	[acct_overmax_offset] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[gl_acct_overmax] [char](10) NOT NULL,
	[gl_acct_offset] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[Max_amount] [float] NOT NULL,
	[Max_units] [float] NOT NULL,
	[mx_id01] [char](30) NOT NULL,
	[mx_id02] [char](30) NOT NULL,
	[mx_id03] [char](16) NOT NULL,
	[mx_id04] [char](16) NOT NULL,
	[mx_id05] [char](4) NOT NULL,
	[mx_id06] [float] NOT NULL,
	[mx_id07] [float] NOT NULL,
	[mx_id08] [smalldatetime] NOT NULL,
	[mx_id09] [smalldatetime] NOT NULL,
	[mx_id10] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjprojmx0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[pjt_entity] ASC,
	[acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
