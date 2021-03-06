USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[POBudHist]    Script Date: 12/21/2015 16:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POBudHist](
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
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [AnnBdgt]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [AnnMemo1]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [BalanceType]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ('01/01/1900') FOR [BdgtRvsnDate]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [BegBal]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [CuryId]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [DistType]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [LastClosePerNbr]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [LedgerID]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc00]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc01]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc02]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc03]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc04]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc05]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc06]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc07]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc08]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc09]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc10]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc11]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdAlloc12]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal00]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal01]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal02]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal03]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal04]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal05]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal06]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal07]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal08]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal09]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal10]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal11]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdBal12]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon00]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon01]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon02]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon03]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon04]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon05]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon06]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon07]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon08]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon09]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon10]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon11]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [PtdCon12]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [SpreadSheetType]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal00]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal01]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal02]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal03]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal04]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal05]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal06]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal07]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal08]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal09]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal10]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal11]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YtdBal12]
GO
ALTER TABLE [dbo].[POBudHist] ADD  DEFAULT ((0)) FOR [YTDEstimated]
GO
