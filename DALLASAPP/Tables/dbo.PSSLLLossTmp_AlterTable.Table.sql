USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSLLLossTmp_AlterTable]    Script Date: 12/21/2015 13:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLLossTmp_AlterTable](
	[IntBalClose] [float] NOT NULL,
	[IntBalCloseCury] [float] NOT NULL,
	[LoanLossPercent] [float] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LoanTypeCode] [char](10) NOT NULL,
	[NbrLateDays] [smallint] NOT NULL,
	[NbrLateMo] [smallint] NOT NULL,
	[PrinBalClose] [float] NOT NULL,
	[PrinBalCloseCury] [float] NOT NULL,
	[RI_ID] [int] NOT NULL,
	[SuspendIntAmt] [float] NOT NULL,
	[SuspendIntAmtCury] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntBalClose]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntBalCloseCury]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [LoanLossPercent]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ('') FOR [LoanTypeCode]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0)) FOR [NbrLateDays]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0)) FOR [NbrLateMo]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinBalClose]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinBalCloseCury]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [SuspendIntAmt]
GO
ALTER TABLE [dbo].[PSSLLLossTmp_AlterTable] ADD  DEFAULT ((0.00)) FOR [SuspendIntAmtCury]
GO
