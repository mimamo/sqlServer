USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[ED810LineItem]    Script Date: 12/21/2015 16:00:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ED810LineItem](
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
	[Descr] [char](60) NOT NULL,
	[EAN] [char](48) NOT NULL,
	[EDIInvID] [char](10) NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](6) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[ISBN] [char](48) NOT NULL,
	[ItemColor] [char](30) NOT NULL,
	[ItemSize] [char](30) NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MemaCode] [char](48) NOT NULL,
	[MfgPart] [char](48) NOT NULL,
	[MilSpec] [char](48) NOT NULL,
	[NDC] [char](48) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Pack] [smallint] NOT NULL,
	[PackSize] [smallint] NOT NULL,
	[PackUOM] [char](6) NOT NULL,
	[POLineRef] [char](5) NOT NULL,
	[Price] [float] NOT NULL,
	[PriceExt] [float] NOT NULL,
	[PrintNbr] [char](48) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[QtyInvoiced] [float] NOT NULL,
	[QtyInvoicedUOM] [char](6) NOT NULL,
	[QtyOrdered] [float] NOT NULL,
	[QtyOrderedUOM] [char](6) NOT NULL,
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
	[ShipToSite] [char](10) NOT NULL,
	[SKU] [char](48) NOT NULL,
	[Style] [char](20) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[UCC] [char](48) NOT NULL,
	[UnitPriceBasis] [char](5) NOT NULL,
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
	[VendorLineRef] [char](20) NOT NULL,
	[VendorPartNbr] [char](48) NOT NULL,
	[Volume] [float] NOT NULL,
	[VolumeUOM] [char](6) NOT NULL,
	[Weight] [float] NOT NULL,
	[WeightUOM] [char](6) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[Width] [float] NOT NULL,
	[WidthUOM] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [CuryPrice]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [CuryPriceExt]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [EAN]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [EDIInvID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [ISBN]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [ItemColor]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [ItemSize]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [MemaCode]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [MfgPart]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [MilSpec]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [NDC]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Pack]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [PackSize]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [PackUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [POLineRef]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [PriceExt]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [PrintNbr]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [ProjectID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [QtyInvoiced]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [QtyInvoicedUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [QtyOrdered]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [QtyOrderedUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [ShipToSite]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [SKU]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [Style]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [TaskID]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [UCC]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [UnitPriceBasis]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [UPC]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [VendorLineRef]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [VendorPartNbr]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[ED810LineItem] ADD  DEFAULT (' ') FOR [WidthUOM]
GO
