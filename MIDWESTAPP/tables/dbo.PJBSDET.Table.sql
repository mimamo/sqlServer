USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PJBSDET]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJBSDET](
	[acct] [char](16) NOT NULL,
	[amount] [float] NOT NULL,
	[bd_id01] [char](30) NOT NULL,
	[bd_id02] [char](30) NOT NULL,
	[bd_id03] [char](16) NOT NULL,
	[bd_id04] [char](16) NOT NULL,
	[bd_id05] [char](4) NOT NULL,
	[bd_id06] [float] NOT NULL,
	[bd_id07] [float] NOT NULL,
	[bd_id08] [smalldatetime] NOT NULL,
	[bd_id09] [smalldatetime] NOT NULL,
	[bd_id10] [smallint] NOT NULL,
	[bd_id11] [char](30) NOT NULL,
	[bd_id12] [char](30) NOT NULL,
	[bd_id13] [char](30) NOT NULL,
	[bd_id14] [char](20) NOT NULL,
	[bd_id15] [char](10) NOT NULL,
	[bd_id16] [char](10) NOT NULL,
	[bd_id17] [char](10) NOT NULL,
	[bd_id18] [char](4) NOT NULL,
	[bd_id19] [float] NOT NULL,
	[bd_id20] [smalldatetime] NOT NULL,
	[comment] [char](250) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[draft_num] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[fee_rate] [float] NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[li_type] [char](1) NOT NULL,
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
	[project_line] [char](16) NOT NULL,
	[rate_type_cd] [char](2) NOT NULL,
	[rel_status] [char](1) NOT NULL,
	[schednbr] [char](6) NOT NULL,
	[taxid] [char](10) NOT NULL,
	[units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[vendor_num] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjbsdet0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[schednbr] ASC,
	[linenbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
