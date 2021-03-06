USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[LotSerTArch]    Script Date: 12/21/2015 16:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LotSerTArch](
	[BatNbr] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[ExpDate] [smalldatetime] NOT NULL,
	[INTranLineID] [int] NOT NULL,
	[INTranLineRef] [char](5) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[InvtMult] [smallint] NOT NULL,
	[KitID] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LotSerRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgrLotSerNbr] [char](25) NOT NULL,
	[NoQtyUpdate] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[ParInvtID] [char](30) NOT NULL,
	[ParLotSerNbr] [char](25) NOT NULL,
	[Qty] [float] NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
	[RecordID] [int] NOT NULL,
	[RefNbr] [char](15) NOT NULL,
	[Retired] [smallint] NOT NULL,
	[Rlsed] [smallint] NOT NULL,
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
	[ShipContCode] [char](20) NOT NULL,
	[ShipmentNbr] [smallint] NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[ToSiteID] [char](10) NOT NULL,
	[ToWhseLoc] [char](10) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranSrc] [char](2) NOT NULL,
	[TranTime] [smalldatetime] NOT NULL,
	[TranType] [char](2) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WarrantyDate] [smalldatetime] NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [ExpDate]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [INTranLineID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [INTranLineRef]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [InvtMult]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [LotSerRef]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [NoQtyUpdate]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [ParInvtID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [ParLotSerNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [RecordID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [Retired]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [ShipContCode]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [ShipmentNbr]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [ToSiteID]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [ToWhseLoc]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [TranSrc]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [TranTime]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT ('01/01/1900') FOR [WarrantyDate]
GO
ALTER TABLE [dbo].[LotSerTArch] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
