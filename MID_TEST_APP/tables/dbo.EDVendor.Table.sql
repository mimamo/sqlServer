USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[EDVendor]    Script Date: 12/21/2015 14:26:30 ******/
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
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [AllowDiffItem]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [AutoStoreVenPartNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [DefaultCarrier]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [DefaultFOB]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [DefaultVia]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [FOBLocQual]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [InEDICost]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [IntCustNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [OutBoundTemplate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqILineID]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOAcctNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOAgreeNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOArrivalDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOBatchNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOBidNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOBuyerName]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOCancelDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOChangeNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOConfirmerName]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOContractNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOCreationDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqODeliveryDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqODeptNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqODistributorNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser1]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser10]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser2]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser3]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser4]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser5]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser6]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser7]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser8]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEDPOUser9]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEffDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEndCustPackNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEndCustPODate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEndCustPONbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOEndCustSONbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOExpirDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOFOBLocQual]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOFOBPoint]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOFOBShipMethPay]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOFreight]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOSuff]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser1]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser2]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser3]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser4]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser5]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser6]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser7]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPOUser8]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPromoEndDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPromoNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPromoStartDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOPurReqNbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqORequestDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOSalesDivision]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOSalesman]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOSalesRegion]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOSalesTerritory]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOScheduleDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOShipDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOShipNBDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOShipNLDate]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOShipVia]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOShipWeekOf]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOTerms]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOVolume]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOWeight]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [ReqOWONbr]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [ShipMethPay]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [UseLineID]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [VouchFreight]
GO
ALTER TABLE [dbo].[EDVendor] ADD  DEFAULT ((0)) FOR [VouchRecpt]
GO
