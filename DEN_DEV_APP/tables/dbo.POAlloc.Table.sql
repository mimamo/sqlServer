USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[POAlloc]    Script Date: 12/21/2015 14:05:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POAlloc](
	[AllocRef] [char](5) NOT NULL,
	[BOMLineRef] [char](5) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DocType] [char](1) NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[POLineRef] [char](5) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[Project] [char](16) NOT NULL,
	[PurchAcct] [char](10) NOT NULL,
	[PurchSub] [char](24) NOT NULL,
	[PurchUnit] [char](6) NOT NULL,
	[QtyAlloc] [float] NOT NULL,
	[QtyOrd] [float] NOT NULL,
	[QtyRcvd] [float] NOT NULL,
	[QtyReturned] [float] NOT NULL,
	[QtyShip] [float] NOT NULL,
	[QtyVouched] [float] NOT NULL,
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
	[SiteId] [char](10) NOT NULL,
	[SOLineRef] [char](5) NOT NULL,
	[SOOrdNbr] [char](15) NOT NULL,
	[SOSchedRef] [char](5) NOT NULL,
	[SOType] [char](2) NOT NULL,
	[Task] [char](32) NOT NULL,
	[UnitCnvFact] [float] NOT NULL,
	[UnitMultDiv] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WOCostType] [char](2) NOT NULL,
	[WOLineRef] [char](5) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[WOStepNbr] [char](5) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_AllocRef]  DEFAULT (' ') FOR [AllocRef]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_BOMLineRef]  DEFAULT (' ') FOR [BOMLineRef]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_DocType]  DEFAULT (' ') FOR [DocType]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_EmpID]  DEFAULT (' ') FOR [EmpID]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_Labor_Class_Cd]  DEFAULT (' ') FOR [Labor_Class_Cd]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_POLineRef]  DEFAULT (' ') FOR [POLineRef]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_Project]  DEFAULT (' ') FOR [Project]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_PurchAcct]  DEFAULT (' ') FOR [PurchAcct]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_PurchSub]  DEFAULT (' ') FOR [PurchSub]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_PurchUnit]  DEFAULT (' ') FOR [PurchUnit]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_QtyAlloc]  DEFAULT ((0)) FOR [QtyAlloc]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_QtyOrd]  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_QtyRcvd]  DEFAULT ((0)) FOR [QtyRcvd]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_QtyReturned]  DEFAULT ((0)) FOR [QtyReturned]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_QtyShip]  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_QtyVouched]  DEFAULT ((0)) FOR [QtyVouched]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_SiteId]  DEFAULT (' ') FOR [SiteId]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_SOLineRef]  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_SOOrdNbr]  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_SOSchedRef]  DEFAULT (' ') FOR [SOSchedRef]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_SOType]  DEFAULT (' ') FOR [SOType]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_Task]  DEFAULT (' ') FOR [Task]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_UnitCnvFact]  DEFAULT ((0)) FOR [UnitCnvFact]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_WOCostType]  DEFAULT (' ') FOR [WOCostType]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_WOLineRef]  DEFAULT (' ') FOR [WOLineRef]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[POAlloc] ADD  CONSTRAINT [DF_POAlloc_WOStepNbr]  DEFAULT (' ') FOR [WOStepNbr]
GO
