USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJSUBCON]    Script Date: 12/21/2015 14:26:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJSUBCON](
	[BaseCuryId] [char](4) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[date_comp_ant] [smalldatetime] NOT NULL,
	[date_comp_act] [smalldatetime] NOT NULL,
	[date_cont_exe] [smalldatetime] NOT NULL,
	[date_start_act] [smalldatetime] NOT NULL,
	[date_start_ant] [smalldatetime] NOT NULL,
	[date_start_auth] [smalldatetime] NOT NULL,
	[date_start_org] [smalldatetime] NOT NULL,
	[date_end_org] [smalldatetime] NOT NULL,
	[date_end_rev] [smalldatetime] NOT NULL,
	[extension_days] [smallint] NOT NULL,
	[last_change_order] [char](16) NOT NULL,
	[last_payreqnbr] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[project] [char](16) NOT NULL,
	[status_sub] [char](1) NOT NULL,
	[status_pay] [char](1) NOT NULL,
	[status_reason] [char](30) NOT NULL,
	[su_id01] [char](30) NOT NULL,
	[su_id02] [char](30) NOT NULL,
	[su_id03] [char](16) NOT NULL,
	[su_id04] [char](16) NOT NULL,
	[su_id05] [char](4) NOT NULL,
	[su_id06] [float] NOT NULL,
	[su_id07] [float] NOT NULL,
	[su_id08] [smalldatetime] NOT NULL,
	[su_id09] [smalldatetime] NOT NULL,
	[su_id10] [int] NOT NULL,
	[su_id11] [char](255) NOT NULL,
	[su_id12] [char](255) NOT NULL,
	[su_id13] [char](255) NOT NULL,
	[su_id14] [char](16) NOT NULL,
	[su_id15] [char](4) NOT NULL,
	[su_id16] [float] NOT NULL,
	[su_id17] [float] NOT NULL,
	[su_id18] [smalldatetime] NOT NULL,
	[su_id19] [smalldatetime] NOT NULL,
	[su_id20] [int] NOT NULL,
	[specialty_cd] [char](4) NOT NULL,
	[subcontract] [char](16) NOT NULL,
	[subcontract_desc] [char](60) NOT NULL,
	[sub_type_cd] [char](4) NOT NULL,
	[termsid] [char](2) NOT NULL,
	[text_sub1] [char](254) NOT NULL,
	[text_sub2] [char](254) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[user5] [char](30) NOT NULL,
	[user6] [char](30) NOT NULL,
	[user7] [float] NOT NULL,
	[user8] [float] NOT NULL,
	[vendid] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjsubcon0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[subcontract] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
