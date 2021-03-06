USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PCSetup]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PCSetup](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrPerNbr] [char](6) NOT NULL,
	[Init] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PCAE_Install] [char](1) NOT NULL,
	[PC_Install] [char](1) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[S4Future1] [char](10) NOT NULL,
	[S4Future10] [smallint] NOT NULL,
	[S4Future11] [smallint] NOT NULL,
	[S4Future12] [smallint] NOT NULL,
	[S4Future13] [float] NOT NULL,
	[S4Future14] [float] NOT NULL,
	[S4Future2] [char](10) NOT NULL,
	[S4Future3] [char](1) NOT NULL,
	[S4Future4] [char](1) NOT NULL,
	[S4Future5] [char](1) NOT NULL,
	[S4Future6] [char](1) NOT NULL,
	[S4Future7] [smallint] NOT NULL,
	[S4Future8] [smallint] NOT NULL,
	[S4Future9] [smallint] NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PCSetup0] PRIMARY KEY CLUSTERED 
(
	[SetupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
