USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[vs_AcctSub]    Script Date: 12/21/2015 14:26:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vs_AcctSub](
	[Acct] [char](10) NOT NULL,
	[Active] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NULL,
	[Crtd_User] [char](10) NULL,
	[Descr] [char](60) NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NULL,
	[LUpd_User] [char](10) NULL,
	[NoteID] [int] NOT NULL,
	[S4Future01] [char](30) NULL,
	[S4Future02] [char](30) NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NULL,
	[S4Future12] [char](10) NULL,
	[Sub] [char](24) NOT NULL,
	[User1] [char](30) NULL,
	[User2] [char](30) NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NULL,
	[User6] [char](10) NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [vs_AcctSub0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[Acct] ASC,
	[Sub] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
