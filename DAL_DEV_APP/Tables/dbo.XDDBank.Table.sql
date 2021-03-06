USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[XDDBank]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDBank](
	[Acct] [char](10) NOT NULL,
	[AcctType] [char](1) NOT NULL,
	[ACHCompanyID] [char](30) NOT NULL,
	[ACHCompanyName] [char](30) NOT NULL,
	[ACHCrLf] [char](1) NOT NULL,
	[ACHDelete] [char](1) NOT NULL,
	[ACHFileIDModifier] [char](1) NOT NULL,
	[ACHFileName] [char](80) NOT NULL,
	[ACHFillBlock] [char](1) NOT NULL,
	[ACHImmDest] [char](30) NOT NULL,
	[ACHImmDestN] [char](30) NOT NULL,
	[ACHImmOrig] [char](30) NOT NULL,
	[ACHImmOrigN] [char](30) NOT NULL,
	[ACHInclDR] [char](1) NOT NULL,
	[ACHOrigDFI] [char](9) NOT NULL,
	[ACHOrigDFIName] [char](35) NOT NULL,
	[ACHPreNote] [char](1) NOT NULL,
	[ACHRecord] [char](1) NOT NULL,
	[ACHTPZeroDollar] [char](1) NOT NULL,
	[APArchive] [smallint] NOT NULL,
	[APAutoClear] [smallint] NOT NULL,
	[APFileFromSetup] [smallint] NOT NULL,
	[APGatewayOperID] [char](9) NOT NULL,
	[ARACHDelete] [char](1) NOT NULL,
	[ARACHFileName] [char](80) NOT NULL,
	[ARACHInclCR] [char](1) NOT NULL,
	[ARACHPreNote] [char](1) NOT NULL,
	[ARACHTPZeroDollar] [char](1) NOT NULL,
	[ARArchive] [smallint] NOT NULL,
	[AREMARTran] [char](1) NOT NULL,
	[AREMAttachment] [char](128) NOT NULL,
	[AREMAutoWrap] [int] NOT NULL,
	[AREMCpnyName] [char](128) NOT NULL,
	[AREMFromAddr] [char](128) NOT NULL,
	[AREMFromName] [char](128) NOT NULL,
	[AREMFromSetup] [smallint] NOT NULL,
	[AREMMessageBottom] [smallint] NOT NULL,
	[AREMMessageTop] [smallint] NOT NULL,
	[AREMNotification] [char](1) NOT NULL,
	[AREMPriority] [int] NOT NULL,
	[AREMReplyToAddr] [char](128) NOT NULL,
	[AREMReplyToName] [char](128) NOT NULL,
	[AREMStubLayout] [char](1) NOT NULL,
	[AREMSubject] [char](128) NOT NULL,
	[AREMTUser1] [char](30) NOT NULL,
	[AREMTUser2] [char](30) NOT NULL,
	[AREMTUser3] [char](30) NOT NULL,
	[AREMTUser4] [char](30) NOT NULL,
	[AREMTUser5] [char](30) NOT NULL,
	[AREMTUser6] [char](30) NOT NULL,
	[AREMTUser7] [char](30) NOT NULL,
	[AREMTUser8] [char](30) NOT NULL,
	[AREMUser1] [char](30) NOT NULL,
	[AREMUser2] [char](30) NOT NULL,
	[AREMUser3] [char](30) NOT NULL,
	[AREMUser4] [char](30) NOT NULL,
	[AREMUser5] [char](30) NOT NULL,
	[AREMUser6] [char](30) NOT NULL,
	[AREMUser7] [char](30) NOT NULL,
	[AREMUser8] [char](30) NOT NULL,
	[ARFileFromSetup] [smallint] NOT NULL,
	[ARHeadTrailID] [char](1) NOT NULL,
	[ARPathACHScript] [char](128) NOT NULL,
	[ARTest] [char](1) NOT NULL,
	[BankAcct] [char](30) NOT NULL,
	[BankTransit] [char](30) NOT NULL,
	[CommDevice] [char](128) NOT NULL,
	[CommEchoOn] [smallint] NOT NULL,
	[CommLocation] [char](128) NOT NULL,
	[CommPhone] [char](20) NOT NULL,
	[CommPXferProto] [smallint] NOT NULL,
	[CommSecProg] [char](128) NOT NULL,
	[CommTermEmulation] [char](1) NOT NULL,
	[CommType] [char](1) NOT NULL,
	[CommUserProg] [char](128) NOT NULL,
	[CompanyIDCCD] [char](10) NOT NULL,
	[CompanyIDCCDP] [char](10) NOT NULL,
	[CompanyIDCCDT] [char](10) NOT NULL,
	[CompanyIDCTX] [char](10) NOT NULL,
	[CompanyIDIAT] [char](10) NOT NULL,
	[CompanyIDPPD] [char](10) NOT NULL,
	[CompanyIDUnique] [smallint] NOT NULL,
	[CompEntryDescCCD] [char](16) NOT NULL,
	[CompEntryDescCCDP] [char](16) NOT NULL,
	[CompEntryDescCCDT] [char](16) NOT NULL,
	[CompEntryDescCTX] [char](16) NOT NULL,
	[CompEntryDescIAT] [char](16) NOT NULL,
	[CompEntryDescPPD] [char](16) NOT NULL,
	[CpnyFromSetup] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EMAPTran] [char](1) NOT NULL,
	[EMAttachment] [char](128) NOT NULL,
	[EMAutoWrap] [int] NOT NULL,
	[EMCpnyName] [char](128) NOT NULL,
	[EMFromAddr] [char](128) NOT NULL,
	[EMFromName] [char](128) NOT NULL,
	[EMFromSetup] [smallint] NOT NULL,
	[EMMessageBottom] [smallint] NOT NULL,
	[EMMessageTop] [smallint] NOT NULL,
	[EMNotification] [char](1) NOT NULL,
	[EMPriority] [int] NOT NULL,
	[EMReplyToAddr] [char](128) NOT NULL,
	[EMReplyToName] [char](128) NOT NULL,
	[EMStubLayout] [char](1) NOT NULL,
	[EMSubject] [char](128) NOT NULL,
	[EMTUser1] [char](30) NOT NULL,
	[EMTUser2] [char](30) NOT NULL,
	[EMTUser3] [char](30) NOT NULL,
	[EMTUser4] [char](30) NOT NULL,
	[EMTUser5] [char](30) NOT NULL,
	[EMTUser6] [char](30) NOT NULL,
	[EMTUser7] [char](30) NOT NULL,
	[EMTUser8] [char](30) NOT NULL,
	[EMUser1] [char](30) NOT NULL,
	[EMUser2] [char](30) NOT NULL,
	[EMUser3] [char](30) NOT NULL,
	[EMUser4] [char](30) NOT NULL,
	[EMUser5] [char](30) NOT NULL,
	[EMUser6] [char](30) NOT NULL,
	[EMUser7] [char](30) NOT NULL,
	[EMUser8] [char](30) NOT NULL,
	[FileFromSetup] [smallint] NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[HeadTrailID] [char](1) NOT NULL,
	[LBArchive] [smallint] NOT NULL,
	[LBCommDevice] [char](128) NOT NULL,
	[LBCommEchoOn] [smallint] NOT NULL,
	[LBCommLocation] [char](128) NOT NULL,
	[LBCommPhone] [char](20) NOT NULL,
	[LBCommPXferProto] [smallint] NOT NULL,
	[LBCommTermEmulation] [char](1) NOT NULL,
	[LBCommType] [char](1) NOT NULL,
	[LBCommUserProg] [char](128) NOT NULL,
	[LBDelete] [char](1) NOT NULL,
	[LBFileName] [char](80) NOT NULL,
	[LBFormatID] [char](15) NOT NULL,
	[LBFromSetup] [smallint] NOT NULL,
	[LBPath] [char](128) NOT NULL,
	[LBSuggCustGood] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MCB_EBNbrLen] [smallint] NOT NULL,
	[MCB_EBNbrPrefix] [char](2) NOT NULL,
	[MCB_NextEBNbr] [char](10) NOT NULL,
	[MCB_UseEBNbr] [smallint] NOT NULL,
	[Name] [char](30) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PathACHScript] [char](128) NOT NULL,
	[PNDate] [smalldatetime] NOT NULL,
	[PNStatus] [char](1) NOT NULL,
	[PP01] [char](30) NOT NULL,
	[PP02] [char](30) NOT NULL,
	[PP03] [char](30) NOT NULL,
	[PP04] [char](30) NOT NULL,
	[PPArchive] [smallint] NOT NULL,
	[PPCommDevice] [char](128) NOT NULL,
	[PPCommEchoOn] [smallint] NOT NULL,
	[PPCommLocation] [char](128) NOT NULL,
	[PPCommPhone] [char](20) NOT NULL,
	[PPCommPXferProto] [smallint] NOT NULL,
	[PPCommTermEmulation] [char](1) NOT NULL,
	[PPCommType] [char](1) NOT NULL,
	[PPCommUserProg] [char](128) NOT NULL,
	[PPCrLf] [char](1) NOT NULL,
	[PPDelete] [char](1) NOT NULL,
	[PPFileName] [char](80) NOT NULL,
	[PPFillBlock] [char](1) NOT NULL,
	[PPFormatID] [char](15) NOT NULL,
	[PPFromSetup] [smallint] NOT NULL,
	[PPHeadTrailID] [char](1) NOT NULL,
	[PPPath] [char](128) NOT NULL,
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
	[Test] [char](1) NOT NULL,
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
	[W01] [char](35) NOT NULL,
	[W02] [char](35) NOT NULL,
	[W03] [char](35) NOT NULL,
	[W04] [char](35) NOT NULL,
	[WOrdPartyAddr] [char](35) NOT NULL,
	[WOrdPartyAddr2] [char](35) NOT NULL,
	[WOrdPartyCity] [char](35) NOT NULL,
	[WOrdPartyCountry] [char](35) NOT NULL,
	[WOrdPartyID] [char](15) NOT NULL,
	[WOrdPartyISOCntry] [char](3) NOT NULL,
	[WOrdPartyName] [char](35) NOT NULL,
	[WOrdPartyState] [char](3) NOT NULL,
	[WOrdPartySwift] [char](11) NOT NULL,
	[WOrdPartyZipPostal] [char](11) NOT NULL,
	[WTArchive] [smallint] NOT NULL,
	[WTCommType] [char](1) NOT NULL,
	[WTCommUserProg] [char](128) NOT NULL,
	[WTCrLf] [char](1) NOT NULL,
	[WTDelete] [char](1) NOT NULL,
	[WTFileName] [char](80) NOT NULL,
	[WTFillBlock] [char](1) NOT NULL,
	[WTFilterMultiCury] [smallint] NOT NULL,
	[WTFromSetup] [smallint] NOT NULL,
	[WTHeadTrailID] [char](1) NOT NULL,
	[WTPath] [char](128) NOT NULL,
	[WTTest] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDBank0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[Acct] ASC,
	[Sub] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [ARTest]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [MCB_EBNbrLen]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [MCB_EBNbrPrefix]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [MCB_NextEBNbr]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [MCB_UseEBNbr]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [Test]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [W01]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [W02]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [W03]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [W04]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyAddr]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyAddr2]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyCity]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyCountry]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyID]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyISOCntry]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyName]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyState]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartySwift]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WOrdPartyZipPostal]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [WTArchive]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTCommType]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTCommUserProg]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTCrLf]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTDelete]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTFileName]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTFillBlock]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [WTFilterMultiCury]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ((0)) FOR [WTFromSetup]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTHeadTrailID]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTPath]
GO
ALTER TABLE [dbo].[XDDBank] ADD  DEFAULT ('') FOR [WTTest]
GO
