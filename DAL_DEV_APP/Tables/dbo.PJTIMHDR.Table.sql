USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJTIMHDR]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTIMHDR](
	[approver] [char](10) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[cpnyId] [char](10) NOT NULL,
	[crew_cd] [char](7) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[end_time] [char](4) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[multi_emp_sw] [char](1) NOT NULL,
	[noteid] [int] NOT NULL,
	[percent_comp] [float] NOT NULL,
	[preparer_id] [char](10) NOT NULL,
	[project] [char](16) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[shift] [char](7) NOT NULL,
	[start_time] [char](4) NOT NULL,
	[th_comment] [char](30) NOT NULL,
	[th_date] [smalldatetime] NOT NULL,
	[th_key] [char](30) NOT NULL,
	[th_id01] [char](30) NOT NULL,
	[th_id02] [char](30) NOT NULL,
	[th_id03] [char](20) NOT NULL,
	[th_id04] [char](20) NOT NULL,
	[th_id05] [char](10) NOT NULL,
	[th_id06] [char](10) NOT NULL,
	[th_id07] [char](4) NOT NULL,
	[th_id08] [float] NOT NULL,
	[th_id09] [smalldatetime] NOT NULL,
	[th_id10] [int] NOT NULL,
	[th_id11] [char](30) NOT NULL,
	[th_id12] [char](30) NOT NULL,
	[th_id13] [char](20) NOT NULL,
	[th_id14] [char](20) NOT NULL,
	[th_id15] [char](10) NOT NULL,
	[th_id16] [char](10) NOT NULL,
	[th_id17] [char](4) NOT NULL,
	[th_id18] [float] NOT NULL,
	[th_id19] [smalldatetime] NOT NULL,
	[th_id20] [int] NOT NULL,
	[th_status] [char](1) NOT NULL,
	[th_type] [char](2) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtimhdr0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
