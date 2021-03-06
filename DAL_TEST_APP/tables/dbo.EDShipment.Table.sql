USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[EDShipment]    Script Date: 12/21/2015 13:56:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDShipment](
	[AddWeight] [float] NOT NULL,
	[AHCharge] [float] NOT NULL,
	[AirbillNbr] [char](30) NOT NULL,
	[BOLNbr] [char](20) NOT NULL,
	[BOLState] [char](1) NOT NULL,
	[CODCharge] [float] NOT NULL,
	[CommCodeQual] [char](2) NOT NULL,
	[ConsignAddr1] [char](35) NOT NULL,
	[ConsignAddr2] [char](35) NOT NULL,
	[ConsignAddr3] [char](35) NOT NULL,
	[ConsignCity] [char](19) NOT NULL,
	[ConsignCountry] [char](3) NOT NULL,
	[ConsignName] [char](35) NOT NULL,
	[ConsignState] [char](3) NOT NULL,
	[ConsignZip] [char](10) NOT NULL,
	[CrossDock] [char](20) NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAHCharge] [float] NOT NULL,
	[CuryCODCharge] [float] NOT NULL,
	[CuryHazCharge] [float] NOT NULL,
	[CuryInsurCharge] [float] NOT NULL,
	[CuryMiscCharge] [float] NOT NULL,
	[CuryOverSizeCharge] [float] NOT NULL,
	[CuryPickupCharge] [float] NOT NULL,
	[CuryShipCharge] [float] NOT NULL,
	[CurySurCharge] [float] NOT NULL,
	[CuryTotBillCharge] [float] NOT NULL,
	[CuryTotShipCharge] [float] NOT NULL,
	[CuryTrackCharge] [float] NOT NULL,
	[EquipNbr] [char](20) NOT NULL,
	[HazCharge] [float] NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](6) NOT NULL,
	[InsurCharge] [float] NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MiscCharge] [float] NOT NULL,
	[NbrContainer] [smallint] NOT NULL,
	[NoteId] [int] NOT NULL,
	[OverSizeCharge] [float] NOT NULL,
	[PackMethod] [char](2) NOT NULL,
	[PickupCharge] [float] NOT NULL,
	[Pro] [char](30) NOT NULL,
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
	[SCAC] [char](5) NOT NULL,
	[SendASN] [smallint] NOT NULL,
	[ShipperAddr1] [char](35) NOT NULL,
	[ShipperAddr2] [char](35) NOT NULL,
	[ShipperAddr3] [char](35) NOT NULL,
	[ShipperCity] [char](19) NOT NULL,
	[ShipperCountry] [char](3) NOT NULL,
	[ShipperName] [char](35) NOT NULL,
	[ShipperState] [char](3) NOT NULL,
	[ShipperZip] [char](10) NOT NULL,
	[ShipStatus] [char](1) NOT NULL,
	[ShpCharge] [float] NOT NULL,
	[ShpDate] [smalldatetime] NOT NULL,
	[ShpTime] [char](10) NOT NULL,
	[ShpWeight] [float] NOT NULL,
	[ShpWeightUom] [char](6) NOT NULL,
	[Surcharge] [float] NOT NULL,
	[TotBillCharge] [float] NOT NULL,
	[TotShipCharge] [float] NOT NULL,
	[TrackCharge] [float] NOT NULL,
	[TrackingNbr] [char](30) NOT NULL,
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
	[ViaCode] [char](15) NOT NULL,
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
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_AddWeight]  DEFAULT ((0)) FOR [AddWeight]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_AHCharge]  DEFAULT ((0)) FOR [AHCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_AirbillNbr]  DEFAULT (' ') FOR [AirbillNbr]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_BOLNbr]  DEFAULT (' ') FOR [BOLNbr]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_BOLState]  DEFAULT (' ') FOR [BOLState]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CODCharge]  DEFAULT ((0)) FOR [CODCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CommCodeQual]  DEFAULT (' ') FOR [CommCodeQual]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignAddr1]  DEFAULT (' ') FOR [ConsignAddr1]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignAddr2]  DEFAULT (' ') FOR [ConsignAddr2]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignAddr3]  DEFAULT (' ') FOR [ConsignAddr3]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignCity]  DEFAULT (' ') FOR [ConsignCity]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignCountry]  DEFAULT (' ') FOR [ConsignCountry]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignName]  DEFAULT (' ') FOR [ConsignName]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignState]  DEFAULT (' ') FOR [ConsignState]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ConsignZip]  DEFAULT (' ') FOR [ConsignZip]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CrossDock]  DEFAULT (' ') FOR [CrossDock]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Crtd_Datetime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryAHCharge]  DEFAULT ((0)) FOR [CuryAHCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryCODCharge]  DEFAULT ((0)) FOR [CuryCODCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryHazCharge]  DEFAULT ((0)) FOR [CuryHazCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryInsurCharge]  DEFAULT ((0)) FOR [CuryInsurCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryMiscCharge]  DEFAULT ((0)) FOR [CuryMiscCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryOverSizeCharge]  DEFAULT ((0)) FOR [CuryOverSizeCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryPickupCharge]  DEFAULT ((0)) FOR [CuryPickupCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryShipCharge]  DEFAULT ((0)) FOR [CuryShipCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CurySurCharge]  DEFAULT ((0)) FOR [CurySurCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryTotBillCharge]  DEFAULT ((0)) FOR [CuryTotBillCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryTotShipCharge]  DEFAULT ((0)) FOR [CuryTotShipCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_CuryTrackCharge]  DEFAULT ((0)) FOR [CuryTrackCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_EquipNbr]  DEFAULT (' ') FOR [EquipNbr]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_HazCharge]  DEFAULT ((0)) FOR [HazCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_HeightUOM]  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_InsurCharge]  DEFAULT ((0)) FOR [InsurCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Len]  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_LenUOM]  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Lupd_Datetime]  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Lupd_Prog]  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Lupd_User]  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_MiscCharge]  DEFAULT ((0)) FOR [MiscCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_NbrContainer]  DEFAULT ((0)) FOR [NbrContainer]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_NoteId]  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_OverSizeCharge]  DEFAULT ((0)) FOR [OverSizeCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_PackMethod]  DEFAULT (' ') FOR [PackMethod]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_PickupCharge]  DEFAULT ((0)) FOR [PickupCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Pro]  DEFAULT (' ') FOR [Pro]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_SCAC]  DEFAULT (' ') FOR [SCAC]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_SendASN]  DEFAULT ((0)) FOR [SendASN]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperAddr1]  DEFAULT (' ') FOR [ShipperAddr1]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperAddr2]  DEFAULT (' ') FOR [ShipperAddr2]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperAddr3]  DEFAULT (' ') FOR [ShipperAddr3]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperCity]  DEFAULT (' ') FOR [ShipperCity]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperCountry]  DEFAULT (' ') FOR [ShipperCountry]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperName]  DEFAULT (' ') FOR [ShipperName]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperState]  DEFAULT (' ') FOR [ShipperState]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipperZip]  DEFAULT (' ') FOR [ShipperZip]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShipStatus]  DEFAULT (' ') FOR [ShipStatus]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShpCharge]  DEFAULT ((0)) FOR [ShpCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShpDate]  DEFAULT ('01/01/1900') FOR [ShpDate]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShpTime]  DEFAULT (' ') FOR [ShpTime]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShpWeight]  DEFAULT ((0)) FOR [ShpWeight]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ShpWeightUom]  DEFAULT (' ') FOR [ShpWeightUom]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Surcharge]  DEFAULT ((0)) FOR [Surcharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_TotBillCharge]  DEFAULT ((0)) FOR [TotBillCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_TotShipCharge]  DEFAULT ((0)) FOR [TotShipCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_TrackCharge]  DEFAULT ((0)) FOR [TrackCharge]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_TrackingNbr]  DEFAULT (' ') FOR [TrackingNbr]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_ViaCode]  DEFAULT (' ') FOR [ViaCode]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Volume]  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_VolumeUOM]  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Weight]  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_WeightUOM]  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[EDShipment] ADD  CONSTRAINT [DF_EDShipment_WidthUOM]  DEFAULT (' ') FOR [WidthUOM]
GO
