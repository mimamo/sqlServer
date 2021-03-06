USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[SOPlan]    Script Date: 12/21/2015 16:12:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOPlan](
	[BuildAssyTime] [smallint] NOT NULL,
	[BuildAvailDate] [smalldatetime] NOT NULL,
	[CompLeadTime] [smallint] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DisplaySeq] [char](36) NOT NULL,
	[FixedAlloc] [smallint] NOT NULL,
	[Hold] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PlanDate] [smalldatetime] NOT NULL,
	[PlanRef] [char](5) NOT NULL,
	[PlanType] [char](2) NOT NULL,
	[POAllocRef] [char](5) NOT NULL,
	[POLineRef] [char](5) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[Priority] [smallint] NOT NULL,
	[PriorityDate] [smalldatetime] NOT NULL,
	[PrioritySeq] [int] NOT NULL,
	[PriorityTime] [smalldatetime] NOT NULL,
	[PromDate] [smalldatetime] NOT NULL,
	[PromShipDate] [smalldatetime] NOT NULL,
	[Qty] [float] NOT NULL,
	[QtyAvail] [float] NOT NULL,
	[QtyShip] [float] NOT NULL,
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
	[ShelfLife] [int] NOT NULL,
	[ShipCmplt] [smallint] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SOETADate] [smalldatetime] NOT NULL,
	[SOLineRef] [char](5) NOT NULL,
	[SOOrdNbr] [char](15) NOT NULL,
	[SOReqDate] [smalldatetime] NOT NULL,
	[SOReqPickDate] [smalldatetime] NOT NULL,
	[SOReqShipDate] [smalldatetime] NOT NULL,
	[SOSchedRef] [char](5) NOT NULL,
	[SOShipperID] [char](15) NOT NULL,
	[SOShipperLineRef] [char](5) NOT NULL,
	[SOShipViaID] [char](15) NOT NULL,
	[SOTransitTime] [smallint] NOT NULL,
	[SOWeekendDelivery] [smallint] NOT NULL,
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
	[WOBTLineRef] [char](5) NOT NULL,
	[WOMRLineRef] [char](5) NOT NULL,
	[WONbr] [char](16) NOT NULL,
	[WOTask] [char](32) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [BuildAssyTime]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [BuildAvailDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [CompLeadTime]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [DisplaySeq]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [FixedAlloc]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [Hold]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [PlanDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [PlanRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [PlanType]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [POAllocRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [POLineRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [PriorityDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [PrioritySeq]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [PriorityTime]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [PromDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [PromShipDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [QtyAvail]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [ShelfLife]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [ShipCmplt]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [SOETADate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SOLineRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SOOrdNbr]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [SOReqDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [SOReqPickDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [SOReqShipDate]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SOSchedRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SOShipperID]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SOShipperLineRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [SOShipViaID]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [SOTransitTime]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [SOWeekendDelivery]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [WOBTLineRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [WOMRLineRef]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [WONbr]
GO
ALTER TABLE [dbo].[SOPlan] ADD  DEFAULT (' ') FOR [WOTask]
GO
