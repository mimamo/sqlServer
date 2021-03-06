USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkCABalances]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkCABalances](
	[bankacct] [char](10) NOT NULL,
	[banksub] [char](24) NOT NULL,
	[CABalance] [float] NOT NULL,
	[CACuryBalance] [float] NOT NULL,
	[CashAcctName] [char](30) NOT NULL,
	[CloseBal] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Curyclosebal] [float] NOT NULL,
	[CuryDisbursements] [float] NOT NULL,
	[CuryGLBalance] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryReceipts] [float] NOT NULL,
	[Disbursements] [float] NOT NULL,
	[GLBalance] [float] NOT NULL,
	[LastReconDate] [smalldatetime] NOT NULL,
	[NbrChecks] [smallint] NOT NULL,
	[NbrChkDays] [smallint] NOT NULL,
	[NbrDepDays] [smallint] NOT NULL,
	[NbrDeposits] [smallint] NOT NULL,
	[Period] [char](6) NOT NULL,
	[Receipts] [float] NOT NULL,
	[ReconcileFlag] [smallint] NOT NULL,
	[ReconDate] [smalldatetime] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Trandate] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
