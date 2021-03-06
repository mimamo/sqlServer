USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSLLFloatWrk]    Script Date: 12/21/2015 13:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLFloatWrk](
	[AccessNbr] [smallint] NOT NULL,
	[DateBeg] [smalldatetime] NOT NULL,
	[DateEnd] [smalldatetime] NOT NULL,
	[DayCount] [char](1) NOT NULL,
	[IntRate] [float] NOT NULL,
	[IntRateBase] [float] NOT NULL,
	[IntRateFloor] [float] NOT NULL,
	[IntRateIndexSpread] [float] NOT NULL,
	[IntRatePen] [float] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[PmtAmt] [float] NOT NULL,
	[PmtBalloon] [float] NOT NULL,
	[PmtDueDay] [int] NOT NULL,
	[PmtFixed] [int] NOT NULL,
	[PmtFreq] [char](1) NOT NULL,
	[PmtNbrBeg] [int] NOT NULL,
	[PmtNbrEnd] [int] NOT NULL,
	[TermIntOnly] [int] NOT NULL,
	[TermToMat] [int] NOT NULL,
	[UserId] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ('01/01/1900') FOR [DateBeg]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ('01/01/1900') FOR [DateEnd]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ('') FOR [DayCount]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [IntRate]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [IntRateBase]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [IntRateFloor]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [IntRateIndexSpread]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [IntRatePen]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [PmtAmt]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0.00)) FOR [PmtBalloon]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [PmtDueDay]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [PmtFixed]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ('') FOR [PmtFreq]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [PmtNbrBeg]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [PmtNbrEnd]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [TermIntOnly]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ((0)) FOR [TermToMat]
GO
ALTER TABLE [dbo].[PSSLLFloatWrk] ADD  DEFAULT ('') FOR [UserId]
GO
