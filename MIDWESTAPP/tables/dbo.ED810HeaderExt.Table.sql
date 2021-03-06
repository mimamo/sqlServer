USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[ED810HeaderExt]    Script Date: 12/21/2015 15:54:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED810HeaderExt](
	[AcctNbr] [char](30) NOT NULL,
	[AgreeNbr] [char](30) NOT NULL,
	[AirBillNbr] [char](30) NOT NULL,
	[ArrivalDate] [smalldatetime] NOT NULL,
	[BidNbr] [char](30) NOT NULL,
	[BillToAdd1] [char](55) NOT NULL,
	[BillToAdd2] [char](55) NOT NULL,
	[BillToCity] [char](30) NOT NULL,
	[BillToCountry] [char](3) NOT NULL,
	[BillToName] [char](60) NOT NULL,
	[BillToName2] [char](60) NOT NULL,
	[BillToNbr] [char](80) NOT NULL,
	[BillToState] [char](2) NOT NULL,
	[BillToZip] [char](15) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CrossDock] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeliveryDate] [smalldatetime] NOT NULL,
	[DeptNbr] [char](30) NOT NULL,
	[DistributorNbr] [char](30) NOT NULL,
	[EDIInvID] [char](10) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[EndCustPODate] [smalldatetime] NOT NULL,
	[EndCustPONbr] [char](30) NOT NULL,
	[EndCustSONbr] [char](30) NOT NULL,
	[EquipmentNbr] [char](20) NOT NULL,
	[ExpirDate] [smalldatetime] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[PromoEndDate] [smalldatetime] NOT NULL,
	[PromoNbr] [char](30) NOT NULL,
	[PromoStartDate] [smalldatetime] NOT NULL,
	[QuoteNbr] [char](30) NOT NULL,
	[ShipDate] [smalldatetime] NOT NULL,
	[ShipFromAdd1] [char](55) NOT NULL,
	[ShipFromAdd2] [char](55) NOT NULL,
	[ShipFromCity] [char](30) NOT NULL,
	[ShipFromCountry] [char](3) NOT NULL,
	[ShipFromName] [char](60) NOT NULL,
	[ShipFromNbr] [char](80) NOT NULL,
	[ShipFromState] [char](2) NOT NULL,
	[ShipFromZip] [char](15) NOT NULL,
	[ShipToAdd1] [char](55) NOT NULL,
	[ShipToAdd2] [char](55) NOT NULL,
	[ShipToCity] [char](30) NOT NULL,
	[ShipToCountry] [char](3) NOT NULL,
	[ShipToName] [char](60) NOT NULL,
	[ShipToName2] [char](60) NOT NULL,
	[ShipToNbr] [char](80) NOT NULL,
	[ShipToState] [char](2) NOT NULL,
	[ShipToZip] [char](15) NOT NULL,
	[TrackingNbr] [char](30) NOT NULL,
	[WONbr] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [AcctNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [AgreeNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [AirBillNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ArrivalDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BidNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToAdd1]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToAdd2]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToCity]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToCountry]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToName]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToName2]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToState]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [BillToZip]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [CrossDock]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [DeliveryDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [DeptNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [DistributorNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [EDIInvID]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [EndCustPODate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [EndCustPONbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [EndCustSONbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [EquipmentNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ExpirDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [PromoEndDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [PromoNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [PromoStartDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [QuoteNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT ('01/01/1900') FOR [ShipDate]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromAdd1]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromAdd2]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromCity]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromCountry]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromName]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromState]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipFromZip]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToAdd1]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToAdd2]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToCity]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToCountry]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToName]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToName2]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToState]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [ShipToZip]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [TrackingNbr]
GO
ALTER TABLE [dbo].[ED810HeaderExt] ADD  DEFAULT (' ') FOR [WONbr]
GO
