USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSLLSetup_AlterTable]    Script Date: 12/21/2015 14:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLSetup_AlterTable](
	[AcctSys] [char](2) NOT NULL,
	[AdjScreenTitle] [char](30) NOT NULL,
	[AgeCat1] [smallint] NOT NULL,
	[AgeCat2] [smallint] NOT NULL,
	[AgeCat3] [smallint] NOT NULL,
	[AllowAcctChg] [smallint] NOT NULL,
	[AllowPmtRecvChg] [smallint] NOT NULL,
	[ApplicType] [char](1) NOT NULL,
	[AutoGenLoanNo] [char](1) NOT NULL,
	[BankRoundInt] [smallint] NOT NULL,
	[BaseCuryID] [char](4) NOT NULL,
	[BeforeLateFee] [smallint] NOT NULL,
	[CalcIntOnIssue] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustLoanApp] [smallint] NOT NULL,
	[Custom0Label] [char](15) NOT NULL,
	[Custom10Label] [char](15) NOT NULL,
	[Custom11Label] [char](15) NOT NULL,
	[Custom12Label] [char](15) NOT NULL,
	[Custom13Label] [char](15) NOT NULL,
	[Custom14Label] [char](15) NOT NULL,
	[Custom15Label] [char](15) NOT NULL,
	[Custom1Label] [char](15) NOT NULL,
	[Custom2Label] [char](15) NOT NULL,
	[Custom3Label] [char](15) NOT NULL,
	[Custom4Label] [char](15) NOT NULL,
	[Custom5Label] [char](15) NOT NULL,
	[Custom6Label] [char](15) NOT NULL,
	[Custom7Label] [char](15) NOT NULL,
	[Custom8Label] [char](15) NOT NULL,
	[Custom9Label] [char](15) NOT NULL,
	[DepositRefund] [smallint] NOT NULL,
	[EmailAuthPass] [char](100) NOT NULL,
	[EmailAuthType] [char](1) NOT NULL,
	[EmailAuthUser] [char](100) NOT NULL,
	[EmailFromAddress] [char](100) NOT NULL,
	[EmailServer] [char](100) NOT NULL,
	[EmailSubject] [char](100) NOT NULL,
	[EODRunning] [smallint] NOT NULL,
	[FinancialAppl] [char](1) NOT NULL,
	[GroupIntFreeze] [char](47) NOT NULL,
	[GroupPmtPost] [char](47) NOT NULL,
	[GroupPosting] [char](47) NOT NULL,
	[GroupWriteOff] [char](47) NOT NULL,
	[IntLockDate] [smalldatetime] NOT NULL,
	[LastAcctId] [char](10) NOT NULL,
	[LastApplicationNbr] [char](10) NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LastCoTransNbr] [char](10) NOT NULL,
	[LastLoanNo] [char](20) NOT NULL,
	[LastRefNbr] [char](10) NOT NULL,
	[LateFeeAmt] [float] NOT NULL,
	[LateFeePmtCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoDecimDailyInt] [smallint] NOT NULL,
	[PeriodLocked] [char](6) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PmtRecvToday] [smallint] NOT NULL,
	[PmtScreenTitle] [char](30) NOT NULL,
	[PopUpNotePend] [char](100) NOT NULL,
	[PopUpNotePost] [char](100) NOT NULL,
	[PostApproval] [smallint] NOT NULL,
	[PostByOwn] [smallint] NOT NULL,
	[PostDescrGL] [char](1) NOT NULL,
	[PostingOpt] [char](1) NOT NULL,
	[PostRefGL] [char](1) NOT NULL,
	[PostToAPbyAcct] [smallint] NOT NULL,
	[PrcsDeferRev] [smallint] NOT NULL,
	[RateTypeId] [char](6) NOT NULL,
	[Region3Label] [char](20) NOT NULL,
	[ReqCustID] [smallint] NOT NULL,
	[ReqVendID] [smallint] NOT NULL,
	[Sector2Label] [char](20) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[ShowCustID] [smallint] NOT NULL,
	[ShowVendID] [smallint] NOT NULL,
	[SignOffTime] [smallint] NOT NULL,
	[SuspendIntDays] [smallint] NOT NULL,
	[Type1Label] [char](20) NOT NULL,
	[UseGLPerPost] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [AcctSys]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [AdjScreenTitle]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [AgeCat1]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [AgeCat2]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [AgeCat3]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [AllowAcctChg]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [AllowPmtRecvChg]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [ApplicType]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [AutoGenLoanNo]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [BankRoundInt]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [BaseCuryID]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [BeforeLateFee]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [CalcIntOnIssue]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [CustLoanApp]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom0Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom10Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom11Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom12Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom13Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom14Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom15Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom1Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom2Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom3Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom4Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom5Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom6Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom7Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom8Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Custom9Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [DepositRefund]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [EmailAuthPass]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [EmailAuthType]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [EmailAuthUser]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [EmailFromAddress]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [EmailServer]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [EmailSubject]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [EODRunning]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [FinancialAppl]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [GroupIntFreeze]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [GroupPmtPost]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [GroupPosting]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [GroupWriteOff]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [IntLockDate]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LastAcctId]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LastApplicationNbr]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LastBatNbr]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LastCoTransNbr]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LastLoanNo]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeeAmt]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LateFeePmtCode]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [NoDecimDailyInt]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PeriodLocked]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PerNbr]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [PmtRecvToday]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PmtScreenTitle]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PopUpNotePend]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PopUpNotePost]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [PostApproval]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [PostByOwn]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PostDescrGL]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PostingOpt]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [PostRefGL]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [PostToAPbyAcct]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [PrcsDeferRev]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [RateTypeId]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Region3Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [ReqCustID]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [ReqVendID]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Sector2Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [SetupId]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [ShowCustID]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [ShowVendID]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [SignOffTime]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [SuspendIntDays]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [Type1Label]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0)) FOR [UseGLPerPost]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLLSetup_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
