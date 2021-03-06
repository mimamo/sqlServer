USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[WrkBatch]    Script Date: 12/21/2015 15:54:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkBatch](
	[Acct] [char](10) NULL,
	[AutoRev] [smallint] NULL,
	[AutoRevCopy] [smallint] NULL,
	[BalanceType] [char](1) NULL,
	[BasecuryID] [char](4) NULL,
	[BatNbr] [char](10) NOT NULL,
	[BatType] [char](1) NULL,
	[ClearAmt] [float] NULL,
	[Cleared] [smallint] NULL,
	[CpnyID] [char](10) NULL,
	[CrTot] [float] NULL,
	[CtrlTot] [float] NULL,
	[CuryCrTot] [float] NULL,
	[CuryCtrlTot] [float] NULL,
	[CuryDrTot] [float] NULL,
	[CuryEffDate] [smalldatetime] NULL,
	[CuryID] [char](4) NULL,
	[CuryMultDiv] [char](1) NULL,
	[CuryRate] [float] NULL,
	[CuryRateType] [char](6) NULL,
	[Cycle] [smallint] NULL,
	[DateClr] [smalldatetime] NULL,
	[DateEnt] [smalldatetime] NULL,
	[Descr] [char](30) NULL,
	[DRTot] [float] NULL,
	[EditScrnNbr] [char](5) NULL,
	[GLPostOpt] [char](1) NULL,
	[JrnlType] [char](3) NULL,
	[LedgerID] [char](10) NULL,
	[Module] [char](2) NULL,
	[NbrCycle] [smallint] NULL,
	[NoteID] [int] NULL,
	[OrigBatNbr] [char](10) NULL,
	[PerEnt] [char](6) NULL,
	[PerPost] [char](6) NULL,
	[RI_ID] [smallint] NOT NULL,
	[Rlsed] [smallint] NULL,
	[Status] [char](1) NULL,
	[Sub] [char](24) NULL,
	[User1] [char](30) NULL,
	[User2] [char](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkBatch0] PRIMARY KEY CLUSTERED 
(
	[RI_ID] ASC,
	[BatNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
