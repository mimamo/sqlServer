USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PJREVTIM]    Script Date: 12/21/2015 13:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJREVTIM](
	[Acct] [char](16) NOT NULL,
	[Amount] [float] NOT NULL,
	[bp_id01] [char](30) NOT NULL,
	[bp_id02] [char](30) NOT NULL,
	[bp_id03] [char](16) NOT NULL,
	[bp_id04] [char](16) NOT NULL,
	[bp_id05] [char](4) NOT NULL,
	[bp_id06] [float] NOT NULL,
	[bp_id07] [float] NOT NULL,
	[bp_id08] [smalldatetime] NOT NULL,
	[bp_id09] [smalldatetime] NOT NULL,
	[bp_id10] [int] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project] [char](16) NOT NULL,
	[Rate] [float] NOT NULL,
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
 CONSTRAINT [pjrevtim0] PRIMARY KEY CLUSTERED 
(
	[project] ASC,
	[RevId] ASC,
	[pjt_entity] ASC,
	[Acct] ASC,
	[fiscalno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
