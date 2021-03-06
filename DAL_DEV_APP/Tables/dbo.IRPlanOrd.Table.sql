USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[IRPlanOrd]    Script Date: 12/21/2015 13:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IRPlanOrd](
	[Buyer] [char](10) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FinishDate] [smalldatetime] NOT NULL,
	[FirmedDate] [smalldatetime] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[IRDocType] [char](2) NOT NULL,
	[LeadTime] [int] NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Planner] [char](10) NOT NULL,
	[PlanOrdNbr] [char](15) NOT NULL,
	[PlanQty] [float] NOT NULL,
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
	[ShipViaID] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SolDocID] [char](15) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[Status] [char](2) NOT NULL,
	[TransferSiteID] [char](10) NOT NULL,
	[UnitDesc] [char](6) NOT NULL,
	[UnitMultDiv] [char](1) NOT NULL,
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
	[VendID] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Crtd_Datetime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_FinishDate]  DEFAULT ('01/01/1900') FOR [FinishDate]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_FirmedDate]  DEFAULT ('01/01/1900') FOR [FirmedDate]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_IRDocType]  DEFAULT (' ') FOR [IRDocType]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_LeadTime]  DEFAULT ((0)) FOR [LeadTime]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Lupd_Datetime]  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Planner]  DEFAULT (' ') FOR [Planner]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_PlanOrdNbr]  DEFAULT (' ') FOR [PlanOrdNbr]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_PlanQty]  DEFAULT ((0)) FOR [PlanQty]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_ShipViaID]  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_SolDocID]  DEFAULT (' ') FOR [SolDocID]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_StartDate]  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_TransferSiteID]  DEFAULT (' ') FOR [TransferSiteID]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_UnitDesc]  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[IRPlanOrd] ADD  CONSTRAINT [DF_IRPlanOrd_VendID]  DEFAULT (' ') FOR [VendID]
GO
