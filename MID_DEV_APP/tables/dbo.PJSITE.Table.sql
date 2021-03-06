USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[PJSITE]    Script Date: 12/21/2015 14:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJSITE](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[EmailAddress] [char](80) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Password] [char](10) NOT NULL,
	[si_id01] [char](30) NOT NULL,
	[si_id02] [char](30) NOT NULL,
	[si_id03] [char](20) NOT NULL,
	[si_id04] [char](20) NOT NULL,
	[si_id05] [char](10) NOT NULL,
	[si_id06] [char](10) NOT NULL,
	[si_id07] [char](4) NOT NULL,
	[si_id08] [float] NOT NULL,
	[si_id09] [smalldatetime] NOT NULL,
	[si_id10] [int] NOT NULL,
	[TerminalCode] [char](4) NOT NULL,
	[TerminalName] [char](60) NOT NULL,
	[Type_site] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjsite0] PRIMARY KEY CLUSTERED 
(
	[TerminalCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
