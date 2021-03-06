USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[XDDBatchARLB]    Script Date: 12/21/2015 13:44:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDBatchARLB](
	[Acct] [char](10) NOT NULL,
	[Amount] [float] NOT NULL,
	[AmountApplied] [float] NOT NULL,
	[ApplicMethod] [char](2) NOT NULL,
	[BankAcct] [char](30) NOT NULL,
	[BankTransit] [char](30) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CpnyIDInv] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustIDErr] [char](1) NOT NULL,
	[CustIDSugg] [char](15) NOT NULL,
	[CustName] [char](30) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DocDate] [smalldatetime] NOT NULL,
	[DocType] [char](2) NOT NULL,
	[FileDate] [smalldatetime] NOT NULL,
	[FilePathName] [char](120) NOT NULL,
	[FileRecord] [smallint] NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[InvApplyAmt] [float] NOT NULL,
	[InvcLeftUnappl] [smallint] NOT NULL,
	[InvcNbr] [char](10) NOT NULL,
	[InvcNbrErr] [char](1) NOT NULL,
	[LBBatNbr] [char](10) NOT NULL,
	[LBCustID] [char](15) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PmtApplicBatNbr] [char](10) NOT NULL,
	[PmtApplicRefNbr] [char](10) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[RefNbr] [char](10) NOT NULL,
	[RefNbrDupe] [smallint] NOT NULL,
	[SKFuture01] [char](30) NOT NULL,
	[SKFuture02] [char](30) NOT NULL,
	[SKFuture03] [float] NOT NULL,
	[SKFuture04] [float] NOT NULL,
	[SKFuture05] [float] NOT NULL,
	[SKFuture06] [float] NOT NULL,
	[SKFuture07] [smalldatetime] NOT NULL,
	[SKFuture08] [smalldatetime] NOT NULL,
	[SKFuture09] [int] NOT NULL,
	[SKFuture10] [int] NOT NULL,
	[SKFuture11] [char](10) NOT NULL,
	[SKFuture12] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TotalRemBal] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDBatchARLB0] PRIMARY KEY CLUSTERED 
(
	[LBBatNbr] ASC,
	[CustID] ASC,
	[LineNbr] ASC,
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [AmountApplied]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [ApplicMethod]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [BankAcct]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [BankTransit]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CpnyIDInv]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CuryID]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CustID]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CustIDErr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CustIDSugg]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [CustName]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [DocDate]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [DocType]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [FileDate]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [FilePathName]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [FileRecord]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [InvApplyAmt]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [InvcLeftUnappl]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [InvcNbrErr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [LBBatNbr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [LBCustID]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [PmtApplicBatNbr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [PmtApplicRefNbr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [RefNbrDupe]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [TotalRemBal]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDBatchARLB] ADD  DEFAULT ('') FOR [User9]
GO
