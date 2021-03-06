USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLPreCalcTemp]    Script Date: 12/21/2015 16:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLPreCalcTemp](
	[AccessNbr] [smallint] NOT NULL,
	[Deposit] [float] NOT NULL,
	[FinAmt] [float] NOT NULL,
	[IntRate] [float] NOT NULL,
	[OrigValue] [float] NOT NULL,
	[PmtAmt] [float] NOT NULL,
	[PmtTerms] [char](1) NOT NULL,
	[TermsToMat] [smallint] NOT NULL,
	[UserId] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0.00)) FOR [Deposit]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0.00)) FOR [FinAmt]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0.00)) FOR [IntRate]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0.00)) FOR [OrigValue]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0.00)) FOR [PmtAmt]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ('') FOR [PmtTerms]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ((0)) FOR [TermsToMat]
GO
ALTER TABLE [dbo].[PSSLLPreCalcTemp] ADD  DEFAULT ('') FOR [UserId]
GO
