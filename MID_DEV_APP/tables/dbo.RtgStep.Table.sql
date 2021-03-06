USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[RtgStep]    Script Date: 12/21/2015 14:16:55 ******/
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
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ('01/01/1900') FOR [ActStart]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumEngrLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumEngrLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumEngrMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumStdCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CCumVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CEngLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CEngLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CEngMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CEngMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CEngQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CrewSize]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [CVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [EngrChgOrder]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [LaborClassID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [MachinID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [NbrMachines]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [OperationID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumEngrLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumEngrLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumEngrMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumStdCost]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PCumVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PDirLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PDirOthCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PEngLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PEngLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PEngMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PEngMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PEngQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PEngYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PFOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PFOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdLbrHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdLeadTime]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdMachHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdMoveHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdQueueHrs]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PStdYield]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PVOvhLbrCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [PVOvhMachCst]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [RtgStatus]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [StepNbr]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [ToolID1]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [ToolID2]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [ToolID3]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[RtgStep] ADD  DEFAULT (' ') FOR [WorkCenterID]
GO
