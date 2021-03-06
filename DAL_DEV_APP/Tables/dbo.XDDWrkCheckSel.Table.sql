USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[XDDWrkCheckSel]    Script Date: 12/21/2015 13:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDWrkCheckSel](
	[AccessNbr] [smallint] NOT NULL,
	[Acct] [char](10) NOT NULL,
	[AdjFlag] [smallint] NOT NULL,
	[ApplyRefNbr] [char](10) NOT NULL,
	[CheckCuryId] [char](4) NOT NULL,
	[CheckCuryRate] [float] NOT NULL,
	[CheckCuryMultDiv] [char](1) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CheckRefNbr] [char](10) NULL,
	[CuryDecPl] [smallint] NOT NULL,
	[CuryDiscBal] [float] NOT NULL,
	[CuryDiscTkn] [float] NOT NULL,
	[CuryDocBal] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPmtAmt] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[DiscBal] [float] NOT NULL,
	[DiscDate] [smalldatetime] NOT NULL,
	[DiscTkn] [float] NOT NULL,
	[DocBal] [float] NOT NULL,
	[DocDesc] [char](30) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[DueDate] [smalldatetime] NOT NULL,
	[EBActive] [smallint] NOT NULL,
	[EBBatNbr] [char](10) NOT NULL,
	[EBCheckDate] [smalldatetime] NOT NULL,
	[EBChkWF] [char](1) NOT NULL,
	[EBChkWF_CreateMCB] [char](1) NOT NULL,
	[EBDescr] [char](60) NOT NULL,
	[EBEmailNotif] [smallint] NOT NULL,
	[EBEntryClass] [char](4) NOT NULL,
	[EBEStatus] [char](1) NOT NULL,
	[EBFormatID] [char](15) NOT NULL,
	[EBGroup] [char](1) NOT NULL,
	[EBInvcDate] [smalldatetime] NOT NULL,
	[EBInvcNbr] [char](15) NOT NULL,
	[EBNACHATxn] [smallint] NOT NULL,
	[EBPreNoteApp] [smallint] NOT NULL,
	[EBSeparateTxnType] [char](10) NOT NULL,
	[EBTerminated] [smallint] NOT NULL,
	[EBTxnType] [char](10) NOT NULL,
	[EBVchCuryID] [char](4) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[MultiChk] [smallint] NOT NULL,
	[PayDate] [smalldatetime] NOT NULL,
	[PmtAmt] [float] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
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
	[Sub] [char](24) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [AdjFlag]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [ApplyRefNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CheckCuryId]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CheckCuryRate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CheckCuryMultDiv]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CheckRefNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CuryDecPl]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CuryDiscBal]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CuryDiscTkn]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CuryDocBal]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CuryPmtAmt]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [DiscBal]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [DiscDate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [DiscTkn]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [DocBal]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [DocDesc]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [DocType]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [DueDate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [EBActive]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBBatNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [EBCheckDate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBChkWF]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBChkWF_CreateMCB]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBDescr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [EBEmailNotif]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBEntryClass]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBEStatus]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBFormatID]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBGroup]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [EBInvcDate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBInvcNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [EBNACHATxn]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [EBPreNoteApp]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBSeparateTxnType]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [EBTerminated]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBTxnType]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [EBVchCuryID]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [MultiChk]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [PayDate]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [PmtAmt]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDWrkCheckSel] ADD  DEFAULT ('') FOR [VendId]
GO
