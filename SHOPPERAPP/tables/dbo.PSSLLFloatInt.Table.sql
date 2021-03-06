USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PSSLLFloatInt]    Script Date: 12/21/2015 16:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLFloatInt](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DateBeg] [smalldatetime] NOT NULL,
	[DateEnd] [smalldatetime] NOT NULL,
	[DayCount] [char](1) NOT NULL,
	[EndBalance] [float] NOT NULL,
	[EscrowPmt] [float] NOT NULL,
	[FirstPmtDueDate] [smalldatetime] NOT NULL,
	[IndCode] [char](6) NOT NULL,
	[IntRate] [float] NOT NULL,
	[IntRateBase] [float] NOT NULL,
	[IntRateFloor] [float] NOT NULL,
	[IntRateIndexSpread] [float] NOT NULL,
	[IntRatePen] [float] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PmtAmt] [float] NOT NULL,
	[PmtBalloon] [float] NOT NULL,
	[PmtDueDay] [int] NOT NULL,
	[PmtFixed] [int] NOT NULL,
	[PmtFreq] [char](1) NOT NULL,
	[PmtNbrBeg] [int] NOT NULL,
	[PmtNbrEnd] [int] NOT NULL,
	[Recalc] [smallint] NOT NULL,
	[TermIntOnly] [int] NOT NULL,
	[TermNoPmt] [int] NOT NULL,
	[TermToMat] [int] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [DateBeg]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [DateEnd]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [DayCount]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [EndBalance]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [EscrowPmt]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [FirstPmtDueDate]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [IndCode]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [IntRate]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [IntRateBase]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [IntRateFloor]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [IntRateIndexSpread]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [IntRatePen]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [PmtAmt]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [PmtBalloon]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [PmtDueDay]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [PmtFixed]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [PmtFreq]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [PmtNbrBeg]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [PmtNbrEnd]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [Recalc]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [TermIntOnly]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [TermNoPmt]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0)) FOR [TermToMat]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLFloatInt] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
