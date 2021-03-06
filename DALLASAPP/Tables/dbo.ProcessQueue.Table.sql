USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[ProcessQueue]    Script Date: 12/21/2015 13:44:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProcessQueue](
	[ComputerName] [char](21) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreateShipper] [smallint] NOT NULL,
	[CreditInfoChanged] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaintMode] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PlanEntireItem] [smallint] NOT NULL,
	[POLineRef] [char](5) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[ProcessAt] [smalldatetime] NOT NULL,
	[ProcessCPSOff] [smallint] NOT NULL,
	[ProcessPriority] [smallint] NOT NULL,
	[ProcessQueueID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessType] [char](5) NOT NULL,
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
	[SOLineRef] [char](5) NOT NULL,
	[SOOrdNbr] [char](15) NOT NULL,
	[SOSchedRef] [char](5) NOT NULL,
	[SOShipperID] [char](15) NOT NULL,
	[SOShipperLineRef] [char](5) NOT NULL,
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
	[WOLineRef] [char](5) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[WOTask] [char](32) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_ComputerName]  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_CreateShipper]  DEFAULT ((0)) FOR [CreateShipper]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_CreditInfoChanged]  DEFAULT ((0)) FOR [CreditInfoChanged]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_MaintMode]  DEFAULT ((0)) FOR [MaintMode]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_PlanEntireItem]  DEFAULT ((0)) FOR [PlanEntireItem]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_POLineRef]  DEFAULT (' ') FOR [POLineRef]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_ProcessAt]  DEFAULT ('01/01/1900') FOR [ProcessAt]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_ProcessCPSOff]  DEFAULT ((0)) FOR [ProcessCPSOff]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_ProcessPriority]  DEFAULT ((0)) FOR [ProcessPriority]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_ProcessType]  DEFAULT (' ') FOR [ProcessType]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_SOLineRef]  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_SOOrdNbr]  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_SOSchedRef]  DEFAULT (' ') FOR [SOSchedRef]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_SOShipperID]  DEFAULT (' ') FOR [SOShipperID]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_SOShipperLineRef]  DEFAULT (' ') FOR [SOShipperLineRef]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_WOLineRef]  DEFAULT (' ') FOR [WOLineRef]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[ProcessQueue] ADD  CONSTRAINT [DF_ProcessQueue_WOTask]  DEFAULT (' ') FOR [WOTask]
GO
