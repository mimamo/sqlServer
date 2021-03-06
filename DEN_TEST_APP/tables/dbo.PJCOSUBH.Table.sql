USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PJCOSUBH]    Script Date: 12/21/2015 14:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCOSUBH](
	[approved_by] [char](20) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[change_order_num] [char](16) NOT NULL,
	[co_desc] [char](60) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[date_apprv] [smalldatetime] NOT NULL,
	[date_co] [smalldatetime] NOT NULL,
	[impact_days] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[pjt_change_order] [char](16) NOT NULL,
	[project] [char](16) NOT NULL,
	[reqd_by] [char](20) NOT NULL,
	[reqd_reason] [char](30) NOT NULL,
	[sc_id01] [char](30) NOT NULL,
	[sc_id02] [char](30) NOT NULL,
	[sc_id03] [char](16) NOT NULL,
	[sc_id04] [char](16) NOT NULL,
	[sc_id05] [char](4) NOT NULL,
	[sc_id06] [float] NOT NULL,
	[sc_id07] [float] NOT NULL,
	[sc_id08] [smalldatetime] NOT NULL,
	[sc_id09] [smalldatetime] NOT NULL,
	[sc_id10] [int] NOT NULL,
	[sc_id11] [char](30) NOT NULL,
	[sc_id12] [char](30) NOT NULL,
	[sc_id13] [char](16) NOT NULL,
	[sc_id14] [char](16) NOT NULL,
	[sc_id15] [char](4) NOT NULL,
	[sc_id16] [float] NOT NULL,
	[sc_id17] [float] NOT NULL,
	[sc_id18] [smalldatetime] NOT NULL,
	[sc_id19] [smalldatetime] NOT NULL,
	[sc_id20] [int] NOT NULL,
	[status1] [char](1) NOT NULL,
	[status2] [char](1) NOT NULL,
	[subco_cat_cd] [char](4) NOT NULL,
	[subcontract] [char](16) NOT NULL,
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
	[vendor_ref] [char](16) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjcosubh0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[subcontract] ASC,
	[change_order_num] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
