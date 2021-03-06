USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[InventoryADG]    Script Date: 12/21/2015 16:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InventoryADG](
	[AllowGenCont] [smallint] NOT NULL,
	[BatchSize] [float] NOT NULL,
	[BOLClass] [char](20) NOT NULL,
	[CategoryCode] [char](10) NOT NULL,
	[CountryOrig] [char](20) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Density] [float] NOT NULL,
	[DensityUOM] [char](5) NOT NULL,
	[Depth] [float] NOT NULL,
	[DepthUOM] [char](5) NOT NULL,
	[Diameter] [float] NOT NULL,
	[DiameterUOM] [char](5) NOT NULL,
	[Gauge] [float] NOT NULL,
	[GaugeUOM] [char](5) NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](5) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](5) NOT NULL,
	[ListPrice] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MinPrice] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OMCOGSAcct] [char](10) NOT NULL,
	[OMCOGSSub] [char](31) NOT NULL,
	[OMSalesAcct] [char](10) NOT NULL,
	[OMSalesSub] [char](31) NOT NULL,
	[Pack] [smallint] NOT NULL,
	[PackCnvFact] [float] NOT NULL,
	[PackMethod] [char](2) NOT NULL,
	[PackSize] [smallint] NOT NULL,
	[PackUnitMultDiv] [char](1) NOT NULL,
	[PackUOM] [char](6) NOT NULL,
	[ProdLineID] [char](4) NOT NULL,
	[RetailPrice] [float] NOT NULL,
	[RoyaltyCode] [char](10) NOT NULL,
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
	[SCHeight] [float] NOT NULL,
	[SCHeightUOM] [char](6) NOT NULL,
	[SCLen] [float] NOT NULL,
	[SCLenUOM] [char](6) NOT NULL,
	[SCVolume] [float] NOT NULL,
	[SCVolumeUOM] [char](6) NOT NULL,
	[SCWeight] [float] NOT NULL,
	[SCWeightUOM] [char](6) NOT NULL,
	[SCWidth] [float] NOT NULL,
	[SCWidthUOM] [char](6) NOT NULL,
	[StdCartonBreak] [smallint] NOT NULL,
	[StdGrossWt] [float] NOT NULL,
	[StdTareWt] [float] NOT NULL,
	[Style] [char](20) NOT NULL,
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
	[VolUOM] [char](6) NOT NULL,
	[Weight] [float] NOT NULL,
	[WeightUOM] [char](6) NOT NULL,
	[Width] [float] NOT NULL,
	[WidthUOM] [char](5) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [AllowGenCont]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [BatchSize]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [BOLClass]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [CategoryCode]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [CountryOrig]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Density]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [DensityUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Depth]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [DepthUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Diameter]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [DiameterUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Gauge]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [GaugeUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [ListPrice]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [MinPrice]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [OMCOGSAcct]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [OMCOGSSub]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [OMSalesAcct]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [OMSalesSub]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Pack]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [PackCnvFact]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [PackMethod]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [PackSize]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [PackUnitMultDiv]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [PackUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [ProdLineID]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [RetailPrice]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [RoyaltyCode]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [SCHeight]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [SCHeightUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [SCLen]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [SCLenUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [SCVolume]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [SCVolumeUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [SCWeight]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [SCWeightUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [SCWidth]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [SCWidthUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [StdCartonBreak]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [StdGrossWt]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [StdTareWt]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [Style]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [VolUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[InventoryADG] ADD  DEFAULT (' ') FOR [WidthUOM]
GO
