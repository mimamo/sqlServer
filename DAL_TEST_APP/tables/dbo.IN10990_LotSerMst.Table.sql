USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[IN10990_LotSerMst]    Script Date: 12/21/2015 13:56:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10990_LotSerMst](
	[Changed] [bit] NOT NULL,
	[Cost] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[ExpDate] [smalldatetime] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgrLotSerNbr] [char](25) NOT NULL,
	[MstStamp] [binary](8) NOT NULL,
	[OrigQty] [float] NOT NULL,
	[QtyOnHand] [float] NOT NULL,
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
	[SiteID] [char](10) NOT NULL,
	[Source] [char](2) NOT NULL,
	[SrcOrdNbr] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_Cost]  DEFAULT ((0)) FOR [Cost]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_ExpDate]  DEFAULT ('01/01/1900') FOR [ExpDate]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_LotSerNbr]  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_MfgrLotSerNbr]  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_OrigQty]  DEFAULT ((0)) FOR [OrigQty]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_QtyOnHand]  DEFAULT ((0)) FOR [QtyOnHand]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_ShipContCode]  DEFAULT (' ') FOR [ShipContCode]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_Source]  DEFAULT (' ') FOR [Source]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_SrcOrdNbr]  DEFAULT (' ') FOR [SrcOrdNbr]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_WarrantyDate]  DEFAULT ('01/01/1900') FOR [WarrantyDate]
GO
ALTER TABLE [dbo].[IN10990_LotSerMst] ADD  CONSTRAINT [DF_IN10990_LotSerMst_WhseLoc]  DEFAULT (' ') FOR [WhseLoc]
GO
