USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[Kit]    Script Date: 12/21/2015 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Kit](
	[BomType] [char](1) NOT NULL,
	[CDirLbrCst] [float] NOT NULL,
	[CDirMatlCst] [float] NOT NULL,
	[CDirOthCst] [float] NOT NULL,
	[CFOvhLbrCst] [float] NOT NULL,
	[CFOvhMachCst] [float] NOT NULL,
	[CFOvhMatlCst] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CStdCst] [float] NOT NULL,
	[CVOvhLbrCst] [float] NOT NULL,
	[CVOvhMachCst] [float] NOT NULL,
	[CVOvhMatlCst] [float] NOT NULL,
	[Descr] [char](60) NOT NULL,
	[Drawing] [char](15) NOT NULL,
	[EngrChgOrder] [char](20) NOT NULL,
	[ExpKitDet] [smallint] NOT NULL,
	[ExplodeFlg] [char](1) NOT NULL,
	[KitID] [char](30) NOT NULL,
	[KitType] [char](1) NOT NULL,
	[LevelNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PC_Status] [char](1) NOT NULL,
	[PDirLbrCst] [float] NOT NULL,
	[PDirMatlCst] [float] NOT NULL,
	[PDirOthCst] [float] NOT NULL,
	[PFOvhLbrCst] [float] NOT NULL,
	[PFOvhMachCst] [float] NOT NULL,
	[PFOvhMatlCst] [float] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[PStdCst] [float] NOT NULL,
	[PVOvhLbrCst] [float] NOT NULL,
	[PVOvhMachCst] [float] NOT NULL,
	[PVOvhMatlCst] [float] NOT NULL,
	[Revision] [char](10) NOT NULL,
	[RtgExist] [char](1) NOT NULL,
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
	[StockUsage] [char](1) NOT NULL,
	[StopDate] [smalldatetime] NOT NULL,
	[SupersededBy] [char](30) NOT NULL,
	[Supersedes] [char](30) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VarAcct] [char](10) NOT NULL,
	[VarSub] [char](24) NOT NULL,
	[WONbr] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Kit0] PRIMARY KEY CLUSTERED 
(
	[KitID] ASC,
	[SiteID] ASC,
	[Status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_BomType]  DEFAULT (' ') FOR [BomType]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CDirLbrCst]  DEFAULT ((0)) FOR [CDirLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CDirMatlCst]  DEFAULT ((0)) FOR [CDirMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CDirOthCst]  DEFAULT ((0)) FOR [CDirOthCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CFOvhLbrCst]  DEFAULT ((0)) FOR [CFOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CFOvhMachCst]  DEFAULT ((0)) FOR [CFOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CFOvhMatlCst]  DEFAULT ((0)) FOR [CFOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CStdCst]  DEFAULT ((0)) FOR [CStdCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CVOvhLbrCst]  DEFAULT ((0)) FOR [CVOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CVOvhMachCst]  DEFAULT ((0)) FOR [CVOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_CVOvhMatlCst]  DEFAULT ((0)) FOR [CVOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Drawing]  DEFAULT (' ') FOR [Drawing]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_EngrChgOrder]  DEFAULT (' ') FOR [EngrChgOrder]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_ExpKitDet]  DEFAULT ((0)) FOR [ExpKitDet]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_ExplodeFlg]  DEFAULT (' ') FOR [ExplodeFlg]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_KitType]  DEFAULT (' ') FOR [KitType]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_LevelNbr]  DEFAULT ((0)) FOR [LevelNbr]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PC_Status]  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PDirLbrCst]  DEFAULT ((0)) FOR [PDirLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PDirMatlCst]  DEFAULT ((0)) FOR [PDirMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PDirOthCst]  DEFAULT ((0)) FOR [PDirOthCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PFOvhLbrCst]  DEFAULT ((0)) FOR [PFOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PFOvhMachCst]  DEFAULT ((0)) FOR [PFOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PFOvhMatlCst]  DEFAULT ((0)) FOR [PFOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PStdCst]  DEFAULT ((0)) FOR [PStdCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PVOvhLbrCst]  DEFAULT ((0)) FOR [PVOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PVOvhMachCst]  DEFAULT ((0)) FOR [PVOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_PVOvhMatlCst]  DEFAULT ((0)) FOR [PVOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Revision]  DEFAULT (' ') FOR [Revision]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_RtgExist]  DEFAULT (' ') FOR [RtgExist]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_StartDate]  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_StockUsage]  DEFAULT (' ') FOR [StockUsage]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_StopDate]  DEFAULT ('01/01/1900') FOR [StopDate]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_SupersededBy]  DEFAULT (' ') FOR [SupersededBy]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_Supersedes]  DEFAULT (' ') FOR [Supersedes]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_VarAcct]  DEFAULT (' ') FOR [VarAcct]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_VarSub]  DEFAULT (' ') FOR [VarSub]
GO
ALTER TABLE [dbo].[Kit] ADD  CONSTRAINT [DF_Kit_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
