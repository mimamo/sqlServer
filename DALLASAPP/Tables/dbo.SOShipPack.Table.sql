USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[SOShipPack]    Script Date: 12/21/2015 13:44:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOShipPack](
	[BaseCost] [float] NOT NULL,
	[BaseInvc] [float] NOT NULL,
	[BoxRef] [char](5) NOT NULL,
	[CartonID] [char](20) NOT NULL,
	[CODAmt] [float] NOT NULL,
	[CODCost] [float] NOT NULL,
	[CODInvc] [float] NOT NULL,
	[ContainerID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryBaseCost] [float] NOT NULL,
	[CuryBaseInvc] [float] NOT NULL,
	[CuryCODAmt] [float] NOT NULL,
	[CuryCODCost] [float] NOT NULL,
	[CuryCODInvc] [float] NOT NULL,
	[CuryFrtCost] [float] NOT NULL,
	[CuryFrtInvc] [float] NOT NULL,
	[CuryHandlingChg] [float] NOT NULL,
	[CuryInsureCost] [float] NOT NULL,
	[CuryInsureInvc] [float] NOT NULL,
	[CuryOtherCost] [float] NOT NULL,
	[CuryOtherInvc] [float] NOT NULL,
	[CuryOversizeCost] [float] NOT NULL,
	[CuryOversizeInvc] [float] NOT NULL,
	[FrtCost] [float] NOT NULL,
	[FrtInvc] [float] NOT NULL,
	[HandlingChg] [float] NOT NULL,
	[InsureCost] [float] NOT NULL,
	[InsureInvc] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OtherCost] [float] NOT NULL,
	[OtherInvc] [float] NOT NULL,
	[OversizeCost] [float] NOT NULL,
	[OversizeInvc] [float] NOT NULL,
	[PackageID] [char](15) NOT NULL,
	[PalletID] [char](20) NOT NULL,
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
	[TrackingNbr] [char](20) NOT NULL,
	[TruckID] [char](18) NOT NULL,
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
	[Wght] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_BaseCost]  DEFAULT ((0)) FOR [BaseCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_BaseInvc]  DEFAULT ((0)) FOR [BaseInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_BoxRef]  DEFAULT (' ') FOR [BoxRef]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CartonID]  DEFAULT (' ') FOR [CartonID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CODAmt]  DEFAULT ((0)) FOR [CODAmt]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CODCost]  DEFAULT ((0)) FOR [CODCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CODInvc]  DEFAULT ((0)) FOR [CODInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_ContainerID]  DEFAULT (' ') FOR [ContainerID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryBaseCost]  DEFAULT ((0)) FOR [CuryBaseCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryBaseInvc]  DEFAULT ((0)) FOR [CuryBaseInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryCODAmt]  DEFAULT ((0)) FOR [CuryCODAmt]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryCODCost]  DEFAULT ((0)) FOR [CuryCODCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryCODInvc]  DEFAULT ((0)) FOR [CuryCODInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryFrtCost]  DEFAULT ((0)) FOR [CuryFrtCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryFrtInvc]  DEFAULT ((0)) FOR [CuryFrtInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryHandlingChg]  DEFAULT ((0)) FOR [CuryHandlingChg]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryInsureCost]  DEFAULT ((0)) FOR [CuryInsureCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryInsureInvc]  DEFAULT ((0)) FOR [CuryInsureInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryOtherCost]  DEFAULT ((0)) FOR [CuryOtherCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryOtherInvc]  DEFAULT ((0)) FOR [CuryOtherInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryOversizeCost]  DEFAULT ((0)) FOR [CuryOversizeCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_CuryOversizeInvc]  DEFAULT ((0)) FOR [CuryOversizeInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_FrtCost]  DEFAULT ((0)) FOR [FrtCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_FrtInvc]  DEFAULT ((0)) FOR [FrtInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_HandlingChg]  DEFAULT ((0)) FOR [HandlingChg]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_InsureCost]  DEFAULT ((0)) FOR [InsureCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_InsureInvc]  DEFAULT ((0)) FOR [InsureInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_OtherCost]  DEFAULT ((0)) FOR [OtherCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_OtherInvc]  DEFAULT ((0)) FOR [OtherInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_OversizeCost]  DEFAULT ((0)) FOR [OversizeCost]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_OversizeInvc]  DEFAULT ((0)) FOR [OversizeInvc]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_PackageID]  DEFAULT (' ') FOR [PackageID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_PalletID]  DEFAULT (' ') FOR [PalletID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_TrackingNbr]  DEFAULT (' ') FOR [TrackingNbr]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_TruckID]  DEFAULT (' ') FOR [TruckID]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_Volume]  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[SOShipPack] ADD  CONSTRAINT [DF_SOShipPack_Wght]  DEFAULT ((0)) FOR [Wght]
GO
