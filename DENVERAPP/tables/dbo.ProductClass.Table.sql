USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[ProductClass]    Script Date: 12/21/2015 15:42:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductClass](
	[Buyer] [char](10) NOT NULL,
	[CFOvhMatlRate] [float] NOT NULL,
	[ChkOrdQty] [char](1) NOT NULL,
	[ClassID] [char](6) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CVOvhMatlRate] [float] NOT NULL,
	[Descr] [char](30) NOT NULL,
	[DfltCOGSAcct] [char](10) NOT NULL,
	[DfltCOGSSub] [char](24) NOT NULL,
	[DfltDiscPrc] [char](1) NOT NULL,
	[DfltInvtAcct] [char](10) NOT NULL,
	[DfltInvtSub] [char](24) NOT NULL,
	[DfltInvtType] [char](1) NOT NULL,
	[DfltLCVarianceAcct] [char](10) NOT NULL,
	[DfltLCVarianceSub] [char](24) NOT NULL,
	[DfltLotSerAssign] [char](1) NOT NULL,
	[DfltLotSerFxdLen] [smallint] NOT NULL,
	[DfltLotSerFxdTyp] [char](1) NOT NULL,
	[DfltLotSerFxdVal] [char](12) NOT NULL,
	[DfltLotSerMthd] [char](1) NOT NULL,
	[DfltLotSerNumLen] [smallint] NOT NULL,
	[DfltLotSerNumVal] [char](25) NOT NULL,
	[DfltLotSerShelfLife] [smallint] NOT NULL,
	[DfltLotSerTrack] [char](1) NOT NULL,
	[DfltPOUnit] [char](6) NOT NULL,
	[DfltPPVAcct] [char](10) NOT NULL,
	[DfltPPVSub] [char](24) NOT NULL,
	[DfltSalesAcct] [char](10) NOT NULL,
	[DfltSalesSub] [char](24) NOT NULL,
	[DfltShpNotInvAcct] [char](10) NOT NULL,
	[DfltShpnotInvSub] [char](24) NOT NULL,
	[DfltSite] [char](10) NOT NULL,
	[DfltSlsTaxCat] [char](10) NOT NULL,
	[DfltSOUnit] [char](6) NOT NULL,
	[DfltSource] [char](1) NOT NULL,
	[DfltStatus] [char](1) NOT NULL,
	[DfltStkItem] [smallint] NOT NULL,
	[DfltStkWt] [float] NOT NULL,
	[DfltStkWtUnit] [char](6) NOT NULL,
	[DfltValMthd] [char](1) NOT NULL,
	[DfltWarrantyDays] [smallint] NOT NULL,
	[ExplInvoice] [smallint] NOT NULL,
	[ExplOrder] [smallint] NOT NULL,
	[ExplPackSlip] [smallint] NOT NULL,
	[ExplPickList] [smallint] NOT NULL,
	[ExplShipping] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaterialType] [char](10) NOT NULL,
	[MinGrossProfit] [float] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PFOvhMatlRate] [float] NOT NULL,
	[PVOvhMatlRate] [float] NOT NULL,
	[RollupCost] [smallint] NOT NULL,
	[RollupPrice] [smallint] NOT NULL,
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
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_Buyer]  DEFAULT (' ') FOR [Buyer]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_CFOvhMatlRate]  DEFAULT ((0)) FOR [CFOvhMatlRate]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ChkOrdQty]  DEFAULT (' ') FOR [ChkOrdQty]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ClassID]  DEFAULT (' ') FOR [ClassID]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_CVOvhMatlRate]  DEFAULT ((0)) FOR [CVOvhMatlRate]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_Descr]  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltCOGSAcct]  DEFAULT (' ') FOR [DfltCOGSAcct]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltCOGSSub]  DEFAULT (' ') FOR [DfltCOGSSub]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltDiscPrc]  DEFAULT (' ') FOR [DfltDiscPrc]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltInvtAcct]  DEFAULT (' ') FOR [DfltInvtAcct]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltInvtSub]  DEFAULT (' ') FOR [DfltInvtSub]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltInvtType]  DEFAULT (' ') FOR [DfltInvtType]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLCVarianceAcct]  DEFAULT (' ') FOR [DfltLCVarianceAcct]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLCVarianceSub]  DEFAULT (' ') FOR [DfltLCVarianceSub]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerAssign]  DEFAULT (' ') FOR [DfltLotSerAssign]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerFxdLen]  DEFAULT ((0)) FOR [DfltLotSerFxdLen]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerFxdTyp]  DEFAULT (' ') FOR [DfltLotSerFxdTyp]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerFxdVal]  DEFAULT (' ') FOR [DfltLotSerFxdVal]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerMthd]  DEFAULT (' ') FOR [DfltLotSerMthd]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerNumLen]  DEFAULT ((0)) FOR [DfltLotSerNumLen]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerNumVal]  DEFAULT (' ') FOR [DfltLotSerNumVal]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerShelfLife]  DEFAULT ((0)) FOR [DfltLotSerShelfLife]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltLotSerTrack]  DEFAULT (' ') FOR [DfltLotSerTrack]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltPOUnit]  DEFAULT (' ') FOR [DfltPOUnit]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltPPVAcct]  DEFAULT (' ') FOR [DfltPPVAcct]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltPPVSub]  DEFAULT (' ') FOR [DfltPPVSub]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltSalesAcct]  DEFAULT (' ') FOR [DfltSalesAcct]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltSalesSub]  DEFAULT (' ') FOR [DfltSalesSub]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltShpNotInvAcct]  DEFAULT (' ') FOR [DfltShpNotInvAcct]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltShpnotInvSub]  DEFAULT (' ') FOR [DfltShpnotInvSub]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltSite]  DEFAULT (' ') FOR [DfltSite]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltSlsTaxCat]  DEFAULT (' ') FOR [DfltSlsTaxCat]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltSOUnit]  DEFAULT (' ') FOR [DfltSOUnit]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltSource]  DEFAULT (' ') FOR [DfltSource]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltStatus]  DEFAULT (' ') FOR [DfltStatus]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltStkItem]  DEFAULT ((0)) FOR [DfltStkItem]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltStkWt]  DEFAULT ((0)) FOR [DfltStkWt]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltStkWtUnit]  DEFAULT (' ') FOR [DfltStkWtUnit]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltValMthd]  DEFAULT (' ') FOR [DfltValMthd]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_DfltWarrantyDays]  DEFAULT ((0)) FOR [DfltWarrantyDays]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ExplInvoice]  DEFAULT ((0)) FOR [ExplInvoice]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ExplOrder]  DEFAULT ((0)) FOR [ExplOrder]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ExplPackSlip]  DEFAULT ((0)) FOR [ExplPackSlip]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ExplPickList]  DEFAULT ((0)) FOR [ExplPickList]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_ExplShipping]  DEFAULT ((0)) FOR [ExplShipping]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_MaterialType]  DEFAULT (' ') FOR [MaterialType]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_MinGrossProfit]  DEFAULT ((0)) FOR [MinGrossProfit]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_PFOvhMatlRate]  DEFAULT ((0)) FOR [PFOvhMatlRate]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_PVOvhMatlRate]  DEFAULT ((0)) FOR [PVOvhMatlRate]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_RollupCost]  DEFAULT ((0)) FOR [RollupCost]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_RollupPrice]  DEFAULT ((0)) FOR [RollupPrice]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[ProductClass] ADD  CONSTRAINT [DF_ProductClass_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
