USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLPmtHdr]    Script Date: 12/21/2015 16:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLPmtHdr](
	[BaseCuryId] [char](4) NOT NULL,
	[BaseMultDiv] [char](1) NOT NULL,
	[BaseRate] [float] NOT NULL,
	[BaseRateType] [char](6) NOT NULL,
	[BaseTranAmt] [float] NOT NULL,
	[BaseTranFees] [float] NOT NULL,
	[CheckNo] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[CuryTranFees] [float] NOT NULL,
	[DepBatNbr] [char](10) NOT NULL,
	[DepLineNbr] [smallint] NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[EntCuryId] [char](4) NOT NULL,
	[EntRateType] [char](6) NOT NULL,
	[FeeCode] [char](10) NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PmtNbr] [smallint] NOT NULL,
	[PmtType] [char](2) NOT NULL,
	[ReceiptNo] [char](10) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](60) NOT NULL,
	[TranFees] [float] NOT NULL,
	[TranStatus] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [BaseCuryId]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [BaseMultDiv]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [BaseRate]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [BaseRateType]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [BaseTranAmt]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [BaseTranFees]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [CheckNo]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [CuryTranAmt]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [CuryTranFees]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [DepBatNbr]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0)) FOR [DepLineNbr]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [EntCuryId]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [EntRateType]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [FeeCode]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [PmtType]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [ReceiptNo]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [TranDesc]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [TranFees]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [TranStatus]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLPmtHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
