USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[Routing]    Script Date: 12/21/2015 14:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Routing](
	[CpnyID] [char](10) NOT NULL,
	[CRDirLbrCst] [float] NOT NULL,
	[CRDirOthCst] [float] NOT NULL,
	[CRFOvhLbrCst] [float] NOT NULL,
	[CRFOvhMachCst] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CRVOvhLbrCst] [float] NOT NULL,
	[CRVOvhMachCst] [float] NOT NULL,
	[CSDirLbrCst] [float] NOT NULL,
	[CSDirOthCst] [float] NOT NULL,
	[CSFOvhLbrCst] [float] NOT NULL,
	[CSFOvhMachCst] [float] NOT NULL,
	[CStdCst] [float] NOT NULL,
	[CSVOvhLbrCst] [float] NOT NULL,
	[CSVOvhMachCst] [float] NOT NULL,
	[Descr] [char](60) NOT NULL,
	[Drawing] [char](15) NOT NULL,
	[EngrChgOrder] [char](20) NOT NULL,
	[KitID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PRDirLbrCst] [float] NOT NULL,
	[PRDirOthCst] [float] NOT NULL,
	[PRFOvhLbrCst] [float] NOT NULL,
	[PRFOvhMachCst] [float] NOT NULL,
	[PRVOvhLbrCst] [float] NOT NULL,
	[PRVOvhMachCst] [float] NOT NULL,
	[PSDirLbrCst] [float] NOT NULL,
	[PSDirOthCst] [float] NOT NULL,
	[PSFOvhLbrCst] [float] NOT NULL,
	[PSFOvhMachCst] [float] NOT NULL,
	[PStdCst] [float] NOT NULL,
	[PSVOvhLbrCst] [float] NOT NULL,
	[PSVOvhMachCst] [float] NOT NULL,
	[Revision] [char](10) NOT NULL,
	[RTGType] [char](1) NOT NULL,
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
	[SiteID] [char](10) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[Status] [char](1) NOT NULL,
	[StdLeadTime] [float] NOT NULL,
	[StdLotSize] [float] NOT NULL,
	[StdYield] [float] NOT NULL,
	[StopDate] [smalldatetime] NOT NULL,
	[SupersededBy] [char](30) NOT NULL,
	[Supersedes] [char](30) NOT NULL,
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
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CRDirLbrCst]  DEFAULT ((0)) FOR [CRDirLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CRDirOthCst]  DEFAULT ((0)) FOR [CRDirOthCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CRFOvhLbrCst]  DEFAULT ((0)) FOR [CRFOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CRFOvhMachCst]  DEFAULT ((0)) FOR [CRFOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CRVOvhLbrCst]  DEFAULT ((0)) FOR [CRVOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CRVOvhMachCst]  DEFAULT ((0)) FOR [CRVOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CSDirLbrCst]  DEFAULT ((0)) FOR [CSDirLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CSDirOthCst]  DEFAULT ((0)) FOR [CSDirOthCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CSFOvhLbrCst]  DEFAULT ((0)) FOR [CSFOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CSFOvhMachCst]  DEFAULT ((0)) FOR [CSFOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CStdCst]  DEFAULT ((0)) FOR [CStdCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CSVOvhLbrCst]  DEFAULT ((0)) FOR [CSVOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_CSVOvhMachCst]  DEFAULT ((0)) FOR [CSVOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Drawing]  DEFAULT (' ') FOR [Drawing]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_EngrChgOrder]  DEFAULT (' ') FOR [EngrChgOrder]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PRDirLbrCst]  DEFAULT ((0)) FOR [PRDirLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PRDirOthCst]  DEFAULT ((0)) FOR [PRDirOthCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PRFOvhLbrCst]  DEFAULT ((0)) FOR [PRFOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PRFOvhMachCst]  DEFAULT ((0)) FOR [PRFOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PRVOvhLbrCst]  DEFAULT ((0)) FOR [PRVOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PRVOvhMachCst]  DEFAULT ((0)) FOR [PRVOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PSDirLbrCst]  DEFAULT ((0)) FOR [PSDirLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PSDirOthCst]  DEFAULT ((0)) FOR [PSDirOthCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PSFOvhLbrCst]  DEFAULT ((0)) FOR [PSFOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PSFOvhMachCst]  DEFAULT ((0)) FOR [PSFOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PStdCst]  DEFAULT ((0)) FOR [PStdCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PSVOvhLbrCst]  DEFAULT ((0)) FOR [PSVOvhLbrCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_PSVOvhMachCst]  DEFAULT ((0)) FOR [PSVOvhMachCst]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Revision]  DEFAULT (' ') FOR [Revision]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_RTGType]  DEFAULT (' ') FOR [RTGType]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_StartDate]  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_StdLeadTime]  DEFAULT ((0)) FOR [StdLeadTime]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_StdLotSize]  DEFAULT ((0)) FOR [StdLotSize]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_StdYield]  DEFAULT ((0)) FOR [StdYield]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_StopDate]  DEFAULT ('01/01/1900') FOR [StopDate]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_SupersededBy]  DEFAULT (' ') FOR [SupersededBy]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_Supersedes]  DEFAULT (' ') FOR [Supersedes]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Routing] ADD  CONSTRAINT [DF_Routing_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
