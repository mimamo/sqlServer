USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[XPM_Step]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[XPM_Step](
	[ControlName] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[FunctionCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Parm1] [char](30) NOT NULL,
	[Parm2] [char](30) NOT NULL,
	[Parm3] [char](30) NOT NULL,
	[Parm4] [char](30) NOT NULL,
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
	[ScreenId] [char](7) NOT NULL,
	[ScriptId] [char](10) NOT NULL,
	[Statement] [char](200) NOT NULL,
	[StepId] [char](4) NOT NULL,
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
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [ControlName]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ('1/1/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [FunctionCode]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ('1/1/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Parm1]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Parm2]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Parm3]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Parm4]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ('1/1/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ('1/1/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [ScreenId]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [ScriptId]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [Statement]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [StepId]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ('1/1/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XPM_Step] ADD  DEFAULT ('1/1/1900') FOR [User8]
GO
