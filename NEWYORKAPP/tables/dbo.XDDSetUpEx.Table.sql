USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[XDDSetUpEx]    Script Date: 12/21/2015 16:00:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDSetUpEx](
	[AcctApp] [smallint] NOT NULL,
	[ACHOrigDFI] [char](9) NOT NULL,
	[ACHOrigDFIName] [char](35) NOT NULL,
	[APAmtAppLvl1Amt] [float] NOT NULL,
	[APAmtAppLvl1NbrA] [smallint] NOT NULL,
	[APAmtAppLvl2Amt] [float] NOT NULL,
	[APAmtAppLvl2NbrA] [smallint] NOT NULL,
	[APAmtAppUserSetsApp] [char](47) NOT NULL,
	[APAPO] [smallint] NOT NULL,
	[APAPOComm] [smallint] NOT NULL,
	[APAPOFileNbrg] [smallint] NOT NULL,
	[APAPONextFileNbr] [char](6) NOT NULL,
	[APAPOPreNotesOne] [smallint] NOT NULL,
	[APEFTNoOrphanChk] [smallint] NOT NULL,
	[APEFTPrintAudit] [smallint] NOT NULL,
	[APEFTPrintAuditChg] [smallint] NOT NULL,
	[APEMAttachByA] [smallint] NOT NULL,
	[APEMAttachByV] [smallint] NOT NULL,
	[APEMAttachFExt] [char](10) NOT NULL,
	[APEMAttachFF] [char](1) NOT NULL,
	[APEMAttachFN] [char](50) NOT NULL,
	[APEMAttachFND] [smallint] NOT NULL,
	[APEMAttachFNI] [smallint] NOT NULL,
	[APEMAttachFNote] [char](100) NOT NULL,
	[APEMAttachFRL] [smallint] NOT NULL,
	[APEMAttachInclBMsg] [smallint] NOT NULL,
	[APEMAttachInclTMsg] [smallint] NOT NULL,
	[APEMAttachNbrDocs] [smallint] NOT NULL,
	[APEMAttachSP] [char](50) NOT NULL,
	[APEMAttachUse] [smallint] NOT NULL,
	[APFileHideCompBatch] [smallint] NOT NULL,
	[APFileNameAddDate] [smallint] NOT NULL,
	[APFileNameAddEBNbr] [smallint] NOT NULL,
	[APFileNameCanChange] [smallint] NOT NULL,
	[APFileNameConnector] [char](1) NOT NULL,
	[APFilePeriodsRet] [smallint] NOT NULL,
	[APGatewayOperID] [char](9) NOT NULL,
	[APShowPosted] [smallint] NOT NULL,
	[AREFTNoOrphanChk] [smallint] NOT NULL,
	[AREFTPrintAudit] [smallint] NOT NULL,
	[AREFTPrintAuditChg] [smallint] NOT NULL,
	[AREMAttachByA] [smallint] NOT NULL,
	[AREMAttachByC] [smallint] NOT NULL,
	[AREMAttachFExt] [char](10) NOT NULL,
	[AREMAttachFF] [char](1) NOT NULL,
	[AREMAttachFN] [char](50) NOT NULL,
	[AREMAttachFND] [smallint] NOT NULL,
	[AREMAttachFNI] [smallint] NOT NULL,
	[AREMAttachFNote] [char](100) NOT NULL,
	[AREMAttachFRL] [smallint] NOT NULL,
	[AREMAttachInclBMsg] [smallint] NOT NULL,
	[AREMAttachInclTMsg] [smallint] NOT NULL,
	[AREMAttachNbrDocs] [smallint] NOT NULL,
	[AREMAttachSP] [char](50) NOT NULL,
	[AREMAttachUse] [smallint] NOT NULL,
	[ARFileHideCompBatch] [smallint] NOT NULL,
	[ARFileNameAddDate] [smallint] NOT NULL,
	[ARFileNameAddEBNbr] [smallint] NOT NULL,
	[ARFileNameCanChange] [smallint] NOT NULL,
	[ARFileNameConnector] [char](1) NOT NULL,
	[ARFilePeriodsRet] [smallint] NOT NULL,
	[ARNextFileNbr] [char](6) NOT NULL,
	[ARShowPosted] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LBAddMissingCM] [smallint] NOT NULL,
	[LBAlwaysApplyDisc] [smallint] NOT NULL,
	[LBErrorShowChgdPmt] [smallint] NOT NULL,
	[LBFilePeriodsRet] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PPFileHideCompBatch] [smallint] NOT NULL,
	[PPFileNameAddDate] [smallint] NOT NULL,
	[PPFileNameAddEBNbr] [smallint] NOT NULL,
	[PPFileNameCanChange] [smallint] NOT NULL,
	[PPFileNameConnector] [char](1) NOT NULL,
	[PPFilePeriodsRet] [smallint] NOT NULL,
	[PPNextFileNbr] [char](6) NOT NULL,
	[PPShowPosted] [smallint] NOT NULL,
	[SecurityMsgOff] [smallint] NOT NULL,
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
	[WTDefaultOrdParty] [smallint] NOT NULL,
	[WTFileNameAddDate] [smallint] NOT NULL,
	[WTFileNameAddEBNbr] [smallint] NOT NULL,
	[WTFileNameConnector] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDSetupEx0] PRIMARY KEY CLUSTERED 
(
	[SetUpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AcctApp]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [ACHOrigDFI]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [ACHOrigDFIName]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAmtAppLvl1Amt]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAmtAppLvl1NbrA]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAmtAppLvl2Amt]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAmtAppLvl2NbrA]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APAmtAppUserSetsApp]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAPO]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAPOComm]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAPOFileNbrg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APAPONextFileNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APAPOPreNotesOne]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEFTNoOrphanChk]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEFTPrintAudit]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEFTPrintAuditChg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachByA]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachByV]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APEMAttachFExt]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APEMAttachFF]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APEMAttachFN]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachFND]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachFNI]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APEMAttachFNote]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachFRL]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachInclBMsg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachInclTMsg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachNbrDocs]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APEMAttachSP]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APEMAttachUse]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APFileHideCompBatch]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APFileNameAddDate]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APFileNameAddEBNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APFileNameCanChange]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APFileNameConnector]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APFilePeriodsRet]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [APGatewayOperID]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [APShowPosted]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREFTNoOrphanChk]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREFTPrintAudit]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREFTPrintAuditChg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachByA]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachByC]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [AREMAttachFExt]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [AREMAttachFF]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [AREMAttachFN]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachFND]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachFNI]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [AREMAttachFNote]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachFRL]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachInclBMsg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachInclTMsg]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachNbrDocs]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [AREMAttachSP]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [AREMAttachUse]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [ARFileHideCompBatch]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [ARFileNameAddDate]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [ARFileNameAddEBNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [ARFileNameCanChange]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [ARFileNameConnector]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [ARFilePeriodsRet]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [ARNextFileNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [ARShowPosted]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [LBAddMissingCM]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [LBAlwaysApplyDisc]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [LBErrorShowChgdPmt]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [LBFilePeriodsRet]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [PPFileHideCompBatch]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [PPFileNameAddDate]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [PPFileNameAddEBNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [PPFileNameCanChange]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [PPFileNameConnector]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [PPFilePeriodsRet]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [PPNextFileNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [PPShowPosted]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SecurityMsgOff]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [SetUpID]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [WTDefaultOrdParty]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [WTFileNameAddDate]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ((0)) FOR [WTFileNameAddEBNbr]
GO
ALTER TABLE [dbo].[XDDSetUpEx] ADD  DEFAULT ('') FOR [WTFileNameConnector]
GO
