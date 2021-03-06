USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSEscrowRec]    Script Date: 12/21/2015 14:05:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSEscrowRec](
	[AcctId] [char](10) NOT NULL,
	[AcctNo] [char](20) NOT NULL,
	[BalanceAdjust] [float] NOT NULL,
	[BalanceBank] [float] NOT NULL,
	[BalanceBooks] [float] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Fees] [float] NOT NULL,
	[Interest] [float] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[OutstandChecks] [float] NOT NULL,
	[OutstandDeposits] [float] NOT NULL,
	[PerEntered] [char](6) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ReconDate] [smalldatetime] NOT NULL,
	[ReconStatus] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [AcctId]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [AcctNo]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [BalanceAdjust]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [BalanceBank]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [BalanceBooks]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [Fees]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [Interest]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [OutstandChecks]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [OutstandDeposits]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [PerEntered]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('01/01/1900') FOR [ReconDate]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [ReconStatus]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSEscrowRec] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
