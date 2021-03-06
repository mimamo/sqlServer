USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJUTGOAL]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJUTGOAL](
	[available_hours] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[employee] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[hours_goal] [float] NOT NULL,
	[hours_goal_percent] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[rate] [float] NOT NULL,
	[revenue_goal] [float] NOT NULL,
	[ug_id01] [char](30) NOT NULL,
	[ug_id02] [char](30) NOT NULL,
	[ug_id03] [char](20) NOT NULL,
	[ug_id04] [char](20) NOT NULL,
	[ug_id05] [char](10) NOT NULL,
	[ug_id06] [char](10) NOT NULL,
	[ug_id07] [char](4) NOT NULL,
	[ug_id08] [float] NOT NULL,
	[ug_id09] [smalldatetime] NOT NULL,
	[ug_id10] [int] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjutgoal0] PRIMARY KEY CLUSTERED 
(
	[employee] ASC,
	[fiscalno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
