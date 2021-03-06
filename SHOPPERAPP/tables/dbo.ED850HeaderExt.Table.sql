USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[ED850HeaderExt]    Script Date: 12/21/2015 16:12:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED850HeaderExt](
	[AcctNbr] [char](35) NOT NULL,
	[AgreeNbr] [char](35) NOT NULL,
	[ArrivalDate] [smalldatetime] NOT NULL,
	[BatchNbr] [char](35) NOT NULL,
	[BidNbr] [char](35) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[ChangeNbr] [char](35) NOT NULL,
	[ContractNbr] [char](35) NOT NULL,
	[ConvertedDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CreationDate] [smalldatetime] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurCode] [char](3) NOT NULL,
	[CustSalesOrder] [char](30) NOT NULL,
	[DeliveryDate] [smalldatetime] NOT NULL,
	[DeptNbr] [char](35) NOT NULL,
	[DistributorNbr] [char](35) NOT NULL,
	[EDIPOID] [char](10) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[EndCustPackNbr] [char](30) NOT NULL,
	[EndCustPODate] [smalldatetime] NOT NULL,
	[EndCustPONbr] [char](30) NOT NULL,
	[EndCustSONbr] [char](30) NOT NULL,
	[ExchgDate1] [smalldatetime] NOT NULL,
	[ExchgDate2] [smalldatetime] NOT NULL,
	[ExchgDateQual1] [char](3) NOT NULL,
	[ExchgDateQual2] [char](3) NOT NULL,
	[ExchgRate] [float] NOT NULL,
	[ExchgTime1] [char](8) NOT NULL,
	[ExchgTime2] [char](8) NOT NULL,
	[ExpirDate] [smalldatetime] NOT NULL,
	[GsDate] [smalldatetime] NOT NULL,
	[GsNbr] [int] NOT NULL,
	[GsRcvID] [char](15) NOT NULL,
	[GsSenderID] [char](15) NOT NULL,
	[GsTime] [char](8) NOT NULL,
	[HashTotal] [float] NOT NULL,
	[IntchgStandard] [char](1) NOT NULL,
	[IntchgTestFlg] [char](1) NOT NULL,
	[IntchgVersion] [char](5) NOT NULL,
	[IntVenNbr] [char](35) NOT NULL,
	[IsaNbr] [int] NOT NULL,
	[IsaRcvID] [char](15) NOT NULL,
	[IsaRcvQual] [char](2) NOT NULL,
	[ISndID] [char](15) NOT NULL,
	[ISndQual] [char](2) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MasterOrderFlag] [smallint] NOT NULL,
	[MultiStore] [smallint] NOT NULL,
	[OrderVolume] [int] NOT NULL,
	[OrderVolumeUOM] [char](6) NOT NULL,
	[OrderWeight] [int] NOT NULL,
	[OrderWeightUOM] [char](6) NOT NULL,
	[PODate] [smalldatetime] NOT NULL,
	[POSuff] [char](35) NOT NULL,
	[PrintDate] [smalldatetime] NOT NULL,
	[PromoEndDate] [smalldatetime] NOT NULL,
	[PromoNbr] [char](35) NOT NULL,
	[PromoStartDate] [smalldatetime] NOT NULL,
	[PurReqNbr] [char](35) NOT NULL,
	[QuoteNbr] [char](35) NOT NULL,
	[RequestDate] [smalldatetime] NOT NULL,
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
	[ShipNBDate] [smalldatetime] NOT NULL,
	[ShipNLDate] [smalldatetime] NOT NULL,
	[ShipWeekOf] [smalldatetime] NOT NULL,
	[Standard] [char](2) NOT NULL,
	[StNbr] [int] NOT NULL,
	[TaxExemptCode] [char](1) NOT NULL,
	[TaxID] [char](20) NOT NULL,
	[TaxLocation] [char](30) NOT NULL,
	[TaxLocQual] [char](2) NOT NULL,
	[TransmitDate] [smalldatetime] NOT NULL,
	[TransmitTime] [char](8) NOT NULL,
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
	[Version] [char](12) NOT NULL,
	[WONbr] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [AcctNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [AgreeNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [BatchNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [BidNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ChangeNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ContractNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ConvertedDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [CreationDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [CurCode]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [CustSalesOrder]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [DeptNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [DistributorNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [EDIPOID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [EndCustPackNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [EndCustPODate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [EndCustPONbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [EndCustSONbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ExchgDate1]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ExchgDate2]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ExchgDateQual1]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ExchgDateQual2]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [ExchgRate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ExchgTime1]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ExchgTime2]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ExpirDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [GsDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [GsNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [GsRcvID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [GsSenderID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [GsTime]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [HashTotal]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [IntchgStandard]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [IntchgTestFlg]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [IntchgVersion]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [IntVenNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [IsaNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [IsaRcvID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [IsaRcvQual]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ISndID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [ISndQual]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [MasterOrderFlag]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [MultiStore]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [OrderVolume]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [OrderVolumeUOM]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [OrderWeight]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [OrderWeightUOM]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [PODate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [POSuff]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [PrintDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [PromoEndDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [PromoNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [PromoStartDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [PurReqNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [QuoteNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [RequestDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [SalesDivision]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Salesman]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [SalesRegion]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [SalesTerritory]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ScheduleDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ShipNBDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ShipNLDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ShipWeekOf]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Standard]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [StNbr]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [TaxExemptCode]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [TaxID]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [TaxLocation]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [TaxLocQual]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [TransmitDate]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [TransmitTime]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [Version]
GO
ALTER TABLE [dbo].[ED850HeaderExt] ADD  DEFAULT (' ') FOR [WONbr]
GO
