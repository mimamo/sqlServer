USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[Batch]    Script Date: 12/21/2015 13:43:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Batch](
	[Acct] [char](10) NOT NULL,
	[AutoRev] [smallint] NOT NULL,
	[AutoRevCopy] [smallint] NOT NULL,
	[BalanceType] [char](1) NOT NULL,
	[BankAcct] [char](10) NOT NULL,
	[BankSub] [char](24) NOT NULL,
	[BaseCuryID] [char](4) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BatType] [char](1) NOT NULL,
	[clearamt] [float] NOT NULL,
	[Cleared] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CrTot] [float] NOT NULL,
	[CtrlTot] [float] NOT NULL,
	[CuryCrTot] [float] NOT NULL,
	[CuryCtrlTot] [float] NOT NULL,
	[CuryDepositAmt] [float] NOT NULL,
	[CuryDrTot] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[Cycle] [smallint] NOT NULL,
	[DateClr] [smalldatetime] NOT NULL,
	[DateEnt] [smalldatetime] NOT NULL,
	[DepositAmt] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DrTot] [float] NOT NULL,
	[EditScrnNbr] [char](5) NOT NULL,
	[GLPostOpt] [char](1) NOT NULL,
	[JrnlType] [char](3) NOT NULL,
	[LedgerID] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[NbrCycle] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigBatNbr] [char](10) NOT NULL,
	[OrigCpnyID] [char](10) NOT NULL,
	[OrigScrnNbr] [char](5) NOT NULL,
	[PerEnt] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[Rlsed] [smallint] NOT NULL,
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
	[Status] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Batch0] PRIMARY KEY CLUSTERED 
(
	[Module] ASC,
	[BatNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_AutoRev]  DEFAULT ((0)) FOR [AutoRev]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_AutoRevCopy]  DEFAULT ((0)) FOR [AutoRevCopy]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BalanceType]  DEFAULT (' ') FOR [BalanceType]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BankAcct]  DEFAULT (' ') FOR [BankAcct]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BankSub]  DEFAULT (' ') FOR [BankSub]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BaseCuryID]  DEFAULT (' ') FOR [BaseCuryID]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BatType]  DEFAULT (' ') FOR [BatType]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_clearamt]  DEFAULT ((0)) FOR [clearamt]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Cleared]  DEFAULT ((0)) FOR [Cleared]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CrTot]  DEFAULT ((0)) FOR [CrTot]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CtrlTot]  DEFAULT ((0)) FOR [CtrlTot]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryCrTot]  DEFAULT ((0)) FOR [CuryCrTot]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryCtrlTot]  DEFAULT ((0)) FOR [CuryCtrlTot]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryDepositAmt]  DEFAULT ((0)) FOR [CuryDepositAmt]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryDrTot]  DEFAULT ((0)) FOR [CuryDrTot]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryId]  DEFAULT (' ') FOR [CuryId]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Cycle]  DEFAULT ((0)) FOR [Cycle]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_DateClr]  DEFAULT ('01/01/1900') FOR [DateClr]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_DateEnt]  DEFAULT ('01/01/1900') FOR [DateEnt]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_DepositAmt]  DEFAULT ((0)) FOR [DepositAmt]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_DrTot]  DEFAULT ((0)) FOR [DrTot]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_EditScrnNbr]  DEFAULT (' ') FOR [EditScrnNbr]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_GLPostOpt]  DEFAULT (' ') FOR [GLPostOpt]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_JrnlType]  DEFAULT (' ') FOR [JrnlType]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_LedgerID]  DEFAULT (' ') FOR [LedgerID]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Module]  DEFAULT (' ') FOR [Module]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_NbrCycle]  DEFAULT ((0)) FOR [NbrCycle]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_OrigBatNbr]  DEFAULT (' ') FOR [OrigBatNbr]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_OrigCpnyID]  DEFAULT (' ') FOR [OrigCpnyID]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_OrigScrnNbr]  DEFAULT (' ') FOR [OrigScrnNbr]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_PerEnt]  DEFAULT (' ') FOR [PerEnt]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_PerPost]  DEFAULT (' ') FOR [PerPost]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Rlsed]  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_Sub]  DEFAULT (' ') FOR [Sub]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
