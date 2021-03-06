USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[XDDTxnType]    Script Date: 12/21/2015 14:33:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDTxnType](
	[AutoClear] [smallint] NOT NULL,
	[BEAcctInfoABAReqd] [smallint] NOT NULL,
	[BEAcctInfoAcctReqd] [smallint] NOT NULL,
	[BEAcctInfoWireUsed] [smallint] NOT NULL,
	[BEBeneAcctReqd] [smallint] NOT NULL,
	[BEBeneBankAcctReqd] [smallint] NOT NULL,
	[BEReqd01] [smallint] NOT NULL,
	[BEReqd02] [smallint] NOT NULL,
	[BEUse01] [smallint] NOT NULL,
	[BEUse02] [smallint] NOT NULL,
	[ChkWF] [char](1) NOT NULL,
	[ChkWF_CreateMCB] [char](1) NOT NULL,
	[ChkWF_SameDate] [smallint] NOT NULL,
	[ChkWF_UpdateMCB] [char](2) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DefaultCust] [smallint] NOT NULL,
	[DefaultVend] [smallint] NOT NULL,
	[Descr] [char](45) NOT NULL,
	[DescrShort] [char](10) NOT NULL,
	[DocPerRecord] [char](1) NOT NULL,
	[EmailNote] [char](20) NOT NULL,
	[EntryClass] [char](4) NOT NULL,
	[EntryClassDescr] [char](20) NOT NULL,
	[EntryClassDescrAR] [char](20) NOT NULL,
	[EStatus] [char](1) NOT NULL,
	[FilterSeparateFile] [smallint] NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Selected] [char](1) NOT NULL,
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
	[TxnCpnyIDName] [smallint] NOT NULL,
	[TxnCustUse] [smallint] NOT NULL,
	[TxnEmailOff] [smallint] NOT NULL,
	[TxnNACHA] [smallint] NOT NULL,
	[TxnPreNote] [smallint] NOT NULL,
	[TxnType] [char](10) NOT NULL,
	[TxnVendUse] [smallint] NOT NULL,
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
	[WireTabs] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDTxnType0] PRIMARY KEY CLUSTERED 
(
	[FormatID] ASC,
	[EntryClass] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [AutoClear]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [BEAcctInfoABAReqd]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [BEAcctInfoAcctReqd]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [BEAcctInfoWireUsed]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [BEBeneAcctReqd]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [BEBeneBankAcctReqd]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [BEReqd01]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [BEReqd02]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [BEUse01]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [BEUse02]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [ChkWF]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [ChkWF_CreateMCB]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [ChkWF_SameDate]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [ChkWF_UpdateMCB]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [DefaultCust]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [DefaultVend]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [DescrShort]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [DocPerRecord]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [EmailNote]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [EntryClass]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [EntryClassDescr]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [EntryClassDescrAR]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [EStatus]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [FilterSeparateFile]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [Selected]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [TxnCpnyIDName]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [TxnCustUse]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [TxnEmailOff]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [TxnNACHA]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [TxnPreNote]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [TxnType]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [TxnVendUse]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDTxnType] ADD  DEFAULT ((0)) FOR [WireTabs]
GO
