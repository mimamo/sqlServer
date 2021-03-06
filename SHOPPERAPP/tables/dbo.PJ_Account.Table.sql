USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJ_Account]    Script Date: 12/21/2015 16:12:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJ_Account](
	[acct] [char](16) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[employ_sw] [char](1) NOT NULL,
	[ga_id01] [char](1) NOT NULL,
	[ga_id02] [char](1) NOT NULL,
	[ga_id03] [char](1) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[units_sw] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pj_account0] PRIMARY KEY CLUSTERED 
(
	[gl_acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
