USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJLABHDR]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJLABHDR](
	[Approver] [char](10) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[CpnyId_home] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[docnbr] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[le_id01] [char](30) NOT NULL,
	[le_id02] [char](30) NOT NULL,
	[le_id03] [char](16) NOT NULL,
	[le_id04] [char](16) NOT NULL,
	[le_id05] [char](4) NOT NULL,
	[le_id06] [float] NOT NULL,
	[le_id07] [float] NOT NULL,
	[le_id08] [smalldatetime] NOT NULL,
	[le_id09] [smalldatetime] NOT NULL,
	[le_id10] [int] NOT NULL,
	[le_key] [char](30) NOT NULL,
	[le_status] [char](1) NOT NULL,
	[le_type] [char](2) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[period_num] [char](6) NOT NULL,
	[pe_date] [smalldatetime] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[week_num] [char](2) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjlabhdr0] PRIMARY KEY CLUSTERED 
(
	[docnbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
