USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[EDPurchOrd]    Script Date: 12/21/2015 13:35:01 ******/
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
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_AcctNbr]  DEFAULT (' ') FOR [AcctNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_AgreeNbr]  DEFAULT (' ') FOR [AgreeNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ArrivalDate]  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_BackOrderFlag]  DEFAULT ((0)) FOR [BackOrderFlag]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_BatchNbr]  DEFAULT (' ') FOR [BatchNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_BidNbr]  DEFAULT (' ') FOR [BidNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ChangeNbr]  DEFAULT (' ') FOR [ChangeNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ContractNbr]  DEFAULT (' ') FOR [ContractNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ConvertedDate]  DEFAULT ('01/01/1900') FOR [ConvertedDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_CreationDate]  DEFAULT ('01/01/1900') FOR [CreationDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_CrossDock]  DEFAULT (' ') FOR [CrossDock]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_DeliveryDate]  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_DeptNbr]  DEFAULT (' ') FOR [DeptNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_DistributorNbr]  DEFAULT (' ') FOR [DistributorNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_EffDate]  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_EndCustPackNbr]  DEFAULT (' ') FOR [EndCustPackNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_EndCustPODate]  DEFAULT ('01/01/1900') FOR [EndCustPODate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_EndCustPONbr]  DEFAULT (' ') FOR [EndCustPONbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_EndCustSONbr]  DEFAULT (' ') FOR [EndCustSONbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ExpirDate]  DEFAULT ('01/01/1900') FOR [ExpirDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_FOBLocQual]  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_HeightUOM]  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_LastEDIDate]  DEFAULT ('01/01/1900') FOR [LastEDIDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Len]  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_LenUOM]  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_NbrContainer]  DEFAULT ((0)) FOR [NbrContainer]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_OutboundProcNbr]  DEFAULT (' ') FOR [OutboundProcNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_PONbr]  DEFAULT (' ') FOR [PONbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_POSuff]  DEFAULT (' ') FOR [POSuff]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_PromoEndDate]  DEFAULT ('01/01/1900') FOR [PromoEndDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_PromoNbr]  DEFAULT (' ') FOR [PromoNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_PromoStartDate]  DEFAULT ('01/01/1900') FOR [PromoStartDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_PurReqNbr]  DEFAULT (' ') FOR [PurReqNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_QuoteNbr]  DEFAULT (' ') FOR [QuoteNbr]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_RequestDate]  DEFAULT ('01/01/1900') FOR [RequestDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Routing]  DEFAULT (' ') FOR [Routing]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_RoutingIDCode]  DEFAULT (' ') FOR [RoutingIDCode]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_RoutingIDQual]  DEFAULT (' ') FOR [RoutingIDQual]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_RoutingSeqCode]  DEFAULT (' ') FOR [RoutingSeqCode]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_SalesDivision]  DEFAULT (' ') FOR [SalesDivision]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Salesman]  DEFAULT (' ') FOR [Salesman]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_SalesRegion]  DEFAULT (' ') FOR [SalesRegion]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_SalesTerritory]  DEFAULT (' ') FOR [SalesTerritory]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ScheduleDate]  DEFAULT ('01/01/1900') FOR [ScheduleDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ShipDate]  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ShipMthPay]  DEFAULT (' ') FOR [ShipMthPay]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ShipNBDate]  DEFAULT ('01/01/1900') FOR [ShipNBDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ShipNLDate]  DEFAULT ('01/01/1900') FOR [ShipNLDate]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_ShipWeekOf]  DEFAULT ('01/01/1900') FOR [ShipWeekOf]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_TranMethCode]  DEFAULT (' ') FOR [TranMethCode]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Volume]  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_VolumeUOM]  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Weight]  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_WeightUOM]  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_WidthUOM]  DEFAULT (' ') FOR [WidthUOM]
GO
ALTER TABLE [dbo].[EDPurchOrd] ADD  CONSTRAINT [DF_EDPurchOrd_WONbr]  DEFAULT (' ') FOR [WONbr]
GO
