USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[smConDeposit]    Script Date: 12/21/2015 13:44:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smConDeposit](
	[AccruedtoGl] [smallint] NOT NULL,
	[Acct] [char](10) NOT NULL,
	[Amount] [float] NOT NULL,
	[AmtApplied] [float] NOT NULL,
	[ARBatNbr] [char](10) NOT NULL,
	[ARRefNbr] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BillDate] [smalldatetime] NOT NULL,
	[BranchID] [char](10) NOT NULL,
	[Contractid] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[InvBatNbr] [char](10) NOT NULL,
	[InvoiceLineID] [smallint] NOT NULL,
	[InvoiceNbr] [char](10) NOT NULL,
	[InvtId] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProcessDate] [smalldatetime] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Rebill] [smallint] NOT NULL,
	[RebillDate] [smalldatetime] NOT NULL,
	[Refnbr] [char](10) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Status] [char](1) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
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
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [AccruedtoGl]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [AmtApplied]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [ARBatNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [ARRefNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [BillDate]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [BranchID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Contractid]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [InvBatNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [InvoiceLineID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [InvoiceNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [InvtId]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [ProcessDate]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [ProjectID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [Rebill]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [RebillDate]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Refnbr]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [TaskID]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[smConDeposit] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
