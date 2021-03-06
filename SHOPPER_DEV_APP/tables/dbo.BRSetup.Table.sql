USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[BRSetup]    Script Date: 12/21/2015 14:33:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BRSetup](
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[AggSubAcct] [char](10) NOT NULL,
	[City] [char](20) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[Periods] [int] NOT NULL,
	[FutureC1] [char](30) NOT NULL,
	[FutureC2] [char](10) NOT NULL,
	[FutureD1] [smalldatetime] NOT NULL,
	[FutureF1] [float] NOT NULL,
	[FutureI1] [int] NOT NULL,
	[FutureL1] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](30) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PullAP] [smallint] NOT NULL,
	[PullAR] [smallint] NOT NULL,
	[PullCA] [smallint] NOT NULL,
	[PullGL] [smallint] NOT NULL,
	[PullIN] [smallint] NOT NULL,
	[PullPC] [smallint] NOT NULL,
	[PullPR] [smallint] NOT NULL,
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
	[SetupID] [char](4) NOT NULL,
	[State] [char](3) NOT NULL,
	[UseAggSub] [smallint] NOT NULL,
	[UserC1] [char](30) NOT NULL,
	[UserC2] [char](10) NOT NULL,
	[UserD1] [smalldatetime] NOT NULL,
	[UserF1] [float] NOT NULL,
	[UserI1] [int] NOT NULL,
	[UserL1] [smallint] NOT NULL,
	[Zip] [char](9) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
