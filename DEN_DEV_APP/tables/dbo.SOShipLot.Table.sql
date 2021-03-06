USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[SOShipLot]    Script Date: 12/21/2015 14:05:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOShipLot](
	[BoxRef] [char](5) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DropShip] [smallint] NOT NULL,
	[InvtId] [char](30) NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LotSerRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgrLotSerNbr] [char](25) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrdLineRef] [char](5) NOT NULL,
	[OrdLotSerRef] [char](5) NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[OrdSchedRef] [char](5) NOT NULL,
	[QtyPick] [float] NOT NULL,
	[QtyPickStock] [float] NOT NULL,
	[QtyShip] [float] NOT NULL,
	[RMADisposition] [char](3) NOT NULL,
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
	[SpecificCostID] [char](25) NOT NULL,
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
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_BoxRef]  DEFAULT (' ') FOR [BoxRef]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_DropShip]  DEFAULT ((0)) FOR [DropShip]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_InvtId]  DEFAULT (' ') FOR [InvtId]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_LineRef]  DEFAULT (' ') FOR [LineRef]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_LotSerNbr]  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_LotSerRef]  DEFAULT (' ') FOR [LotSerRef]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_MfgrLotSerNbr]  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_OrdLineRef]  DEFAULT (' ') FOR [OrdLineRef]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_OrdLotSerRef]  DEFAULT (' ') FOR [OrdLotSerRef]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_OrdSchedRef]  DEFAULT (' ') FOR [OrdSchedRef]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_QtyPick]  DEFAULT ((0)) FOR [QtyPick]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_QtyPickStock]  DEFAULT ((0)) FOR [QtyPickStock]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_QtyShip]  DEFAULT ((0)) FOR [QtyShip]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_RMADisposition]  DEFAULT (' ') FOR [RMADisposition]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_SpecificCostID]  DEFAULT (' ') FOR [SpecificCostID]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOShipLot] ADD  CONSTRAINT [DF_SOShipLot_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
