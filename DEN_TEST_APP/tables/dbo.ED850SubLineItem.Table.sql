USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[ED850SubLineItem]    Script Date: 12/21/2015 14:10:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850SubLineItem](
	[ArrivalDate] [smalldatetime] NOT NULL,
	[BuyCatalog] [char](48) NOT NULL,
	[BuyPart] [char](48) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryPrice] [float] NOT NULL,
	[CuryPriceExt] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryRetailPrice] [float] NOT NULL,
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
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MemaCode] [char](48) NOT NULL,
	[MfgPart] [char](48) NOT NULL,
	[MilSpec] [char](48) NOT NULL,
	[NDC] [char](48) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Pack] [smallint] NOT NULL,
	[PackSize] [smallint] NOT NULL,
	[PackUOM] [char](6) NOT NULL,
	[Price] [float] NOT NULL,
	[PriceExt] [float] NOT NULL,
	[PrintNbr] [char](48) NOT NULL,
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
	[UCC] [char](48) NOT NULL,
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
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ArrivalDate]  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_BuyCatalog]  DEFAULT (' ') FOR [BuyCatalog]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_BuyPart]  DEFAULT (' ') FOR [BuyPart]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryEffDate]  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryMultDiv]  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryPrice]  DEFAULT ((0)) FOR [CuryPrice]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryPriceExt]  DEFAULT ((0)) FOR [CuryPriceExt]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryRate]  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryRateType]  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_CuryRetailPrice]  DEFAULT ((0)) FOR [CuryRetailPrice]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_DeliveryDate]  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Density]  DEFAULT ((0)) FOR [Density]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_DensityUOM]  DEFAULT (' ') FOR [DensityUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Depth]  DEFAULT ((0)) FOR [Depth]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_DepthUOM]  DEFAULT (' ') FOR [DepthUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Diameter]  DEFAULT ((0)) FOR [Diameter]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_DiameterUOM]  DEFAULT (' ') FOR [DiameterUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_EAN]  DEFAULT (' ') FOR [EAN]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ECCN]  DEFAULT (' ') FOR [ECCN]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_EDIPOID]  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_EffDate]  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ExpDate]  DEFAULT ('01/01/1900') FOR [ExpDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Gauge]  DEFAULT ((0)) FOR [Gauge]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_GaugeUOM]  DEFAULT (' ') FOR [GaugeUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_HeightUOM]  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ISBN]  DEFAULT (' ') FOR [ISBN]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ItemColor]  DEFAULT (' ') FOR [ItemColor]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ItemSize]  DEFAULT (' ') FOR [ItemSize]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Len]  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_LenUOM]  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_LineID]  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_MemaCode]  DEFAULT (' ') FOR [MemaCode]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_MfgPart]  DEFAULT (' ') FOR [MfgPart]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_MilSpec]  DEFAULT (' ') FOR [MilSpec]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_NDC]  DEFAULT (' ') FOR [NDC]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Pack]  DEFAULT ((0)) FOR [Pack]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_PackSize]  DEFAULT ((0)) FOR [PackSize]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_PackUOM]  DEFAULT (' ') FOR [PackUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Price]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_PriceExt]  DEFAULT ((0)) FOR [PriceExt]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_PrintNbr]  DEFAULT (' ') FOR [PrintNbr]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ReqLotSer]  DEFAULT (' ') FOR [ReqLotSer]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ReqSite]  DEFAULT (' ') FOR [ReqSite]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_RequestDate]  DEFAULT ('01/01/1900') FOR [RequestDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ReqWhseLoc]  DEFAULT (' ') FOR [ReqWhseLoc]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_RetailPrice]  DEFAULT ((0)) FOR [RetailPrice]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ScheduleDate]  DEFAULT ('01/01/1900') FOR [ScheduleDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ShipDate]  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ShipNBDate]  DEFAULT ('01/01/1900') FOR [ShipNBDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ShipNLDate]  DEFAULT ('01/01/1900') FOR [ShipNLDate]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_ShipWeekOf]  DEFAULT ('01/01/1900') FOR [ShipWeekOf]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_SKU]  DEFAULT (' ') FOR [SKU]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_UCC]  DEFAULT (' ') FOR [UCC]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_UOM]  DEFAULT (' ') FOR [UOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_UPC]  DEFAULT (' ') FOR [UPC]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Volume]  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_VolumeUOM]  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Weight]  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_WeightUOM]  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[ED850SubLineItem] ADD  CONSTRAINT [DF_ED850SubLineItem_WidthUOM]  DEFAULT (' ') FOR [WidthUOM]
GO
