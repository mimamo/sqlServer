USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[XDDSetUp]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDSetUp](
	[ACHCompanyID] [char](30) NOT NULL,
	[ACHCompanyName] [char](30) NOT NULL,
	[ACHCrLf] [char](1) NOT NULL,
	[ACHDelete] [char](1) NOT NULL,
	[ACHEntryClass] [char](4) NOT NULL,
	[ACHFileIDModifier] [char](1) NOT NULL,
	[ACHFileName] [char](80) NOT NULL,
	[ACHFillBlock] [char](1) NOT NULL,
	[ACHImmDest] [char](30) NOT NULL,
	[ACHImmDestN] [char](30) NOT NULL,
	[ACHImmOrig] [char](30) NOT NULL,
	[ACHImmOrigN] [char](30) NOT NULL,
	[ACHInclDR] [char](1) NOT NULL,
	[ACHInclDROverRide] [smallint] NOT NULL,
	[ACHPreNote] [char](1) NOT NULL,
	[ACHRecord] [char](1) NOT NULL,
	[ACHTPZeroDollar] [char](1) NOT NULL,
	[APArchive] [smallint] NOT NULL,
	[APArchiveNbr] [smallint] NOT NULL,
	[APSetPmtMethod] [smallint] NOT NULL,
	[ARACHDelete] [char](1) NOT NULL,
	[ARACHEntryClass] [char](4) NOT NULL,
	[ARACHFileName] [char](80) NOT NULL,
	[ARACHInclCR] [char](1) NOT NULL,
	[ARACHInclCROverRide] [smallint] NOT NULL,
	[ARACHPreNote] [char](1) NOT NULL,
	[ARACHRecord] [char](1) NOT NULL,
	[ARACHTPZeroDollar] [char](1) NOT NULL,
	[ARArchive] [smallint] NOT NULL,
	[ARArchiveNbr] [smallint] NOT NULL,
	[AREMARTran] [char](1) NOT NULL,
	[AREMAttachment] [char](128) NOT NULL,
	[AREMAutoWrap] [int] NOT NULL,
	[AREMCpnyName] [char](128) NOT NULL,
	[AREMFromAddr] [char](128) NOT NULL,
	[AREMFromName] [char](128) NOT NULL,
	[AREMMessageBottom] [smallint] NOT NULL,
	[AREMMessageTop] [smallint] NOT NULL,
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
	[ARHeadTrailID] [char](1) NOT NULL,
	[ARInvoicePrint] [char](1) NOT NULL,
	[ARPathACHScript] [char](128) NOT NULL,
	[ARPathArchive] [char](128) NOT NULL,
	[ARPmtBatchPrint] [smallint] NOT NULL,
	[ARPmtBatchStatus] [char](1) NOT NULL,
	[ARPmtNbr] [char](6) NOT NULL,
	[ARPmtNbrPrefix] [char](4) NOT NULL,
	[ARSelInvOptDocTerms] [smallint] NOT NULL,
	[ARSelInvOptEFTElig] [smallint] NOT NULL,
	[ARSetPmtMethod] [smallint] NOT NULL,
	[ARShowEFTBatches] [smallint] NOT NULL,
	[ARTermsID] [char](2) NOT NULL,
	[CommDevice] [char](128) NOT NULL,
	[CommEchoOn] [smallint] NOT NULL,
	[CommLocation] [char](128) NOT NULL,
	[CommPhone] [char](20) NOT NULL,
	[CommPXferProto] [smallint] NOT NULL,
	[CommSecProg] [char](128) NOT NULL,
	[CommService] [char](40) NOT NULL,
	[CommTermEmulation] [char](1) NOT NULL,
	[CommType] [char](1) NOT NULL,
	[CommUserProg] [char](128) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EMAPTran] [char](1) NOT NULL,
	[EMAttachment] [char](128) NOT NULL,
	[EMAutoWrap] [int] NOT NULL,
	[EMCpnyName] [char](128) NOT NULL,
	[EMFromAddr] [char](128) NOT NULL,
	[EMFromName] [char](128) NOT NULL,
	[EMHeaderContent] [smallint] NOT NULL,
	[EMHeaderDate] [smallint] NOT NULL,
	[EMHeaderFrom] [smallint] NOT NULL,
	[EMHeaderMessage] [smallint] NOT NULL,
	[EMMailLog] [smallint] NOT NULL,
	[EMMailPort] [int] NOT NULL,
	[EMMailServer] [char](128) NOT NULL,
	[EMMailTimeOut] [int] NOT NULL,
	[EMMessageBottom] [smallint] NOT NULL,
	[EMMessageTop] [smallint] NOT NULL,
	[EMPriority] [int] NOT NULL,
	[EMReplyToAddr] [char](128) NOT NULL,
	[EMReplyToName] [char](128) NOT NULL,
	[EMSSLMode] [int] NOT NULL,
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
	[ESMTPAccount] [char](30) NOT NULL,
	[ESMTPAuthMode] [int] NOT NULL,
	[ESMTPDoNotAppend] [smallint] NOT NULL,
	[ESMTPPassword] [char](30) NOT NULL,
	[ESMTPPipelining] [int] NOT NULL,
	[HeadTrailID] [char](1) NOT NULL,
	[IExplorePath] [char](128) NOT NULL,
	[Init] [char](1) NOT NULL,
	[LBApplicMethod] [char](2) NOT NULL,
	[LBArchive] [smallint] NOT NULL,
	[LBArchiveNbr] [smallint] NOT NULL,
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
	[LBMergeDataFile] [smallint] NOT NULL,
	[LBNextBatNbr] [char](6) NOT NULL,
	[LBOnlyFullApplyGood] [smallint] NOT NULL,
	[LBPath] [char](128) NOT NULL,
	[LBPathArchive] [char](128) NOT NULL,
	[LBPmtBatchPrint] [smallint] NOT NULL,
	[LBPmtBatchStatus] [char](1) NOT NULL,
	[LBPmtNbr] [char](6) NOT NULL,
	[LBPmtNbrPrefix] [char](4) NOT NULL,
	[LBSetPmtMethod] [smallint] NOT NULL,
	[LBSuggCustGood] [smallint] NOT NULL,
	[LBUseCheckDate] [smallint] NOT NULL,
	[LBViewIDError] [char](10) NOT NULL,
	[LBViewIDApplic] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[ModAPEFT] [char](1) NOT NULL,
	[ModAPEmail] [char](1) NOT NULL,
	[ModAREFT] [char](1) NOT NULL,
	[ModAREmail] [char](1) NOT NULL,
	[ModeBankSecurity] [smallint] NOT NULL,
	[ModFormatID] [char](15) NOT NULL,
	[ModLockbox] [char](1) NOT NULL,
	[ModLockboxFormatID] [char](15) NOT NULL,
	[ModMultiCompany] [char](1) NOT NULL,
	[ModMultiFormatID] [char](1) NOT NULL,
	[ModPosPay] [char](1) NOT NULL,
	[ModPosPayFormatID] [char](15) NOT NULL,
	[ModTestAP] [char](1) NOT NULL,
	[ModTestAR] [char](1) NOT NULL,
	[ModTestWire] [char](1) NOT NULL,
	[ModWire] [char](1) NOT NULL,
	[ModWireEmail] [char](1) NOT NULL,
	[PathACHScript] [char](128) NOT NULL,
	[PathArchiveAP] [char](128) NOT NULL,
	[PPAP] [smallint] NOT NULL,
	[PPAPCanChange] [smallint] NOT NULL,
	[PPAPVoid] [smallint] NOT NULL,
	[PPArchive] [smallint] NOT NULL,
	[PPArchiveNbr] [smallint] NOT NULL,
	[PPAuditRpt] [smallint] NOT NULL,
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
	[PPHeadTrailID] [char](1) NOT NULL,
	[PPPath] [char](128) NOT NULL,
	[PPPathArchive] [char](128) NOT NULL,
	[PPPR] [smallint] NOT NULL,
	[PPPRCanChange] [smallint] NOT NULL,
	[PPPRVoid] [smallint] NOT NULL,
	[PurgePeriodsAP] [smallint] NOT NULL,
	[PurgePeriodsAR] [smallint] NOT NULL,
	[RegAuthorizedUsers] [smallint] NOT NULL,
	[RegCustomerID] [char](10) NOT NULL,
	[RegOptions] [char](10) NOT NULL,
	[RegPlatform] [char](1) NOT NULL,
	[RegUnlockKey] [char](8) NOT NULL,
	[RegVersion] [char](10) NOT NULL,
	[SecDisbursement] [smallint] NOT NULL,
	[SecDSigner1Amt] [float] NOT NULL,
	[SecDSigner1PW] [char](30) NOT NULL,
	[SecDSigner2Amt] [float] NOT NULL,
	[SecDSigner2PW] [char](30) NOT NULL,
	[SecSeparation] [smallint] NOT NULL,
	[SetUpID] [char](2) NOT NULL,
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
	[WTArchive] [smallint] NOT NULL,
	[WTArchiveNbr] [smallint] NOT NULL,
	[WTCommType] [char](1) NOT NULL,
	[WTCommUserProg] [char](128) NOT NULL,
	[WTCrLf] [char](1) NOT NULL,
	[WTDelete] [char](1) NOT NULL,
	[WTFileName] [char](80) NOT NULL,
	[WTFillBlock] [char](1) NOT NULL,
	[WTHeadTrailID] [char](1) NOT NULL,
	[WTPath] [char](128) NOT NULL,
	[WTPathArchive] [char](128) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDSetup0] PRIMARY KEY CLUSTERED 
(
	[SetUpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [WTArchive]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ((0)) FOR [WTArchiveNbr]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTCommType]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTCommUserProg]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTCrLf]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTDelete]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTFileName]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTFillBlock]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTHeadTrailID]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTPath]
GO
ALTER TABLE [dbo].[XDDSetUp] ADD  DEFAULT ('') FOR [WTPathArchive]
GO
