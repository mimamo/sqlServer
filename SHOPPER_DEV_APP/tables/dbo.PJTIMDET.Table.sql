USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PJTIMDET]    Script Date: 12/21/2015 14:33:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTIMDET](
	[cert_pay_sw] [char](1) NOT NULL,
	[CpnyId_chrg] [char](10) NOT NULL,
	[CpnyId_eq_home] [char](10) NOT NULL,
	[CpnyId_home] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[earn_type_id] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[elapsed_time] [char](4) NOT NULL,
	[end_time] [char](4) NOT NULL,
	[equip_amt] [float] NOT NULL,
	[equip_home_subacct] [char](24) NOT NULL,
	[equip_id] [char](10) NOT NULL,
	[equip_rate] [float] NOT NULL,
	[equip_rate_cd] [char](5) NOT NULL,
	[equip_rate_indicator] [char](1) NOT NULL,
	[equip_units] [float] NOT NULL,
	[equip_uom] [char](6) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[group_code] [char](2) NOT NULL,
	[labor_amt] [float] NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[labor_rate] [float] NOT NULL,
	[labor_rate_indicator] [char](1) NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[ot1_hours] [float] NOT NULL,
	[ot2_hours] [float] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[reg_hours] [float] NOT NULL,
	[shift] [char](7) NOT NULL,
	[start_time] [char](4) NOT NULL,
	[tl_date] [smalldatetime] NOT NULL,
	[tl_id01] [char](30) NOT NULL,
	[tl_id02] [char](30) NOT NULL,
	[tl_id03] [char](20) NOT NULL,
	[tl_id04] [char](20) NOT NULL,
	[tl_id05] [char](10) NOT NULL,
	[tl_id06] [char](10) NOT NULL,
	[tl_id07] [char](4) NOT NULL,
	[tl_id08] [float] NOT NULL,
	[tl_id09] [smalldatetime] NOT NULL,
	[tl_id10] [int] NOT NULL,
	[tl_id11] [char](30) NOT NULL,
	[tl_id12] [char](30) NOT NULL,
	[tl_id13] [char](20) NOT NULL,
	[tl_id14] [char](20) NOT NULL,
	[tl_id15] [char](10) NOT NULL,
	[tl_id16] [char](10) NOT NULL,
	[tl_id17] [char](4) NOT NULL,
	[tl_id18] [float] NOT NULL,
	[tl_id19] [smalldatetime] NOT NULL,
	[tl_id20] [int] NOT NULL,
	[tl_status] [char](1) NOT NULL,
	[union_cd] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[work_comp_cd] [char](6) NOT NULL,
	[work_type] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtimdet0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC,
	[linenbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
