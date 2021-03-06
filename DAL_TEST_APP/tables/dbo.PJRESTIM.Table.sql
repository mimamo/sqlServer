USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJRESTIM]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRESTIM](
	[acct] [char](16) NOT NULL,
	[act_amount] [float] NOT NULL,
	[act_units] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[eac_amount] [float] NOT NULL,
	[eac_rate] [float] NOT NULL,
	[eac_units] [float] NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[fsyear_num] [char](4) NOT NULL,
	[lineID] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[orig_amount] [float] NOT NULL,
	[orig_rate] [float] NOT NULL,
	[orig_units] [float] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[st_id01] [char](30) NOT NULL,
	[st_id02] [char](30) NOT NULL,
	[st_id03] [char](16) NOT NULL,
	[st_id04] [char](16) NOT NULL,
	[st_id05] [char](4) NOT NULL,
	[st_id06] [float] NOT NULL,
	[st_id07] [float] NOT NULL,
	[st_id08] [smalldatetime] NOT NULL,
	[st_id09] [smalldatetime] NOT NULL,
	[st_id10] [smallint] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrestim0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[pjt_entity] ASC,
	[acct] ASC,
	[lineID] ASC,
	[fiscalno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
