USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJBSREV]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBSREV](
	[amount] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_comment] [char](30) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[percent_detail] [float] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[post_date] [smalldatetime] NOT NULL,
	[post_date_est] [smalldatetime] NOT NULL,
	[post_period] [char](6) NOT NULL,
	[project] [char](16) NOT NULL,
	[rel_status] [char](1) NOT NULL,
	[rd_id01] [char](30) NOT NULL,
	[rd_id02] [char](30) NOT NULL,
	[rd_id03] [char](20) NOT NULL,
	[rd_id04] [char](20) NOT NULL,
	[rd_id05] [char](10) NOT NULL,
	[rd_id06] [char](10) NOT NULL,
	[rd_id07] [char](4) NOT NULL,
	[rd_id08] [float] NOT NULL,
	[rd_id09] [smalldatetime] NOT NULL,
	[rd_id10] [int] NOT NULL,
	[rd_id11] [char](30) NOT NULL,
	[rd_id12] [char](30) NOT NULL,
	[rd_id13] [char](20) NOT NULL,
	[rd_id14] [char](20) NOT NULL,
	[rd_id15] [char](10) NOT NULL,
	[rd_id16] [char](10) NOT NULL,
	[rd_id17] [char](4) NOT NULL,
	[rd_id18] [float] NOT NULL,
	[rd_id19] [smalldatetime] NOT NULL,
	[rd_id20] [int] NOT NULL,
	[schednbr] [char](6) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbsrev0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[schednbr] ASC,
	[linenbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
