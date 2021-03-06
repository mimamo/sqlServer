USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[XDDBatch]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDBatch](
	[Acct] [char](10) NOT NULL,
	[AREFTInvoices] [smallint] NOT NULL,
	[AREFTFiltDiscDate] [smallint] NOT NULL,
	[AREFTFiltDiscDateD] [smalldatetime] NOT NULL,
	[AREFTFiltDueDate] [smallint] NOT NULL,
	[AREFTFiltDueDateD] [smalldatetime] NOT NULL,
	[AREFTFiltCM] [smallint] NOT NULL,
	[AREFTFiltDM] [smallint] NOT NULL,
	[AREFTFiltFI] [smallint] NOT NULL,
	[AREFTFiltIN] [smallint] NOT NULL,
	[AREFTTotal] [float] NOT NULL,
	[BatEFTGrp] [smallint] NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[BatSeq] [smallint] NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateReciprocal] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[DepDate] [smalldatetime] NOT NULL,
	[EBFileNbr] [char](6) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[FileType] [char](1) NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[KeepDelete] [char](1) NOT NULL,
	[LBPerPost] [char](6) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MCB_SettleDate] [char](20) NOT NULL,
	[MCB_SameDateOnly] [smallint] NOT NULL,
	[Module] [char](2) NOT NULL,
	[PmtTotal] [float] NOT NULL,
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
 CONSTRAINT [XDDBatch0] PRIMARY KEY CLUSTERED 
(
	[Module] ASC,
	[BatNbr] ASC,
	[FileType] ASC,
	[BatSeq] ASC,
	[BatEFTGrp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTInvoices]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTFiltDiscDate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [AREFTFiltDiscDateD]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTFiltDueDate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [AREFTFiltDueDateD]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTFiltCM]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTFiltDM]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTFiltFI]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTFiltIN]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [AREFTTotal]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [BatEFTGrp]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [BatSeq]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [ComputerName]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [CuryID]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [CuryRateReciprocal]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [DepDate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [EBFileNbr]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [FileType]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [KeepDelete]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [LBPerPost]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [MCB_SettleDate]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [MCB_SameDateOnly]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [Module]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [PmtTotal]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDBatch] ADD  DEFAULT ('') FOR [User9]
GO
