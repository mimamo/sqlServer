USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSLLTran]    Script Date: 12/21/2015 13:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLTran](
	[BaseCuryId] [char](4) NOT NULL,
	[BaseMultDiv] [char](1) NOT NULL,
	[BaseRate] [float] NOT NULL,
	[BaseRateType] [char](6) NOT NULL,
	[BaseTranAmt] [float] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CheckNo] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CrSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSub] [char](24) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[EntCuryID] [char](4) NOT NULL,
	[EntRateType] [char](6) NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PmtRefNbr] [char](10) NOT NULL,
	[PmtType] [char](3) NOT NULL,
	[PmtTypeCode] [char](10) NOT NULL,
	[PostBatNbr] [char](10) NOT NULL,
	[PostModule] [char](2) NOT NULL,
	[PostRefNbr] [char](10) NOT NULL,
	[ReceiptNo] [char](10) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[RetroApply] [smallint] NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](60) NOT NULL,
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
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [BaseCuryId]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [BaseMultDiv]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [BaseRate]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [BaseRateType]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [BaseTranAmt]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CheckNo]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CrSub]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [CuryTranAmt]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [DrSub]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [EntCuryID]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [EntRateType]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PmtRefNbr]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PmtType]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PmtTypeCode]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PostBatNbr]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PostModule]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [PostRefNbr]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [ReceiptNo]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0)) FOR [RetroApply]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [TranDescr]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [TranStatus]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLTran] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
