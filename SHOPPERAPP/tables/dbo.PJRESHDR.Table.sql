USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJRESHDR]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJRESHDR](
	[acct] [char](16) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[sh_id01] [char](30) NOT NULL,
	[sh_id02] [char](30) NOT NULL,
	[sh_id03] [char](16) NOT NULL,
	[sh_id04] [char](16) NOT NULL,
	[sh_id05] [char](4) NOT NULL,
	[sh_id06] [float] NOT NULL,
	[sh_id07] [float] NOT NULL,
	[sh_id08] [smalldatetime] NOT NULL,
	[sh_id09] [smalldatetime] NOT NULL,
	[sh_id10] [smallint] NOT NULL,
	[sh_id11] [float] NOT NULL,
	[sh_id12] [float] NOT NULL,
	[sh_id13] [float] NOT NULL,
	[sh_id14] [float] NOT NULL,
	[sh_id15] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjreshdr0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[pjt_entity] ASC,
	[acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
