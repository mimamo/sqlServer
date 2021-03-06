USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[BRTran]    Script Date: 12/21/2015 14:10:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BRTran](
	[AcctID] [char](10) NOT NULL,
	[ClearDate] [smalldatetime] NOT NULL,
	[Cleared] [smallint] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrPerNbr] [char](6) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[FutureC1] [char](30) NOT NULL,
	[FutureD1] [smalldatetime] NOT NULL,
	[FutureF1] [float] NOT NULL,
	[FutureI1] [int] NOT NULL,
	[FutureL1] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MainKey] [char](40) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigBatNbr] [char](10) NOT NULL,
	[OrigID] [char](10) NOT NULL,
	[OrigLineNbr] [smallint] NOT NULL,
	[OrigModule] [char](2) NOT NULL,
	[OrigRefNbr] [char](10) NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
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
	[SetUpID] [char](4) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](30) NOT NULL,
	[UserC1] [char](30) NOT NULL,
	[UserC2] [char](30) NOT NULL,
	[UserC3] [char](10) NOT NULL,
	[UserC4] [char](10) NOT NULL,
	[UserD1] [smalldatetime] NOT NULL,
	[UserD2] [smalldatetime] NOT NULL,
	[UserF1] [float] NOT NULL,
	[UserF2] [float] NOT NULL,
	[UserI1] [int] NOT NULL,
	[UserI2] [int] NOT NULL,
	[UserL1] [smallint] NOT NULL,
	[UserL2] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
