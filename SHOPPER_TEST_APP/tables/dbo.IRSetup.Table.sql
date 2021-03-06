USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[IRSetup]    Script Date: 12/21/2015 16:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IRSetup](
	[CentDistMthd] [smallint] NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DemPeriodNbr] [int] NOT NULL,
	[DemTranDate] [smalldatetime] NOT NULL,
	[DemTranTime] [smalldatetime] NOT NULL,
	[DemTranUserID] [char](10) NOT NULL,
	[EOQCarryCostPct] [float] NOT NULL,
	[EOQReordCost] [float] NOT NULL,
	[ExclNonRecurTran] [smallint] NOT NULL,
	[IncludeDropShip] [smallint] NOT NULL,
	[LTPeriodNbr] [int] NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NbrPerRtnDem] [int] NOT NULL,
	[NextPlanOrdNbr] [char](15) NOT NULL,
	[PeriodLength] [int] NOT NULL,
	[PlanOrdDate] [smalldatetime] NOT NULL,
	[PlanOrdStartDate] [smalldatetime] NOT NULL,
	[PlanOrdTime] [smalldatetime] NOT NULL,
	[PlanOrdUserID] [char](10) NOT NULL,
	[ReplenValDate] [smalldatetime] NOT NULL,
	[ReplenValTime] [smalldatetime] NOT NULL,
	[ReplenValUserID] [char](10) NOT NULL,
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
	[SetupID] [char](2) NOT NULL,
	[ShipViaID] [char](15) NOT NULL,
	[SrvLvlPeriodNbr] [int] NOT NULL,
	[TOPeriodNbr] [int] NOT NULL,
	[TransferDays] [int] NOT NULL,
	[UseBookings] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [CentDistMthd]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [DemPeriodNbr]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [DemTranDate]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [DemTranTime]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [DemTranUserID]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [EOQCarryCostPct]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [EOQReordCost]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [ExclNonRecurTran]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [IncludeDropShip]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [LTPeriodNbr]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [NbrPerRtnDem]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [NextPlanOrdNbr]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [PeriodLength]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [PlanOrdDate]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [PlanOrdStartDate]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [PlanOrdTime]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [PlanOrdUserID]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [ReplenValDate]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [ReplenValTime]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [ReplenValUserID]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [SetupID]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [SrvLvlPeriodNbr]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [TOPeriodNbr]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [TransferDays]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [UseBookings]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[IRSetup] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
