USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSEscrowTran]    Script Date: 12/21/2015 13:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSEscrowTran](
	[Account] [char](10) NOT NULL,
	[AcctId] [char](10) NOT NULL,
	[AcctNo] [char](20) NOT NULL,
	[AddPrinAmt] [float] NOT NULL,
	[AmtRec] [float] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[Cleared] [smallint] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EscrowAmt] [float] NOT NULL,
	[FeesAmt] [float] NOT NULL,
	[IntAmt] [float] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MortNo] [char](10) NOT NULL,
	[Name] [char](30) NOT NULL,
	[Payee_Addr1] [char](30) NOT NULL,
	[Payee_Addr2] [char](30) NOT NULL,
	[Payee_City] [char](30) NOT NULL,
	[Payee_St] [char](2) NOT NULL,
	[Payee_Zip] [char](10) NOT NULL,
	[PayTo] [char](60) NOT NULL,
	[PerClosed] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PrinAmt] [float] NOT NULL,
	[RecvdDate] [smalldatetime] NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[SubAccount] [char](24) NOT NULL,
	[TranAmount] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](60) NOT NULL,
	[TranStatus] [char](1) NOT NULL,
	[TranType] [char](2) NOT NULL,
	[TypeCode] [char](6) NOT NULL,
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
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Account]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [AcctId]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [AcctNo]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [AddPrinAmt]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [AmtRec]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0)) FOR [Cleared]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [EscrowAmt]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [FeesAmt]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [IntAmt]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [MortNo]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Payee_Addr1]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Payee_Addr2]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Payee_City]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Payee_St]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [Payee_Zip]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [PayTo]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [PerClosed]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [PrinAmt]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('01/01/1900') FOR [RecvdDate]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [SubAccount]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [TranAmount]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [TranDescr]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [TranStatus]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [TranType]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [TypeCode]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSEscrowTran] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
