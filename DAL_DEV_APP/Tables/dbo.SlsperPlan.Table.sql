USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[SlsperPlan]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SlsperPlan](
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PlanID] [char](10) NOT NULL,
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
	[SlsperID] [char](10) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
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
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_CpnyId]  DEFAULT (' ') FOR [CpnyId]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_EndDate]  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_PlanID]  DEFAULT (' ') FOR [PlanID]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_SlsperID]  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_StartDate]  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SlsperPlan] ADD  CONSTRAINT [DF_SlsperPlan_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
