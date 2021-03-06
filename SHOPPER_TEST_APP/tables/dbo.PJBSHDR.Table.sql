USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PJBSHDR]    Script Date: 12/21/2015 16:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBSHDR](
	[acct] [char](16) NOT NULL,
	[approval_sw] [char](1) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[draft_flag] [char](1) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[hb_id01] [char](30) NOT NULL,
	[hb_id02] [char](30) NOT NULL,
	[hb_id03] [char](20) NOT NULL,
	[hb_id04] [char](20) NOT NULL,
	[hb_id05] [char](10) NOT NULL,
	[hb_id06] [char](10) NOT NULL,
	[hb_id07] [char](4) NOT NULL,
	[hb_id08] [float] NOT NULL,
	[hb_id09] [smalldatetime] NOT NULL,
	[hb_id10] [int] NOT NULL,
	[hb_id11] [char](30) NOT NULL,
	[hb_id12] [char](30) NOT NULL,
	[hb_id13] [char](20) NOT NULL,
	[hb_id14] [char](20) NOT NULL,
	[hb_id15] [char](10) NOT NULL,
	[hb_id16] [char](10) NOT NULL,
	[hb_id17] [char](4) NOT NULL,
	[hb_id18] [float] NOT NULL,
	[hb_id19] [smalldatetime] NOT NULL,
	[hb_id20] [int] NOT NULL,
	[inv_format_cd] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[schednbr] [char](6) NOT NULL,
	[sched_desc] [char](40) NOT NULL,
	[sched_type] [char](1) NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[total_amount] [float] NOT NULL,
	[total_units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbshdr0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[schednbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
