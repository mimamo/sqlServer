USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[POItemReqDet]    Script Date: 12/21/2015 14:10:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[POItemReqDet](
	[AlternateID] [char](30) NOT NULL,
	[AppvLevObt] [char](2) NOT NULL,
	[AppvLevReq] [char](2) NOT NULL,
	[Buyer] [char](10) NOT NULL,
	[CatalogInfo] [char](60) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Dept] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[EstimateCost] [float] NOT NULL,
	[EstimatedExtcost] [float] NOT NULL,
	[InvtId] [char](30) NOT NULL,
	[ItemReqNbr] [char](10) NOT NULL,
	[LineID] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PrefVendor] [char](15) NOT NULL,
	[Project] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[ReqDate] [smalldatetime] NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
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
	[SourceOfRequest] [char](3) NOT NULL,
	[Status] [char](2) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TotalCost] [float] NOT NULL,
	[Unit] [char](6) NOT NULL,
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
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_AlternateID]  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_AppvLevObt]  DEFAULT (' ') FOR [AppvLevObt]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_AppvLevReq]  DEFAULT (' ') FOR [AppvLevReq]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_CatalogInfo]  DEFAULT (' ') FOR [CatalogInfo]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Dept]  DEFAULT (' ') FOR [Dept]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_EstimateCost]  DEFAULT ((0)) FOR [EstimateCost]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_EstimatedExtcost]  DEFAULT ((0)) FOR [EstimatedExtcost]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_InvtId]  DEFAULT (' ') FOR [InvtId]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_ItemReqNbr]  DEFAULT (' ') FOR [ItemReqNbr]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_MaterialType]  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_PrefVendor]  DEFAULT (' ') FOR [PrefVendor]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Project]  DEFAULT (' ') FOR [Project]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_ReqDate]  DEFAULT ('01/01/1900') FOR [ReqDate]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_ReqNbr]  DEFAULT (' ') FOR [ReqNbr]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_SourceOfRequest]  DEFAULT (' ') FOR [SourceOfRequest]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_TotalCost]  DEFAULT ((0)) FOR [TotalCost]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_Unit]  DEFAULT (' ') FOR [Unit]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[POItemReqDet] ADD  CONSTRAINT [DF_POItemReqDet_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
