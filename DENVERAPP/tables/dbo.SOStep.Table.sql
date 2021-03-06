USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[SOStep]    Script Date: 12/21/2015 15:42:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOStep](
	[Auto] [smallint] NOT NULL,
	[AutoPgmClass] [char](4) NOT NULL,
	[AutoPgmID] [char](8) NOT NULL,
	[AutoProc] [char](30) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreditChk] [smallint] NOT NULL,
	[CreditChkProg] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[EventType] [char](4) NOT NULL,
	[FunctionClass] [char](4) NOT NULL,
	[FunctionID] [char](8) NOT NULL,
	[LanguageID] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[NotesOn] [smallint] NOT NULL,
	[Prompt] [char](40) NOT NULL,
	[RptProg] [smallint] NOT NULL,
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
	[Seq] [char](4) NOT NULL,
	[SkipTo] [char](4) NOT NULL,
	[SOTypeID] [char](4) NOT NULL,
	[Status] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Auto]  DEFAULT ((0)) FOR [Auto]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_AutoPgmClass]  DEFAULT (' ') FOR [AutoPgmClass]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_AutoPgmID]  DEFAULT (' ') FOR [AutoPgmID]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_AutoProc]  DEFAULT (' ') FOR [AutoProc]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_CreditChk]  DEFAULT ((0)) FOR [CreditChk]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_CreditChkProg]  DEFAULT ((0)) FOR [CreditChkProg]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_EventType]  DEFAULT (' ') FOR [EventType]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_FunctionClass]  DEFAULT (' ') FOR [FunctionClass]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_FunctionID]  DEFAULT (' ') FOR [FunctionID]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_LanguageID]  DEFAULT (' ') FOR [LanguageID]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_NotesOn]  DEFAULT ((0)) FOR [NotesOn]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Prompt]  DEFAULT (' ') FOR [Prompt]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_RptProg]  DEFAULT ((0)) FOR [RptProg]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Seq]  DEFAULT (' ') FOR [Seq]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_SkipTo]  DEFAULT (' ') FOR [SkipTo]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_SOTypeID]  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOStep] ADD  CONSTRAINT [DF_SOStep_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
