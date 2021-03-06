USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PJLABDIS_BU_10022009]    Script Date: 12/21/2015 14:33:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJLABDIS_BU_10022009](
	[acct] [char](16) NOT NULL,
	[amount] [float] NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[CpnyId_chrg] [char](10) NOT NULL,
	[CpnyId_home] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTranamt] [float] NOT NULL,
	[Curystdcost] [float] NOT NULL,
	[dl_id01] [char](30) NOT NULL,
	[dl_id02] [char](30) NOT NULL,
	[dl_id03] [char](16) NOT NULL,
	[dl_id04] [char](16) NOT NULL,
	[dl_id05] [char](4) NOT NULL,
	[dl_id06] [float] NOT NULL,
	[dl_id07] [float] NOT NULL,
	[dl_id08] [smalldatetime] NOT NULL,
	[dl_id09] [smalldatetime] NOT NULL,
	[dl_id10] [int] NOT NULL,
	[dl_id11] [char](30) NOT NULL,
	[dl_id12] [char](30) NOT NULL,
	[dl_id13] [char](20) NOT NULL,
	[dl_id14] [char](20) NOT NULL,
	[dl_id15] [char](10) NOT NULL,
	[dl_id16] [char](10) NOT NULL,
	[dl_id17] [char](4) NOT NULL,
	[dl_id18] [float] NOT NULL,
	[dl_id19] [float] NOT NULL,
	[dl_id20] [smalldatetime] NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[earn_type_id] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[gl_acct] [char](10) NOT NULL,
	[gl_subacct] [char](24) NOT NULL,
	[home_subacct] [char](24) NOT NULL,
	[hrs_type] [char](4) NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[labor_stdcost] [float] NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[pe_date] [smalldatetime] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[premium_hrs] [float] NOT NULL,
	[project] [char](16) NOT NULL,
	[rate_source] [char](1) NOT NULL,
	[shift] [char](7) NOT NULL,
	[status_1] [char](2) NOT NULL,
	[status_2] [char](2) NOT NULL,
	[status_gl] [char](2) NOT NULL,
	[union_cd] [char](10) NOT NULL,
	[work_comp_cd] [char](6) NOT NULL,
	[work_type] [char](2) NOT NULL,
	[worked_hrs] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
