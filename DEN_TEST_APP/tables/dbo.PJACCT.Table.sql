USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PJACCT]    Script Date: 12/21/2015 14:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJACCT](
	[acct] [char](16) NOT NULL,
	[acct_desc] [char](30) NOT NULL,
	[acct_group_cd] [char](2) NOT NULL,
	[acct_status] [char](1) NOT NULL,
	[acct_type] [char](2) NOT NULL,
	[ca_id01] [char](30) NOT NULL,
	[ca_id02] [char](30) NOT NULL,
	[ca_id03] [char](16) NOT NULL,
	[ca_id04] [char](16) NOT NULL,
	[ca_id05] [char](4) NOT NULL,
	[ca_id06] [float] NOT NULL,
	[ca_id07] [float] NOT NULL,
	[ca_id08] [smalldatetime] NOT NULL,
	[ca_id09] [smalldatetime] NOT NULL,
	[ca_id10] [int] NOT NULL,
	[ca_id16] [char](30) NOT NULL,
	[ca_id17] [char](16) NOT NULL,
	[ca_id18] [char](4) NOT NULL,
	[ca_id19] [char](1) NOT NULL,
	[ca_id20] [char](1) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[id1_sw] [char](1) NOT NULL,
	[id2_sw] [char](1) NOT NULL,
	[id3_sw] [char](1) NOT NULL,
	[id4_sw] [char](1) NOT NULL,
	[id5_sw] [char](1) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[sort_num] [smallint] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjacct0] PRIMARY KEY CLUSTERED 
(
	[acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
