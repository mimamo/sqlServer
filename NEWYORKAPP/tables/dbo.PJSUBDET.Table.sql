USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PJSUBDET]    Script Date: 12/21/2015 16:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJSUBDET](
	[acct] [char](16) NOT NULL,
	[co_pend_amt] [float] NOT NULL,
	[co_pend_units] [float] NOT NULL,
	[cpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[Curyco_pend_amt] [float] NOT NULL,
	[Curyoriginal_amt] [float] NOT NULL,
	[Curyprior_req_amt] [float] NOT NULL,
	[Curyrevised_amt] [float] NOT NULL,
	[Curyvouch_amt] [float] NOT NULL,
	[date_promised] [smalldatetime] NOT NULL,
	[date_required] [smalldatetime] NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[line_desc] [char](30) NOT NULL,
	[noteid] [int] NOT NULL,
	[original_amt] [float] NOT NULL,
	[original_units] [float] NOT NULL,
	[prior_request_amt] [float] NOT NULL,
	[project] [char](16) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[retention_method] [char](2) NOT NULL,
	[retention_percent] [float] NOT NULL,
	[revised_amt] [float] NOT NULL,
	[revised_rate] [float] NOT NULL,
	[revised_units] [float] NOT NULL,
	[sd_id01] [char](30) NOT NULL,
	[sd_id02] [char](30) NOT NULL,
	[sd_id03] [char](16) NOT NULL,
	[sd_id04] [char](16) NOT NULL,
	[sd_id05] [char](4) NOT NULL,
	[sd_id06] [float] NOT NULL,
	[sd_id07] [float] NOT NULL,
	[sd_id08] [smalldatetime] NOT NULL,
	[sd_id09] [smalldatetime] NOT NULL,
	[sd_id10] [int] NOT NULL,
	[sd_id11] [char](30) NOT NULL,
	[sd_id12] [char](30) NOT NULL,
	[sd_id13] [char](16) NOT NULL,
	[sd_id14] [char](16) NOT NULL,
	[sd_id15] [char](4) NOT NULL,
	[sd_id16] [float] NOT NULL,
	[sd_id17] [float] NOT NULL,
	[sd_id18] [smalldatetime] NOT NULL,
	[sd_id19] [smalldatetime] NOT NULL,
	[sd_id20] [int] NOT NULL,
	[status1] [char](1) NOT NULL,
	[status2] [char](1) NOT NULL,
	[sub_line_item] [char](4) NOT NULL,
	[subcontract] [char](16) NOT NULL,
	[unit_of_measure] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[vouch_amt] [float] NOT NULL,
	[vouch_units] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjsubdet0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[subcontract] ASC,
	[sub_line_item] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
