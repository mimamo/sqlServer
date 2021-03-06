USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[CASetup]    Script Date: 12/21/2015 15:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CASetup](
	[AcceptTransDate] [smalldatetime] NOT NULL,
	[ARHoldingAcct] [char](10) NOT NULL,
	[ARHoldingSub] [char](24) NOT NULL,
	[AutoBatRpt] [smallint] NOT NULL,
	[BnkChgType] [char](2) NOT NULL,
	[ClearAcct] [char](10) NOT NULL,
	[ClearSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrPerNbr] [char](6) NOT NULL,
	[DfltRateType] [char](6) NOT NULL,
	[DfltRcnclAmt] [smallint] NOT NULL,
	[GlPostOpt] [char](1) NOT NULL,
	[Init] [smallint] NOT NULL,
	[lastbatnbr] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MCuryBatRpt] [smallint] NOT NULL,
	[NbrAvgDay] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[paststartdate] [smalldatetime] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PerretBal] [smallint] NOT NULL,
	[PerRetTran] [smallint] NOT NULL,
	[PostGLDetail] [smallint] NOT NULL,
	[PrtEmpName] [smallint] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SetUpId] [char](2) NOT NULL,
	[ShowGLInfo] [smallint] NOT NULL,
	[ShowLastBankRecs] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [CASetup0] PRIMARY KEY NONCLUSTERED 
(
	[SetUpId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
