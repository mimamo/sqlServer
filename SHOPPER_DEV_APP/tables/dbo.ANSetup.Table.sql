USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[ANSetup]    Script Date: 12/21/2015 14:33:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ANSetup](
	[Active] [smallint] NOT NULL,
	[AutoBOL] [smallint] NOT NULL,
	[AutoContainer] [smallint] NOT NULL,
	[AutoLabel] [smallint] NOT NULL,
	[CalcDim] [smallint] NOT NULL,
	[CalcWeight] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Inbound945Path] [char](255) NOT NULL,
	[LabelAtRelease] [smallint] NOT NULL,
	[LabelDbPath] [char](255) NOT NULL,
	[LabelSoftPath] [char](255) NOT NULL,
	[LastBOL] [char](20) NOT NULL,
	[LastLabelNbr] [char](10) NOT NULL,
	[LastSerContainer] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MatchShipQty] [smallint] NOT NULL,
	[MfgID] [char](20) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PrintOnSave] [smallint] NOT NULL,
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
	[SetupID] [char](2) NOT NULL,
	[SingleContainer] [smallint] NOT NULL,
	[StdCartonBreak] [smallint] NOT NULL,
	[TreeView] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [AutoBOL]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [AutoContainer]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [AutoLabel]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [CalcDim]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [CalcWeight]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [Inbound945Path]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [LabelAtRelease]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [LabelDbPath]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [LabelSoftPath]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [LastBOL]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [LastLabelNbr]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [LastSerContainer]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [MatchShipQty]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [MfgID]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [PrintOnSave]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [SingleContainer]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [StdCartonBreak]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [TreeView]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ANSetup] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
