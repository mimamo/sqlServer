USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[CSPlan]    Script Date: 12/21/2015 15:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSPlan](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[LevelBasis] [char](1) NOT NULL,
	[LevelBasisAccum] [smallint] NOT NULL,
	[LevelPerType] [char](1) NOT NULL,
	[LevelType] [char](1) NOT NULL,
	[LineCntr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PctEarnBook] [float] NOT NULL,
	[PctEarnInvc] [float] NOT NULL,
	[PctEarnOther] [float] NOT NULL,
	[PctEarnPmt] [float] NOT NULL,
	[PctEarnShip] [float] NOT NULL,
	[PlanID] [char](10) NOT NULL,
	[Prorated] [smallint] NOT NULL,
	[RowOption] [char](1) NOT NULL,
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
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [LevelBasis]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [LevelBasisAccum]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [LevelPerType]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [LevelType]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [LineCntr]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [PctEarnBook]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [PctEarnInvc]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [PctEarnOther]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [PctEarnPmt]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [PctEarnShip]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [PlanID]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [Prorated]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [RowOption]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[CSPlan] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
