USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[EDContainer]    Script Date: 12/21/2015 14:16:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDContainer](
	[AHCharge] [float] NOT NULL,
	[AirBillNbr] [char](30) NOT NULL,
	[BillFreightAmt] [float] NOT NULL,
	[BolNbr] [char](20) NOT NULL,
	[CODCharge] [float] NOT NULL,
	[ContainerID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAHCharge] [float] NOT NULL,
	[CuryBillFreightAmt] [float] NOT NULL,
	[CuryCODCharge] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryFreightAmt] [float] NOT NULL,
	[CuryHazCharge] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryInsurCharge] [float] NOT NULL,
	[CuryMiscCharge] [float] NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryOverSizeCharge] [float] NOT NULL,
	[CuryPickupCharge] [float] NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CuryShpCharge] [float] NOT NULL,
	[CurySurCharge] [float] NOT NULL,
	[CuryTotBillCharge] [float] NOT NULL,
	[CuryTotShipCharge] [float] NOT NULL,
	[CuryTrackCharge] [float] NOT NULL,
	[FreightAmt] [float] NOT NULL,
	[HazCharge] [float] NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](6) NOT NULL,
	[InsurCharge] [float] NOT NULL,
	[LabelLastPrinted] [smalldatetime] NOT NULL,
	[LabelPrinted] [smallint] NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MiscCharge] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OverSizeCharge] [float] NOT NULL,
	[PackMethod] [char](2) NOT NULL,
	[PickupCharge] [float] NOT NULL,
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
	[ShipperID] [char](15) NOT NULL,
	[ShipStatus] [char](1) NOT NULL,
	[ShpCharge] [float] NOT NULL,
	[ShpDate] [smalldatetime] NOT NULL,
	[ShpTime] [char](10) NOT NULL,
	[ShpWeight] [float] NOT NULL,
	[SurCharge] [float] NOT NULL,
	[TareFlag] [smallint] NOT NULL,
	[TareID] [char](10) NOT NULL,
	[TotBillCharge] [float] NOT NULL,
	[TotShipCharge] [float] NOT NULL,
	[TrackCharge] [float] NOT NULL,
	[TrackingNbr] [char](30) NOT NULL,
	[UCC128] [char](20) NOT NULL,
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
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [AHCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [AirBillNbr]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [BillFreightAmt]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [BolNbr]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CODCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [ContainerID]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryAHCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryBillFreightAmt]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryCODCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryFreightAmt]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryHazCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryInsurCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryMiscCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryOverSizeCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryPickupCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryShpCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CurySurCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryTotBillCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryTotShipCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [CuryTrackCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [FreightAmt]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [HazCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [InsurCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [LabelLastPrinted]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [LabelPrinted]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [MiscCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [OverSizeCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [PackMethod]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [PickupCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [ShipStatus]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [ShpCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [ShpDate]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [ShpTime]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [ShpWeight]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [SurCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [TareFlag]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [TareID]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [TotBillCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [TotShipCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [TrackCharge]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [TrackingNbr]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [UCC128]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[EDContainer] ADD  DEFAULT (' ') FOR [WidthUOM]
GO
