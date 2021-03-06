USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJRESSUM]    Script Date: 12/21/2015 13:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRESSUM](
	[acct] [char](16) NOT NULL,
	[act_amount] [float] NOT NULL,
	[act_end_date] [smalldatetime] NOT NULL,
	[act_start_date] [smalldatetime] NOT NULL,
	[act_units] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[eac_amount] [float] NOT NULL,
	[eac_end_date] [smalldatetime] NOT NULL,
	[eac_rate] [float] NOT NULL,
	[eac_start_date] [smalldatetime] NOT NULL,
	[eac_units] [float] NOT NULL,
	[employee] [char](10) NOT NULL,
	[lineID] [smallint] NOT NULL,
	[linenbr] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[orig_amount] [float] NOT NULL,
	[orig_end_date] [smalldatetime] NOT NULL,
	[orig_rate] [float] NOT NULL,
	[orig_start_date] [smalldatetime] NOT NULL,
	[orig_units] [float] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[resource_id] [char](10) NOT NULL,
	[resource_type] [char](16) NOT NULL,
	[ss_id01] [char](30) NOT NULL,
	[ss_id02] [char](30) NOT NULL,
	[ss_id03] [char](16) NOT NULL,
	[ss_id04] [char](16) NOT NULL,
	[ss_id05] [char](4) NOT NULL,
	[ss_id06] [float] NOT NULL,
	[ss_id07] [float] NOT NULL,
	[ss_id08] [smalldatetime] NOT NULL,
	[ss_id09] [smalldatetime] NOT NULL,
	[ss_id10] [smallint] NOT NULL,
	[subcontractor] [char](10) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjressum0] PRIMARY KEY NONCLUSTERED 
(
	[project] ASC,
	[pjt_entity] ASC,
	[acct] ASC,
	[resource_type] ASC,
	[employee] ASC,
	[subcontractor] ASC,
	[resource_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
