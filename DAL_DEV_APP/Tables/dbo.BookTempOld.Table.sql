USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[BookTempOld]    Script Date: 12/21/2015 13:35:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BookTempOld](
	[ActionFlag] [char](1) NOT NULL,
	[BookCntr] [smallint] NOT NULL,
	[BookCommCost] [float] NOT NULL,
	[BookCost] [float] NOT NULL,
	[BookSls] [float] NOT NULL,
	[ChargeType] [char](1) NOT NULL,
	[CommCost] [float] NOT NULL,
	[CommPct] [float] NOT NULL,
	[CommStmntID] [char](10) NOT NULL,
	[ContractNbr] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreditPct] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CustClassID] [char](6) NOT NULL,
	[CustCommClassID] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustTerr] [char](10) NOT NULL,
	[DiscPct] [float] NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[EffPeriod] [char](6) NOT NULL,
	[FirstRecord] [smallint] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[ItemCommClassID] [char](10) NOT NULL,
	[MiscChrgRef] [char](5) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdLineRef] [char](5) NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[Period] [char](6) NOT NULL,
	[ProdClassID] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[QtyOrd] [float] NOT NULL,
	[ReqDate] [smalldatetime] NOT NULL,
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
	[SchedRef] [char](5) NOT NULL,
	[ShipCustID] [char](15) NOT NULL,
	[ShipLineRef] [char](5) NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[ShiptoID] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SlsperID] [char](10) NOT NULL,
	[SlsPrice] [float] NOT NULL,
	[SlsTerr] [char](10) NOT NULL,
	[TaskID] [char](32) NOT NULL,
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
	[WeightedBookCommCost] [float] NOT NULL,
	[WeightedBookCost] [float] NOT NULL,
	[WeightedBookSls] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ActionFlag]  DEFAULT (' ') FOR [ActionFlag]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_BookCntr]  DEFAULT ((0)) FOR [BookCntr]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_BookCommCost]  DEFAULT ((0)) FOR [BookCommCost]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_BookCost]  DEFAULT ((0)) FOR [BookCost]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_BookSls]  DEFAULT ((0)) FOR [BookSls]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ChargeType]  DEFAULT (' ') FOR [ChargeType]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CommCost]  DEFAULT ((0)) FOR [CommCost]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CommPct]  DEFAULT ((0)) FOR [CommPct]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CommStmntID]  DEFAULT (' ') FOR [CommStmntID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ContractNbr]  DEFAULT (' ') FOR [ContractNbr]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CreditPct]  DEFAULT ((0)) FOR [CreditPct]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CustClassID]  DEFAULT (' ') FOR [CustClassID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CustCommClassID]  DEFAULT (' ') FOR [CustCommClassID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_CustTerr]  DEFAULT (' ') FOR [CustTerr]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_DiscPct]  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_EffDate]  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_EffPeriod]  DEFAULT (' ') FOR [EffPeriod]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_FirstRecord]  DEFAULT ((0)) FOR [FirstRecord]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ItemCommClassID]  DEFAULT (' ') FOR [ItemCommClassID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_MiscChrgRef]  DEFAULT (' ') FOR [MiscChrgRef]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_OrdLineRef]  DEFAULT (' ') FOR [OrdLineRef]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_Period]  DEFAULT (' ') FOR [Period]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ProdClassID]  DEFAULT (' ') FOR [ProdClassID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ProjectID]  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_QtyOrd]  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ReqDate]  DEFAULT ('01/01/1900') FOR [ReqDate]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_SchedRef]  DEFAULT (' ') FOR [SchedRef]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ShipCustID]  DEFAULT (' ') FOR [ShipCustID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ShipLineRef]  DEFAULT (' ') FOR [ShipLineRef]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_ShiptoID]  DEFAULT (' ') FOR [ShiptoID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_SlsperID]  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_SlsPrice]  DEFAULT ((0)) FOR [SlsPrice]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_SlsTerr]  DEFAULT (' ') FOR [SlsTerr]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_TaskID]  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_UnitDesc]  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_UnitMultDiv]  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_WeightedBookCommCost]  DEFAULT ((0)) FOR [WeightedBookCommCost]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_WeightedBookCost]  DEFAULT ((0)) FOR [WeightedBookCost]
GO
ALTER TABLE [dbo].[BookTempOld] ADD  CONSTRAINT [DF_BookTempOld_WeightedBookSls]  DEFAULT ((0)) FOR [WeightedBookSls]
GO
