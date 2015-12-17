USE [DALLASAPP]
GO

/****** Object:  Table [dbo].[AcctHist]    Script Date: 12/07/2015 13:30:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

ALTER TABLE [dbo].[AcctHist](
	[Acct] [char](10) NOT NULL,
	[AnnBdgt] [float] NOT NULL,
	[AnnMemo1] [float] NOT NULL,
	[BalanceType] [char](1) NOT NULL,
	[BdgtRvsnDate] [smalldatetime] NOT NULL,
	[BegBal] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[DistType] [char](8) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[LastClosePerNbr] [char](6) NOT NULL,
	[LedgerID] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PtdAlloc00] [float] NOT NULL,
	[PtdAlloc01] [float] NOT NULL,
	[PtdAlloc02] [float] NOT NULL,
	[PtdAlloc03] [float] NOT NULL,
	[PtdAlloc04] [float] NOT NULL,
	[PtdAlloc05] [float] NOT NULL,
	[PtdAlloc06] [float] NOT NULL,
	[PtdAlloc07] [float] NOT NULL,
	[PtdAlloc08] [float] NOT NULL,
	[PtdAlloc09] [float] NOT NULL,
	[PtdAlloc10] [float] NOT NULL,
	[PtdAlloc11] [float] NOT NULL,
	[PtdAlloc12] [float] NOT NULL,
	[PtdBal00] [float] NOT NULL,
	[PtdBal01] [float] NOT NULL,
	[PtdBal02] [float] NOT NULL,
	[PtdBal03] [float] NOT NULL,
	[PtdBal04] [float] NOT NULL,
	[PtdBal05] [float] NOT NULL,
	[PtdBal06] [float] NOT NULL,
	[PtdBal07] [float] NOT NULL,
	[PtdBal08] [float] NOT NULL,
	[PtdBal09] [float] NOT NULL,
	[PtdBal10] [float] NOT NULL,
	[PtdBal11] [float] NOT NULL,
	[PtdBal12] [float] NOT NULL,
	[PtdCon00] [float] NOT NULL,
	[PtdCon01] [float] NOT NULL,
	[PtdCon02] [float] NOT NULL,
	[PtdCon03] [float] NOT NULL,
	[PtdCon04] [float] NOT NULL,
	[PtdCon05] [float] NOT NULL,
	[PtdCon06] [float] NOT NULL,
	[PtdCon07] [float] NOT NULL,
	[PtdCon08] [float] NOT NULL,
	[PtdCon09] [float] NOT NULL,
	[PtdCon10] [float] NOT NULL,
	[PtdCon11] [float] NOT NULL,
	[PtdCon12] [float] NOT NULL,
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
	[SpreadSheetType] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[YtdBal00] [float] NOT NULL,
	[YtdBal01] [float] NOT NULL,
	[YtdBal02] [float] NOT NULL,
	[YtdBal03] [float] NOT NULL,
	[YtdBal04] [float] NOT NULL,
	[YtdBal05] [float] NOT NULL,
	[YtdBal06] [float] NOT NULL,
	[YtdBal07] [float] NOT NULL,
	[YtdBal08] [float] NOT NULL,
	[YtdBal09] [float] NOT NULL,
	[YtdBal10] [float] NOT NULL,
	[YtdBal11] [float] NOT NULL,
	[YtdBal12] [float] NOT NULL,
	[YTDEstimated] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [AcctHist0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[Acct] ASC,
	[Sub] ASC,
	[LedgerID] ASC,
	[FiscYr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


