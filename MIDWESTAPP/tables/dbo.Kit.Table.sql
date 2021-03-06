USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[Kit]    Script Date: 12/21/2015 15:54:49 ******/
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
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [BomType]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CDirLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CDirMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CDirOthCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CFOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CFOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CFOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CStdCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CVOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CVOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [CVOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Drawing]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [EngrChgOrder]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [ExpKitDet]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [ExplodeFlg]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [KitType]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [LevelNbr]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [PC_Status]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PDirLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PDirMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PDirOthCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PFOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PFOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PFOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PStdCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PVOvhLbrCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PVOvhMachCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [PVOvhMatlCst]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Revision]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [RtgExist]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [StockUsage]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [StopDate]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [SupersededBy]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [Supersedes]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [VarAcct]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [VarSub]
GO
ALTER TABLE [dbo].[Kit] ADD  DEFAULT (' ') FOR [WONbr]
GO
