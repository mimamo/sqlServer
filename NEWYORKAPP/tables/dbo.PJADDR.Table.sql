USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PJADDR]    Script Date: 12/21/2015 16:00:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJADDR](
	[ad_id01] [char](30) NOT NULL,
	[ad_id02] [char](30) NOT NULL,
	[ad_id03] [char](16) NOT NULL,
	[ad_id04] [char](16) NOT NULL,
	[ad_id05] [char](4) NOT NULL,
	[ad_id06] [char](4) NOT NULL,
	[ad_id07] [float] NOT NULL,
	[ad_id08] [smalldatetime] NOT NULL,
	[addr_key] [char](48) NOT NULL,
	[addr_key_cd] [char](2) NOT NULL,
	[addr_type_cd] [char](2) NOT NULL,
	[addr1] [char](60) NOT NULL,
	[addr2] [char](60) NOT NULL,
	[city] [char](30) NOT NULL,
	[comp_name] [char](60) NOT NULL,
	[country] [char](3) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[email] [char](80) NOT NULL,
	[fax] [char](15) NOT NULL,
	[individual] [char](30) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[phone] [char](15) NOT NULL,
	[state] [char](3) NOT NULL,
	[title] [char](30) NOT NULL,
	[zip] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjaddr0] PRIMARY KEY CLUSTERED 
(
	[addr_key_cd] ASC,
	[addr_key] ASC,
	[addr_type_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
