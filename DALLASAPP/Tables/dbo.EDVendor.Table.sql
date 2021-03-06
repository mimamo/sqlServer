USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[EDVendor]    Script Date: 12/21/2015 13:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDVendor](
	[AllowDiffItem] [smallint] NOT NULL,
	[AutoStoreVenPartNbr] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DefaultCarrier] [char](10) NOT NULL,
	[DefaultFOB] [char](20) NOT NULL,
	[DefaultVia] [char](10) NOT NULL,
	[FOBLocQual] [char](2) NOT NULL,
	[InEDICost] [smallint] NOT NULL,
	[IntCustNbr] [char](20) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[OutBoundTemplate] [char](20) NOT NULL,
	[ReqILineID] [smallint] NOT NULL,
	[ReqOAcctNbr] [smallint] NOT NULL,
	[ReqOAgreeNbr] [smallint] NOT NULL,
	[ReqOArrivalDate] [smallint] NOT NULL,
	[ReqOBatchNbr] [smallint] NOT NULL,
	[ReqOBidNbr] [smallint] NOT NULL,
	[ReqOBuyerName] [smallint] NOT NULL,
	[ReqOCancelDate] [smallint] NOT NULL,
	[ReqOChangeNbr] [smallint] NOT NULL,
	[ReqOConfirmerName] [smallint] NOT NULL,
	[ReqOContractNbr] [smallint] NOT NULL,
	[ReqOCreationDate] [smallint] NOT NULL,
	[ReqODeliveryDate] [smallint] NOT NULL,
	[ReqODeptNbr] [smallint] NOT NULL,
	[ReqODistributorNbr] [smallint] NOT NULL,
	[ReqOEDPOUser1] [smallint] NOT NULL,
	[ReqOEDPOUser10] [smallint] NOT NULL,
	[ReqOEDPOUser2] [smallint] NOT NULL,
	[ReqOEDPOUser3] [smallint] NOT NULL,
	[ReqOEDPOUser4] [smallint] NOT NULL,
	[ReqOEDPOUser5] [smallint] NOT NULL,
	[ReqOEDPOUser6] [smallint] NOT NULL,
	[ReqOEDPOUser7] [smallint] NOT NULL,
	[ReqOEDPOUser8] [smallint] NOT NULL,
	[ReqOEDPOUser9] [smallint] NOT NULL,
	[ReqOEffDate] [smallint] NOT NULL,
	[ReqOEndCustPackNbr] [smallint] NOT NULL,
	[ReqOEndCustPODate] [smallint] NOT NULL,
	[ReqOEndCustPONbr] [smallint] NOT NULL,
	[ReqOEndCustSONbr] [smallint] NOT NULL,
	[ReqOExpirDate] [smallint] NOT NULL,
	[ReqOFOBLocQual] [smallint] NOT NULL,
	[ReqOFOBPoint] [smallint] NOT NULL,
	[ReqOFOBShipMethPay] [smallint] NOT NULL,
	[ReqOFreight] [smallint] NOT NULL,
	[ReqOPOSuff] [smallint] NOT NULL,
	[ReqOPOUser1] [smallint] NOT NULL,
	[ReqOPOUser2] [smallint] NOT NULL,
	[ReqOPOUser3] [smallint] NOT NULL,
	[ReqOPOUser4] [smallint] NOT NULL,
	[ReqOPOUser5] [smallint] NOT NULL,
	[ReqOPOUser6] [smallint] NOT NULL,
	[ReqOPOUser7] [smallint] NOT NULL,
	[ReqOPOUser8] [smallint] NOT NULL,
	[ReqOPromoEndDate] [smallint] NOT NULL,
	[ReqOPromoNbr] [smallint] NOT NULL,
	[ReqOPromoStartDate] [smallint] NOT NULL,
	[ReqOPurReqNbr] [smallint] NOT NULL,
	[ReqORequestDate] [smallint] NOT NULL,
	[ReqOSalesDivision] [smallint] NOT NULL,
	[ReqOSalesman] [smallint] NOT NULL,
	[ReqOSalesRegion] [smallint] NOT NULL,
	[ReqOSalesTerritory] [smallint] NOT NULL,
	[ReqOScheduleDate] [smallint] NOT NULL,
	[ReqOShipDate] [smallint] NOT NULL,
	[ReqOShipNBDate] [smallint] NOT NULL,
	[ReqOShipNLDate] [smallint] NOT NULL,
	[ReqOShipVia] [smallint] NOT NULL,
	[ReqOShipWeekOf] [smallint] NOT NULL,
	[ReqOTerms] [smallint] NOT NULL,
	[ReqOVolume] [smallint] NOT NULL,
	[ReqOWeight] [smallint] NOT NULL,
	[ReqOWONbr] [smallint] NOT NULL,
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
	[ShipMethPay] [char](2) NOT NULL,
	[UseLineID] [smallint] NOT NULL,
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
	[VouchFreight] [smallint] NOT NULL,
	[VouchRecpt] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_AllowDiffItem]  DEFAULT ((0)) FOR [AllowDiffItem]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_AutoStoreVenPartNbr]  DEFAULT ((0)) FOR [AutoStoreVenPartNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_DefaultCarrier]  DEFAULT (' ') FOR [DefaultCarrier]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_DefaultFOB]  DEFAULT (' ') FOR [DefaultFOB]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_DefaultVia]  DEFAULT (' ') FOR [DefaultVia]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_FOBLocQual]  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_InEDICost]  DEFAULT ((0)) FOR [InEDICost]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_IntCustNbr]  DEFAULT (' ') FOR [IntCustNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_Lupd_DateTime]  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_OutBoundTemplate]  DEFAULT (' ') FOR [OutBoundTemplate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqILineID]  DEFAULT ((0)) FOR [ReqILineID]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOAcctNbr]  DEFAULT ((0)) FOR [ReqOAcctNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOAgreeNbr]  DEFAULT ((0)) FOR [ReqOAgreeNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOArrivalDate]  DEFAULT ((0)) FOR [ReqOArrivalDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOBatchNbr]  DEFAULT ((0)) FOR [ReqOBatchNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOBidNbr]  DEFAULT ((0)) FOR [ReqOBidNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOBuyerName]  DEFAULT ((0)) FOR [ReqOBuyerName]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOCancelDate]  DEFAULT ((0)) FOR [ReqOCancelDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOChangeNbr]  DEFAULT ((0)) FOR [ReqOChangeNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOConfirmerName]  DEFAULT ((0)) FOR [ReqOConfirmerName]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOContractNbr]  DEFAULT ((0)) FOR [ReqOContractNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOCreationDate]  DEFAULT ((0)) FOR [ReqOCreationDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqODeliveryDate]  DEFAULT ((0)) FOR [ReqODeliveryDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqODeptNbr]  DEFAULT ((0)) FOR [ReqODeptNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqODistributorNbr]  DEFAULT ((0)) FOR [ReqODistributorNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser1]  DEFAULT ((0)) FOR [ReqOEDPOUser1]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser10]  DEFAULT ((0)) FOR [ReqOEDPOUser10]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser2]  DEFAULT ((0)) FOR [ReqOEDPOUser2]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser3]  DEFAULT ((0)) FOR [ReqOEDPOUser3]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser4]  DEFAULT ((0)) FOR [ReqOEDPOUser4]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser5]  DEFAULT ((0)) FOR [ReqOEDPOUser5]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser6]  DEFAULT ((0)) FOR [ReqOEDPOUser6]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser7]  DEFAULT ((0)) FOR [ReqOEDPOUser7]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser8]  DEFAULT ((0)) FOR [ReqOEDPOUser8]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEDPOUser9]  DEFAULT ((0)) FOR [ReqOEDPOUser9]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEffDate]  DEFAULT ((0)) FOR [ReqOEffDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEndCustPackNbr]  DEFAULT ((0)) FOR [ReqOEndCustPackNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEndCustPODate]  DEFAULT ((0)) FOR [ReqOEndCustPODate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEndCustPONbr]  DEFAULT ((0)) FOR [ReqOEndCustPONbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOEndCustSONbr]  DEFAULT ((0)) FOR [ReqOEndCustSONbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOExpirDate]  DEFAULT ((0)) FOR [ReqOExpirDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOFOBLocQual]  DEFAULT ((0)) FOR [ReqOFOBLocQual]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOFOBPoint]  DEFAULT ((0)) FOR [ReqOFOBPoint]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOFOBShipMethPay]  DEFAULT ((0)) FOR [ReqOFOBShipMethPay]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOFreight]  DEFAULT ((0)) FOR [ReqOFreight]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOSuff]  DEFAULT ((0)) FOR [ReqOPOSuff]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser1]  DEFAULT ((0)) FOR [ReqOPOUser1]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser2]  DEFAULT ((0)) FOR [ReqOPOUser2]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser3]  DEFAULT ((0)) FOR [ReqOPOUser3]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser4]  DEFAULT ((0)) FOR [ReqOPOUser4]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser5]  DEFAULT ((0)) FOR [ReqOPOUser5]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser6]  DEFAULT ((0)) FOR [ReqOPOUser6]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser7]  DEFAULT ((0)) FOR [ReqOPOUser7]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPOUser8]  DEFAULT ((0)) FOR [ReqOPOUser8]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPromoEndDate]  DEFAULT ((0)) FOR [ReqOPromoEndDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPromoNbr]  DEFAULT ((0)) FOR [ReqOPromoNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPromoStartDate]  DEFAULT ((0)) FOR [ReqOPromoStartDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOPurReqNbr]  DEFAULT ((0)) FOR [ReqOPurReqNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqORequestDate]  DEFAULT ((0)) FOR [ReqORequestDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOSalesDivision]  DEFAULT ((0)) FOR [ReqOSalesDivision]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOSalesman]  DEFAULT ((0)) FOR [ReqOSalesman]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOSalesRegion]  DEFAULT ((0)) FOR [ReqOSalesRegion]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOSalesTerritory]  DEFAULT ((0)) FOR [ReqOSalesTerritory]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOScheduleDate]  DEFAULT ((0)) FOR [ReqOScheduleDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOShipDate]  DEFAULT ((0)) FOR [ReqOShipDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOShipNBDate]  DEFAULT ((0)) FOR [ReqOShipNBDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOShipNLDate]  DEFAULT ((0)) FOR [ReqOShipNLDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOShipVia]  DEFAULT ((0)) FOR [ReqOShipVia]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOShipWeekOf]  DEFAULT ((0)) FOR [ReqOShipWeekOf]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOTerms]  DEFAULT ((0)) FOR [ReqOTerms]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOVolume]  DEFAULT ((0)) FOR [ReqOVolume]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOWeight]  DEFAULT ((0)) FOR [ReqOWeight]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ReqOWONbr]  DEFAULT ((0)) FOR [ReqOWONbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_ShipMethPay]  DEFAULT (' ') FOR [ShipMethPay]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_UseLineID]  DEFAULT ((0)) FOR [UseLineID]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_VendID]  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_VouchFreight]  DEFAULT ((0)) FOR [VouchFreight]
GO
ALTER TABLE [dbo].[EDVendor] ADD  CONSTRAINT [DF_EDVendor_VouchRecpt]  DEFAULT ((0)) FOR [VouchRecpt]
GO
