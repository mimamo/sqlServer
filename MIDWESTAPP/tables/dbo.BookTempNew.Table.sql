USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[BookTempNew]    Script Date: 12/21/2015 15:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BookTempNew](
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
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ActionFlag]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [BookCntr]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [BookCommCost]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [BookCost]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [BookSls]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ChargeType]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [CommCost]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [CommPct]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CommStmntID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ContractNbr]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [CreditPct]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CustClassID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CustCommClassID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [CustTerr]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [EffPeriod]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [FirstRecord]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ItemCommClassID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [MiscChrgRef]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [OrdLineRef]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [Period]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ProdClassID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [QtyOrd]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [ReqDate]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [SchedRef]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ShipCustID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ShipLineRef]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [ShiptoID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [SlsperID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [SlsPrice]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [SlsTerr]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [UnitDesc]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [UnitMultDiv]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [WeightedBookCommCost]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [WeightedBookCost]
GO
ALTER TABLE [dbo].[BookTempNew] ADD  DEFAULT ((0)) FOR [WeightedBookSls]
GO
