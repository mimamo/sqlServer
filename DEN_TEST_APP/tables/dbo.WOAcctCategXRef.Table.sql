USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[WOAcctCategXRef]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WOAcctCategXRef](
	[Acct] [char](16) NOT NULL,
	[Acct_Comp] [char](16) NOT NULL,
	[BOMCostClass] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUPd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OffsetAcct] [char](10) NOT NULL,
	[OffsetSub] [char](24) NOT NULL,
	[PrjExpense] [char](10) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[ScrapVarAcct] [char](10) NOT NULL,
	[ScrapVarSub] [char](24) NOT NULL,
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
	[VarAcct] [char](10) NOT NULL,
	[VarSub] [char](24) NOT NULL,
	[WIPAcct_Mfg] [char](10) NOT NULL,
	[WIPAcct_NonMfg] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_Acct]  DEFAULT (' ') FOR [Acct]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_Acct_Comp]  DEFAULT (' ') FOR [Acct_Comp]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_BOMCostClass]  DEFAULT (' ') FOR [BOMCostClass]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_Crtd_Time]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_LUPd_Time]  DEFAULT ('01/01/1900') FOR [LUPd_Time]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_OffsetAcct]  DEFAULT (' ') FOR [OffsetAcct]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_OffsetSub]  DEFAULT (' ') FOR [OffsetSub]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_PrjExpense]  DEFAULT (' ') FOR [PrjExpense]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_ScrapVarAcct]  DEFAULT (' ') FOR [ScrapVarAcct]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_ScrapVarSub]  DEFAULT (' ') FOR [ScrapVarSub]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User10]  DEFAULT (' ') FOR [User10]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_User9]  DEFAULT (' ') FOR [User9]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_VarAcct]  DEFAULT (' ') FOR [VarAcct]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_VarSub]  DEFAULT (' ') FOR [VarSub]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_WIPAcct_Mfg]  DEFAULT (' ') FOR [WIPAcct_Mfg]
GO
ALTER TABLE [dbo].[WOAcctCategXRef] ADD  CONSTRAINT [DF_WOAcctCategXRef_WIPAcct_NonMfg]  DEFAULT (' ') FOR [WIPAcct_NonMfg]
GO
