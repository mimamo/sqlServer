USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[XDDLBView]    Script Date: 12/21/2015 14:10:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDLBView](
	[AutoDisplay] [smallint] NOT NULL,
	[BalanceAD] [char](1) NOT NULL,
	[BalanceFrom] [float] NOT NULL,
	[BalanceOrd] [smallint] NOT NULL,
	[BalanceTo] [float] NOT NULL,
	[ClosedDoc] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CpnyIDAD] [char](1) NOT NULL,
	[CpnyIDOrd] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryIDAD] [char](1) NOT NULL,
	[CuryIDOrd] [smallint] NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustIDAD] [char](1) NOT NULL,
	[CustIDOrd] [smallint] NOT NULL,
	[CustName] [char](30) NOT NULL,
	[CustNameAD] [char](1) NOT NULL,
	[CustNameOrd] [smallint] NOT NULL,
	[CustOrdNbr] [char](15) NOT NULL,
	[CustOrdNbrAD] [char](1) NOT NULL,
	[CustOrdNbrOrd] [smallint] NOT NULL,
	[DateDiscAD] [char](1) NOT NULL,
	[DateDiscFrom] [smalldatetime] NOT NULL,
	[DateDiscOrd] [smallint] NOT NULL,
	[DateDiscTo] [smalldatetime] NOT NULL,
	[DateDiscType] [char](2) NOT NULL,
	[DateDocAD] [char](1) NOT NULL,
	[DateDocFrom] [smalldatetime] NOT NULL,
	[DateDocOrd] [smallint] NOT NULL,
	[DateDocTo] [smalldatetime] NOT NULL,
	[DateDocType] [char](2) NOT NULL,
	[DateDueAD] [char](1) NOT NULL,
	[DateDueFrom] [smalldatetime] NOT NULL,
	[DateDueOrd] [smallint] NOT NULL,
	[DateDueTo] [smalldatetime] NOT NULL,
	[DateDueType] [char](2) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[DocTypeAD] [char](1) NOT NULL,
	[DocType_CM] [smallint] NOT NULL,
	[DocType_DM] [smallint] NOT NULL,
	[DocType_FI] [smallint] NOT NULL,
	[DocType_IN] [smallint] NOT NULL,
	[DocType_PA] [smallint] NOT NULL,
	[DocTypeOrd] [smallint] NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[ExpLevel1] [char](2) NOT NULL,
	[ExpLevel2] [char](2) NOT NULL,
	[ExpLevel3] [char](2) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OpenDoc] [smallint] NOT NULL,
	[OpenDocAD] [char](1) NOT NULL,
	[OpenDocOrd] [smallint] NOT NULL,
	[OpenViewExpanded] [smallint] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[OrdNbrAD] [char](1) NOT NULL,
	[OrdNbrOrd] [smallint] NOT NULL,
	[PerPostAD] [char](1) NOT NULL,
	[PerPostFrom] [char](6) NOT NULL,
	[PerPostOrd] [smallint] NOT NULL,
	[PerPostTo] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProjectIDAD] [char](1) NOT NULL,
	[ProjectIDOrd] [smallint] NOT NULL,
	[RecordLimit] [int] NOT NULL,
	[RefNbrAD] [char](1) NOT NULL,
	[RefNbrFrom] [char](10) NOT NULL,
	[RefNbrOrd] [smallint] NOT NULL,
	[RefNbrTo] [char](10) NOT NULL,
	[Rlsed] [smallint] NOT NULL,
	[RlsedAD] [char](1) NOT NULL,
	[RlsedOrd] [smallint] NOT NULL,
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
	[TaskID] [char](32) NOT NULL,
	[TaskIDAD] [char](1) NOT NULL,
	[TaskIDOrd] [smallint] NOT NULL,
	[Terms] [char](2) NOT NULL,
	[TermsAD] [char](1) NOT NULL,
	[TermsOrd] [smallint] NOT NULL,
	[UnRlsed] [smallint] NOT NULL,
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
	[ViewID] [char](10) NOT NULL,
	[WhereClause] [char](200) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDLBView0] PRIMARY KEY CLUSTERED 
(
	[ViewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [AutoDisplay]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [BalanceAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [BalanceFrom]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [BalanceOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [BalanceTo]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [ClosedDoc]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CpnyIDAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [CpnyIDOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CuryID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CuryIDAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [CuryIDOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CustID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CustIDAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [CustIDOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CustName]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CustNameAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [CustNameOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CustOrdNbr]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [CustOrdNbrAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [CustOrdNbrOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DateDiscAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [DateDiscFrom]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DateDiscOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [DateDiscTo]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DateDiscType]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DateDocAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [DateDocFrom]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DateDocOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [DateDocTo]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DateDocType]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DateDueAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [DateDueFrom]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DateDueOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [DateDueTo]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DateDueType]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [DocTypeAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DocType_CM]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DocType_DM]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DocType_FI]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DocType_IN]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DocType_PA]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [DocTypeOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [EmpID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [ExpLevel1]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [ExpLevel2]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [ExpLevel3]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [LUpd_Time]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [OpenDoc]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [OpenDocAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [OpenDocOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [OpenViewExpanded]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [OrdNbrAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [OrdNbrOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [PerPostAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [PerPostFrom]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [PerPostOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [PerPostTo]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [ProjectID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [ProjectIDAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [ProjectIDOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [RecordLimit]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [RefNbrAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [RefNbrFrom]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [RefNbrOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [RefNbrTo]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [RlsedAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [RlsedOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [TaskID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [TaskIDAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [TaskIDOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [Terms]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [TermsAD]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [TermsOrd]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [UnRlsed]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [ViewID]
GO
ALTER TABLE [dbo].[XDDLBView] ADD  DEFAULT ('') FOR [WhereClause]
GO
