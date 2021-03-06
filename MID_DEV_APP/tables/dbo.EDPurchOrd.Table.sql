USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[EDPurchOrd]    Script Date: 12/21/2015 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDPurchOrd](
	[AcctNbr] [char](35) NOT NULL,
	[AgreeNbr] [char](35) NOT NULL,
	[ArrivalDate] [smalldatetime] NOT NULL,
	[BackOrderFlag] [smallint] NOT NULL,
	[BatchNbr] [char](35) NOT NULL,
	[BidNbr] [char](35) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[ChangeNbr] [char](35) NOT NULL,
	[ContractNbr] [char](35) NOT NULL,
	[ConvertedDate] [smalldatetime] NOT NULL,
	[CreationDate] [smalldatetime] NOT NULL,
	[CrossDock] [char](20) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeliveryDate] [smalldatetime] NOT NULL,
	[DeptNbr] [char](35) NOT NULL,
	[DistributorNbr] [char](35) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[EndCustPackNbr] [char](30) NOT NULL,
	[EndCustPODate] [smalldatetime] NOT NULL,
	[EndCustPONbr] [char](30) NOT NULL,
	[EndCustSONbr] [char](30) NOT NULL,
	[ExpirDate] [smalldatetime] NOT NULL,
	[FOBLocQual] [char](2) NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](6) NOT NULL,
	[LastEDIDate] [smalldatetime] NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NbrContainer] [smallint] NOT NULL,
	[OutboundProcNbr] [char](10) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[POSuff] [char](35) NOT NULL,
	[PromoEndDate] [smalldatetime] NOT NULL,
	[PromoNbr] [char](35) NOT NULL,
	[PromoStartDate] [smalldatetime] NOT NULL,
	[PurReqNbr] [char](35) NOT NULL,
	[QuoteNbr] [char](35) NOT NULL,
	[RequestDate] [smalldatetime] NOT NULL,
	[Routing] [char](50) NOT NULL,
	[RoutingIDCode] [char](80) NOT NULL,
	[RoutingIDQual] [char](3) NOT NULL,
	[RoutingSeqCode] [char](3) NOT NULL,
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
	[SalesDivision] [char](30) NOT NULL,
	[Salesman] [char](30) NOT NULL,
	[SalesRegion] [char](30) NOT NULL,
	[SalesTerritory] [char](30) NOT NULL,
	[ScheduleDate] [smalldatetime] NOT NULL,
	[ShipDate] [smalldatetime] NOT NULL,
	[ShipMthPay] [char](2) NOT NULL,
	[ShipNBDate] [smalldatetime] NOT NULL,
	[ShipNLDate] [smalldatetime] NOT NULL,
	[ShipWeekOf] [smalldatetime] NOT NULL,
	[TranMethCode] [char](3) NOT NULL,
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
	[Volume] [float] NOT NULL,
	[VolumeUOM] [char](6) NOT NULL,
	[Weight] [float] NOT NULL,
	[WeightUOM] [char](6) NOT NULL,
	[Width] [float] NOT NULL,
	[WidthUOM] [char](6) NOT NULL,
	[WONbr] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [AcctNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [AgreeNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [BackOrderFlag]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [BatchNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [BidNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [ChangeNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [ContractNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ConvertedDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [CreationDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [CrossDock]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [DeptNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [DistributorNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [EndCustPackNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [EndCustPODate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [EndCustPONbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [EndCustSONbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ExpirDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [LastEDIDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [NbrContainer]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [OutboundProcNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [POSuff]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [PromoEndDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [PromoNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [PromoStartDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [PurReqNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [QuoteNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [RequestDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [Routing]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [RoutingIDCode]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [RoutingIDQual]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [RoutingSeqCode]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [SalesDivision]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [Salesman]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [SalesRegion]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [SalesTerritory]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ScheduleDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [ShipMthPay]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ShipNBDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ShipNLDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [ShipWeekOf]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [TranMethCode]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [WidthUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  DEFAULT (' ') FOR [WONbr]
GO
