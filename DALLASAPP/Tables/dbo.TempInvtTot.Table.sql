USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[TempInvtTot]    Script Date: 12/21/2015 13:44:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TempInvtTot](
	[AllocQty] [float] NOT NULL,
	[AvgCost] [float] NOT NULL,
	[BMIAvgCost] [float] NOT NULL,
	[BMIPerBegAmt] [float] NOT NULL,
	[BMIPtdCOGS] [float] NOT NULL,
	[BMIPtdCostIssd] [float] NOT NULL,
	[BMIPYCOGS] [float] NOT NULL,
	[BMIPYCostIssd] [float] NOT NULL,
	[BMITotCost] [float] NOT NULL,
	[BMIYtdCOGS] [float] NOT NULL,
	[BMIYtdCostIssd] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[InvtId] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerBegAmt] [float] NOT NULL,
	[PerBegQty] [float] NOT NULL,
	[PtdCOGS] [float] NOT NULL,
	[PtdCostIssd] [float] NOT NULL,
	[PtdQty] [float] NOT NULL,
	[PtdQtyIssd] [float] NOT NULL,
	[PtdSls] [float] NOT NULL,
	[PYCOGS] [float] NOT NULL,
	[PYCostIssd] [float] NOT NULL,
	[PYQty] [float] NOT NULL,
	[PYQtyIssd] [float] NOT NULL,
	[PYSls] [float] NOT NULL,
	[QtyAllocBM] [float] NOT NULL,
	[QtyAllocIN] [float] NOT NULL,
	[QtyAllocOther] [float] NOT NULL,
	[QtyAllocPORet] [float] NOT NULL,
	[QtyAllocSD] [float] NOT NULL,
	[QtyAllocSO] [float] NOT NULL,
	[QtyAvail] [float] NOT NULL,
	[QtyCustOrd] [float] NOT NULL,
	[QtyInTransit] [float] NOT NULL,
	[QtyNotAvail] [float] NOT NULL,
	[QtyOnBO] [float] NOT NULL,
	[QtyOnDP] [float] NOT NULL,
	[QtyOnHand] [float] NOT NULL,
	[QtyOnPO] [float] NOT NULL,
	[QtyShipNotInv] [float] NOT NULL,
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
	[SiteId] [char](10) NOT NULL,
	[TotCost] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[YtdCOGS] [float] NOT NULL,
	[YtdCostIssd] [float] NOT NULL,
	[YtdQty] [float] NOT NULL,
	[YtdQtyIssd] [float] NOT NULL,
	[YtdSls] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_AllocQty]  DEFAULT ((0)) FOR [AllocQty]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_AvgCost]  DEFAULT ((0)) FOR [AvgCost]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIAvgCost]  DEFAULT ((0)) FOR [BMIAvgCost]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIPerBegAmt]  DEFAULT ((0)) FOR [BMIPerBegAmt]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIPtdCOGS]  DEFAULT ((0)) FOR [BMIPtdCOGS]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIPtdCostIssd]  DEFAULT ((0)) FOR [BMIPtdCostIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIPYCOGS]  DEFAULT ((0)) FOR [BMIPYCOGS]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIPYCostIssd]  DEFAULT ((0)) FOR [BMIPYCostIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMITotCost]  DEFAULT ((0)) FOR [BMITotCost]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIYtdCOGS]  DEFAULT ((0)) FOR [BMIYtdCOGS]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_BMIYtdCostIssd]  DEFAULT ((0)) FOR [BMIYtdCostIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_InvtId]  DEFAULT (' ') FOR [InvtId]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PerBegAmt]  DEFAULT ((0)) FOR [PerBegAmt]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PerBegQty]  DEFAULT ((0)) FOR [PerBegQty]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PtdCOGS]  DEFAULT ((0)) FOR [PtdCOGS]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PtdCostIssd]  DEFAULT ((0)) FOR [PtdCostIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PtdQty]  DEFAULT ((0)) FOR [PtdQty]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PtdQtyIssd]  DEFAULT ((0)) FOR [PtdQtyIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PtdSls]  DEFAULT ((0)) FOR [PtdSls]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PYCOGS]  DEFAULT ((0)) FOR [PYCOGS]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PYCostIssd]  DEFAULT ((0)) FOR [PYCostIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PYQty]  DEFAULT ((0)) FOR [PYQty]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PYQtyIssd]  DEFAULT ((0)) FOR [PYQtyIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_PYSls]  DEFAULT ((0)) FOR [PYSls]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAllocBM]  DEFAULT ((0)) FOR [QtyAllocBM]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAllocIN]  DEFAULT ((0)) FOR [QtyAllocIN]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAllocOther]  DEFAULT ((0)) FOR [QtyAllocOther]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAllocPORet]  DEFAULT ((0)) FOR [QtyAllocPORet]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAllocSD]  DEFAULT ((0)) FOR [QtyAllocSD]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAllocSO]  DEFAULT ((0)) FOR [QtyAllocSO]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyAvail]  DEFAULT ((0)) FOR [QtyAvail]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyCustOrd]  DEFAULT ((0)) FOR [QtyCustOrd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyInTransit]  DEFAULT ((0)) FOR [QtyInTransit]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyNotAvail]  DEFAULT ((0)) FOR [QtyNotAvail]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyOnBO]  DEFAULT ((0)) FOR [QtyOnBO]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyOnDP]  DEFAULT ((0)) FOR [QtyOnDP]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyOnHand]  DEFAULT ((0)) FOR [QtyOnHand]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyOnPO]  DEFAULT ((0)) FOR [QtyOnPO]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_QtyShipNotInv]  DEFAULT ((0)) FOR [QtyShipNotInv]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_SiteId]  DEFAULT (' ') FOR [SiteId]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_TotCost]  DEFAULT ((0)) FOR [TotCost]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_YtdCOGS]  DEFAULT ((0)) FOR [YtdCOGS]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_YtdCostIssd]  DEFAULT ((0)) FOR [YtdCostIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_YtdQty]  DEFAULT ((0)) FOR [YtdQty]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_YtdQtyIssd]  DEFAULT ((0)) FOR [YtdQtyIssd]
GO
ALTER TABLE [dbo].[TempInvtTot] ADD  CONSTRAINT [DF_TempInvtTot_YtdSls]  DEFAULT ((0)) FOR [YtdSls]
GO
