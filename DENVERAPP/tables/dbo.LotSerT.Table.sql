USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[LotSerT]    Script Date: 12/21/2015 15:42:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LotSerT](
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
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_BatNbr]  DEFAULT (' ') FOR [BatNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ExpDate]  DEFAULT ('01/01/1900') FOR [ExpDate]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_INTranLineID]  DEFAULT ((0)) FOR [INTranLineID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_INTranLineRef]  DEFAULT (' ') FOR [INTranLineRef]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_InvtMult]  DEFAULT ((0)) FOR [InvtMult]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_LotSerNbr]  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_LotSerRef]  DEFAULT (' ') FOR [LotSerRef]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_MfgrLotSerNbr]  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_NoQtyUpdate]  DEFAULT ((0)) FOR [NoQtyUpdate]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ParInvtID]  DEFAULT (' ') FOR [ParInvtID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ParLotSerNbr]  DEFAULT (' ') FOR [ParLotSerNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_RcptNbr]  DEFAULT (' ') FOR [RcptNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_RefNbr]  DEFAULT (' ') FOR [RefNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_Retired]  DEFAULT ((0)) FOR [Retired]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_Rlsed]  DEFAULT ((0)) FOR [Rlsed]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ShipContCode]  DEFAULT (' ') FOR [ShipContCode]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ShipmentNbr]  DEFAULT ((0)) FOR [ShipmentNbr]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ToSiteID]  DEFAULT (' ') FOR [ToSiteID]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_ToWhseLoc]  DEFAULT (' ') FOR [ToWhseLoc]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_TranDate]  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_TranSrc]  DEFAULT (' ') FOR [TranSrc]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_TranTime]  DEFAULT ('01/01/1900') FOR [TranTime]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_TranType]  DEFAULT (' ') FOR [TranType]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_UnitPrice]  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_WarrantyDate]  DEFAULT ('01/01/1900') FOR [WarrantyDate]
GO
ALTER TABLE [dbo].[LotSerT] ADD  CONSTRAINT [DF_LotSerT_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
