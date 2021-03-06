USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJPOOLS]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPOOLS](
	[amount_ptd] [float] NOT NULL,
	[amount_ytd] [float] NOT NULL,
	[cpnyid] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[grpid] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[period] [char](6) NOT NULL,
	[ps_id01] [char](30) NOT NULL,
	[ps_id02] [char](16) NOT NULL,
	[ps_id03] [float] NOT NULL,
	[ps_id04] [float] NOT NULL,
	[ps_id05] [smalldatetime] NOT NULL,
	[ps_id06] [int] NOT NULL,
	[recnbr] [int] IDENTITY(1,1) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpools0] PRIMARY KEY CLUSTERED 
(
	[grpid] ASC,
	[period] ASC,
	[recnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
