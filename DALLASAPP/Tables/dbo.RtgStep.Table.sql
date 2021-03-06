USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[RtgStep]    Script Date: 12/21/2015 13:44:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RtgStep](
	[ActStart] [smalldatetime] NOT NULL,
	[CCumDirLbrCst] [float] NOT NULL,
	[CCumDirOthCst] [float] NOT NULL,
	[CCumEngrLbrHrs] [float] NOT NULL,
	[CCumEngrLeadTime] [float] NOT NULL,
	[CCumEngrMachHrs] [float] NOT NULL,
	[CCumFOvhLbrCst] [float] NOT NULL,
	[CCumFOvhMachCst] [float] NOT NULL,
	[CCumStdCst] [float] NOT NULL,
	[CCumStdLbrHrs] [float] NOT NULL,
	[CCumStdLeadTime] [float] NOT NULL,
	[CCumStdMachHrs] [float] NOT NULL,
	[CCumStdYield] [float] NOT NULL,
	[CCumVOvhLbrCst] [float] NOT NULL,
	[CCumVOvhMachCst] [float] NOT NULL,
	[CDirLbrCst] [float] NOT NULL,
	[CDirOthCst] [float] NOT NULL,
	[CEngLbrHrs] [float] NOT NULL,
	[CEngLeadTime] [float] NOT NULL,
	[CEngMachHrs] [float] NOT NULL,
	[CEngMoveHrs] [float] NOT NULL,
	[CEngQueueHrs] [float] NOT NULL,
	[CFOvhLbrCst] [float] NOT NULL,
	[CFOvhMachCst] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CrewSize] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CStdCst] [float] NOT NULL,
	[CStdLbrHrs] [float] NOT NULL,
	[CStdLeadTime] [float] NOT NULL,
	[CStdMachHrs] [float] NOT NULL,
	[CStdMoveHrs] [float] NOT NULL,
	[CStdQueueHrs] [float] NOT NULL,
	[CStdYield] [float] NOT NULL,
	[CVOvhLbrCst] [float] NOT NULL,
	[CVOvhMachCst] [float] NOT NULL,
	[EngrChgOrder] [char](20) NOT NULL,
	[KitID] [char](30) NOT NULL,
	[LaborClassID] [char](10) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MachinID] [char](10) NOT NULL,
	[NbrMachines] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OperationID] [char](10) NOT NULL,
	[PCumDirLbrCst] [float] NOT NULL,
	[PCumDirOthCst] [float] NOT NULL,
	[PCumEngrLbrHrs] [float] NOT NULL,
	[PCumEngrLeadTime] [float] NOT NULL,
	[PCumEngrMachHrs] [float] NOT NULL,
	[PCumFOvhLbrCst] [float] NOT NULL,
	[PCumFOvhMachCst] [float] NOT NULL,
	[PCumStdCost] [float] NOT NULL,
	[PCumStdLbrHrs] [float] NOT NULL,
	[PCumStdLeadTime] [float] NOT NULL,
	[PCumStdMachHrs] [float] NOT NULL,
	[PCumStdYield] [float] NOT NULL,
	[PCumVOvhLbrCst] [float] NOT NULL,
	[PCumVOvhMachCst] [float] NOT NULL,
	[PDirLbrCst] [float] NOT NULL,
	[PDirOthCst] [float] NOT NULL,
	[PEngLbrHrs] [float] NOT NULL,
	[PEngLeadTime] [float] NOT NULL,
	[PEngMachHrs] [float] NOT NULL,
	[PEngMoveHrs] [float] NOT NULL,
	[PEngQueueHrs] [float] NOT NULL,
	[PEngYield] [float] NOT NULL,
	[PFOvhLbrCst] [float] NOT NULL,
	[PFOvhMachCst] [float] NOT NULL,
	[PStdCst] [float] NOT NULL,
	[PStdLbrHrs] [float] NOT NULL,
	[PStdLeadTime] [float] NOT NULL,
	[PStdMachHrs] [float] NOT NULL,
	[PStdMoveHrs] [float] NOT NULL,
	[PStdQueueHrs] [float] NOT NULL,
	[PStdYield] [float] NOT NULL,
	[PVOvhLbrCst] [float] NOT NULL,
	[PVOvhMachCst] [float] NOT NULL,
	[RtgStatus] [char](1) NOT NULL,
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
	[Status] [char](1) NOT NULL,
	[StepNbr] [char](5) NOT NULL,
	[ToolID1] [char](10) NOT NULL,
	[ToolID2] [char](10) NOT NULL,
	[ToolID3] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[WorkCenterID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_ActStart]  DEFAULT ('01/01/1900') FOR [ActStart]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumDirLbrCst]  DEFAULT ((0)) FOR [CCumDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumDirOthCst]  DEFAULT ((0)) FOR [CCumDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumEngrLbrHrs]  DEFAULT ((0)) FOR [CCumEngrLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumEngrLeadTime]  DEFAULT ((0)) FOR [CCumEngrLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumEngrMachHrs]  DEFAULT ((0)) FOR [CCumEngrMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumFOvhLbrCst]  DEFAULT ((0)) FOR [CCumFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumFOvhMachCst]  DEFAULT ((0)) FOR [CCumFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumStdCst]  DEFAULT ((0)) FOR [CCumStdCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumStdLbrHrs]  DEFAULT ((0)) FOR [CCumStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumStdLeadTime]  DEFAULT ((0)) FOR [CCumStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumStdMachHrs]  DEFAULT ((0)) FOR [CCumStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumStdYield]  DEFAULT ((0)) FOR [CCumStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumVOvhLbrCst]  DEFAULT ((0)) FOR [CCumVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CCumVOvhMachCst]  DEFAULT ((0)) FOR [CCumVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CDirLbrCst]  DEFAULT ((0)) FOR [CDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CDirOthCst]  DEFAULT ((0)) FOR [CDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CEngLbrHrs]  DEFAULT ((0)) FOR [CEngLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CEngLeadTime]  DEFAULT ((0)) FOR [CEngLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CEngMachHrs]  DEFAULT ((0)) FOR [CEngMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CEngMoveHrs]  DEFAULT ((0)) FOR [CEngMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CEngQueueHrs]  DEFAULT ((0)) FOR [CEngQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CFOvhLbrCst]  DEFAULT ((0)) FOR [CFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CFOvhMachCst]  DEFAULT ((0)) FOR [CFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CrewSize]  DEFAULT ((0)) FOR [CrewSize]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdCst]  DEFAULT ((0)) FOR [CStdCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdLbrHrs]  DEFAULT ((0)) FOR [CStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdLeadTime]  DEFAULT ((0)) FOR [CStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdMachHrs]  DEFAULT ((0)) FOR [CStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdMoveHrs]  DEFAULT ((0)) FOR [CStdMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdQueueHrs]  DEFAULT ((0)) FOR [CStdQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CStdYield]  DEFAULT ((0)) FOR [CStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CVOvhLbrCst]  DEFAULT ((0)) FOR [CVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_CVOvhMachCst]  DEFAULT ((0)) FOR [CVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_EngrChgOrder]  DEFAULT (' ') FOR [EngrChgOrder]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LaborClassID]  DEFAULT (' ') FOR [LaborClassID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_MachinID]  DEFAULT (' ') FOR [MachinID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_NbrMachines]  DEFAULT ((0)) FOR [NbrMachines]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_OperationID]  DEFAULT (' ') FOR [OperationID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumDirLbrCst]  DEFAULT ((0)) FOR [PCumDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumDirOthCst]  DEFAULT ((0)) FOR [PCumDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumEngrLbrHrs]  DEFAULT ((0)) FOR [PCumEngrLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumEngrLeadTime]  DEFAULT ((0)) FOR [PCumEngrLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumEngrMachHrs]  DEFAULT ((0)) FOR [PCumEngrMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumFOvhLbrCst]  DEFAULT ((0)) FOR [PCumFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumFOvhMachCst]  DEFAULT ((0)) FOR [PCumFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumStdCost]  DEFAULT ((0)) FOR [PCumStdCost]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumStdLbrHrs]  DEFAULT ((0)) FOR [PCumStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumStdLeadTime]  DEFAULT ((0)) FOR [PCumStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumStdMachHrs]  DEFAULT ((0)) FOR [PCumStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumStdYield]  DEFAULT ((0)) FOR [PCumStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumVOvhLbrCst]  DEFAULT ((0)) FOR [PCumVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PCumVOvhMachCst]  DEFAULT ((0)) FOR [PCumVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PDirLbrCst]  DEFAULT ((0)) FOR [PDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PDirOthCst]  DEFAULT ((0)) FOR [PDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PEngLbrHrs]  DEFAULT ((0)) FOR [PEngLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PEngLeadTime]  DEFAULT ((0)) FOR [PEngLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PEngMachHrs]  DEFAULT ((0)) FOR [PEngMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PEngMoveHrs]  DEFAULT ((0)) FOR [PEngMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PEngQueueHrs]  DEFAULT ((0)) FOR [PEngQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PEngYield]  DEFAULT ((0)) FOR [PEngYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PFOvhLbrCst]  DEFAULT ((0)) FOR [PFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PFOvhMachCst]  DEFAULT ((0)) FOR [PFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdCst]  DEFAULT ((0)) FOR [PStdCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdLbrHrs]  DEFAULT ((0)) FOR [PStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdLeadTime]  DEFAULT ((0)) FOR [PStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdMachHrs]  DEFAULT ((0)) FOR [PStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdMoveHrs]  DEFAULT ((0)) FOR [PStdMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdQueueHrs]  DEFAULT ((0)) FOR [PStdQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PStdYield]  DEFAULT ((0)) FOR [PStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PVOvhLbrCst]  DEFAULT ((0)) FOR [PVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_PVOvhMachCst]  DEFAULT ((0)) FOR [PVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_RtgStatus]  DEFAULT (' ') FOR [RtgStatus]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_StepNbr]  DEFAULT (' ') FOR [StepNbr]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_ToolID1]  DEFAULT (' ') FOR [ToolID1]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_ToolID2]  DEFAULT (' ') FOR [ToolID2]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_ToolID3]  DEFAULT (' ') FOR [ToolID3]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_VendID]  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  CONSTRAINT [DF_RtgStep_WorkCenterID]  DEFAULT (' ') FOR [WorkCenterID]
GO
