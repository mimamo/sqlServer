USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[ED850Lineitem]    Script Date: 12/21/2015 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850Lineitem](
	[ArrivalDate] [smalldatetime] NOT NULL,
	[BuyCatalog] [char](48) NOT NULL,
	[BuyPart] [char](48) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[CatalogPrice] [float] NOT NULL,
	[ClassOfTrade] [char](5) NOT NULL,
	[ContainerPerLayer] [smallint] NOT NULL,
	[Containers] [int] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryCatalogPrice] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPrice] [float] NOT NULL,
	[CuryPriceExt] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryRetailPrice] [float] NOT NULL,
	[CustPackListItemNbr] [char](30) NOT NULL,
	[CustPartDesc] [char](80) NOT NULL,
	[CustPODate] [smalldatetime] NOT NULL,
	[CustPONbr] [char](30) NOT NULL,
	[CustPOSuff] [char](30) NOT NULL,
	[DeliveryDate] [smalldatetime] NOT NULL,
	[Density] [float] NOT NULL,
	[DensityUOM] [char](6) NOT NULL,
	[Depth] [float] NOT NULL,
	[DepthUOM] [char](6) NOT NULL,
	[Diameter] [float] NOT NULL,
	[DiameterUOM] [char](6) NOT NULL,
	[EAN] [char](48) NOT NULL,
	[ECCN] [char](48) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[ExpDate] [smalldatetime] NOT NULL,
	[Gauge] [float] NOT NULL,
	[GaugeUOM] [char](6) NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](6) NOT NULL,
	[InvtID] [char](48) NOT NULL,
	[ISBN] [char](48) NOT NULL,
	[ItemColor] [char](48) NOT NULL,
	[ItemSize] [char](48) NOT NULL,
	[LayersPerPallet] [smallint] NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MemaCode] [char](48) NOT NULL,
	[MfgPart] [char](48) NOT NULL,
	[MilSpec] [char](48) NOT NULL,
	[NDC] [char](48) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OtherRef] [char](48) NOT NULL,
	[OtherRefQual] [char](5) NOT NULL,
	[Pack] [smallint] NOT NULL,
	[PackSize] [smallint] NOT NULL,
	[PackUom] [char](6) NOT NULL,
	[POLineNbr] [char](20) NOT NULL,
	[Price] [float] NOT NULL,
	[PriceExt] [float] NOT NULL,
	[PrintNbr] [char](48) NOT NULL,
	[ProdClass] [char](35) NOT NULL,
	[PromoEndDate] [smalldatetime] NOT NULL,
	[PromoStartDate] [smalldatetime] NOT NULL,
	[Qty] [float] NOT NULL,
	[ReqLotSer] [char](35) NOT NULL,
	[ReqSite] [char](35) NOT NULL,
	[RequestDate] [smalldatetime] NOT NULL,
	[ReqWhseLoc] [char](35) NOT NULL,
	[RetailPrice] [float] NOT NULL,
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
	[ScheduleDate] [smalldatetime] NOT NULL,
	[ShipDate] [smalldatetime] NOT NULL,
	[ShipNBDate] [smalldatetime] NOT NULL,
	[ShipNLDate] [smalldatetime] NOT NULL,
	[ShipWeekOf] [smalldatetime] NOT NULL,
	[SKU] [char](48) NOT NULL,
	[TariffNbr] [char](35) NOT NULL,
	[UCC] [char](48) NOT NULL,
	[UnitPriceBasis] [char](5) NOT NULL,
	[UOM] [char](6) NOT NULL,
	[UPC] [char](48) NOT NULL,
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
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ArrivalDate]  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_BuyCatalog]  DEFAULT (' ') FOR [BuyCatalog]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_BuyPart]  DEFAULT (' ') FOR [BuyPart]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CatalogPrice]  DEFAULT ((0)) FOR [CatalogPrice]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ClassOfTrade]  DEFAULT (' ') FOR [ClassOfTrade]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ContainerPerLayer]  DEFAULT ((0)) FOR [ContainerPerLayer]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Containers]  DEFAULT ((0)) FOR [Containers]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryCatalogPrice]  DEFAULT ((0)) FOR [CuryCatalogPrice]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryPrice]  DEFAULT ((0)) FOR [CuryPrice]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryPriceExt]  DEFAULT ((0)) FOR [CuryPriceExt]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CuryRetailPrice]  DEFAULT ((0)) FOR [CuryRetailPrice]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CustPackListItemNbr]  DEFAULT (' ') FOR [CustPackListItemNbr]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CustPartDesc]  DEFAULT (' ') FOR [CustPartDesc]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CustPODate]  DEFAULT ('01/01/1900') FOR [CustPODate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CustPONbr]  DEFAULT (' ') FOR [CustPONbr]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_CustPOSuff]  DEFAULT (' ') FOR [CustPOSuff]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_DeliveryDate]  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Density]  DEFAULT ((0)) FOR [Density]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_DensityUOM]  DEFAULT (' ') FOR [DensityUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Depth]  DEFAULT ((0)) FOR [Depth]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_DepthUOM]  DEFAULT (' ') FOR [DepthUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Diameter]  DEFAULT ((0)) FOR [Diameter]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_DiameterUOM]  DEFAULT (' ') FOR [DiameterUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_EAN]  DEFAULT (' ') FOR [EAN]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ECCN]  DEFAULT (' ') FOR [ECCN]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_EffDate]  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ExpDate]  DEFAULT ('01/01/1900') FOR [ExpDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Gauge]  DEFAULT ((0)) FOR [Gauge]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_GaugeUOM]  DEFAULT (' ') FOR [GaugeUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_HeightUOM]  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ISBN]  DEFAULT (' ') FOR [ISBN]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ItemColor]  DEFAULT (' ') FOR [ItemColor]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ItemSize]  DEFAULT (' ') FOR [ItemSize]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_LayersPerPallet]  DEFAULT ((0)) FOR [LayersPerPallet]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Len]  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_LenUOM]  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_MemaCode]  DEFAULT (' ') FOR [MemaCode]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_MfgPart]  DEFAULT (' ') FOR [MfgPart]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_MilSpec]  DEFAULT (' ') FOR [MilSpec]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_NDC]  DEFAULT (' ') FOR [NDC]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_OtherRef]  DEFAULT (' ') FOR [OtherRef]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_OtherRefQual]  DEFAULT (' ') FOR [OtherRefQual]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Pack]  DEFAULT ((0)) FOR [Pack]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_PackSize]  DEFAULT ((0)) FOR [PackSize]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_PackUom]  DEFAULT (' ') FOR [PackUom]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_POLineNbr]  DEFAULT (' ') FOR [POLineNbr]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Price]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_PriceExt]  DEFAULT ((0)) FOR [PriceExt]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_PrintNbr]  DEFAULT (' ') FOR [PrintNbr]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ProdClass]  DEFAULT (' ') FOR [ProdClass]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_PromoEndDate]  DEFAULT ('01/01/1900') FOR [PromoEndDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_PromoStartDate]  DEFAULT ('01/01/1900') FOR [PromoStartDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ReqLotSer]  DEFAULT (' ') FOR [ReqLotSer]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ReqSite]  DEFAULT (' ') FOR [ReqSite]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_RequestDate]  DEFAULT ('01/01/1900') FOR [RequestDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ReqWhseLoc]  DEFAULT (' ') FOR [ReqWhseLoc]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_RetailPrice]  DEFAULT ((0)) FOR [RetailPrice]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ScheduleDate]  DEFAULT ('01/01/1900') FOR [ScheduleDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ShipDate]  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ShipNBDate]  DEFAULT ('01/01/1900') FOR [ShipNBDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ShipNLDate]  DEFAULT ('01/01/1900') FOR [ShipNLDate]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_ShipWeekOf]  DEFAULT ('01/01/1900') FOR [ShipWeekOf]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_SKU]  DEFAULT (' ') FOR [SKU]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_TariffNbr]  DEFAULT (' ') FOR [TariffNbr]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_UCC]  DEFAULT (' ') FOR [UCC]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_UnitPriceBasis]  DEFAULT (' ') FOR [UnitPriceBasis]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_UOM]  DEFAULT (' ') FOR [UOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_UPC]  DEFAULT (' ') FOR [UPC]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Volume]  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_VolumeUOM]  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Weight]  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_WeightUOM]  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[ED850Lineitem] ADD  CONSTRAINT [DF_ED850Lineitem_WidthUOM]  DEFAULT (' ') FOR [WidthUOM]
GO
