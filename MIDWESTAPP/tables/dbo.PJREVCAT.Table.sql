USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PJREVCAT]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJREVCAT](
	[Acct] [char](16) NOT NULL,
	[Amount] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[Rate] [float] NOT NULL,
	[rc_id01] [char](30) NOT NULL,
	[rc_id02] [char](30) NOT NULL,
	[rc_id03] [char](16) NOT NULL,
	[rc_id04] [char](16) NOT NULL,
	[rc_id05] [char](4) NOT NULL,
	[rc_id06] [float] NOT NULL,
	[rc_id07] [float] NOT NULL,
	[rc_id08] [smalldatetime] NOT NULL,
	[rc_id09] [smalldatetime] NOT NULL,
	[rc_id10] [smallint] NOT NULL,
	[RevId] [char](4) NOT NULL,
	[Units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrevcat0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[RevId] ASC,
	[pjt_entity] ASC,
	[Acct] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
