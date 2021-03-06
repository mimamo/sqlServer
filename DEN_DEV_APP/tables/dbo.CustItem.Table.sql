USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[CustItem]    Script Date: 12/21/2015 14:05:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustItem](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[CustItemID] [char](30) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LastSaleCost] [float] NOT NULL,
	[LastSaleDate] [smalldatetime] NOT NULL,
	[LastSalePrice] [float] NOT NULL,
	[LastSaleQty] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PYAvgCost] [float] NOT NULL,
	[PYAvgPrice] [float] NOT NULL,
	[PYCOGS] [float] NOT NULL,
	[PYCostRet] [float] NOT NULL,
	[PYOrders] [float] NOT NULL,
	[PYQtyRet] [float] NOT NULL,
	[PYQtySold] [float] NOT NULL,
	[PYSales] [float] NOT NULL,
	[PYSalesRet] [float] NOT NULL,
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
	[YTDAvgCost] [float] NOT NULL,
	[YTDAvgPrice] [float] NOT NULL,
	[YTDCOGS] [float] NOT NULL,
	[YTDCostRet] [float] NOT NULL,
	[YTDOrders] [float] NOT NULL,
	[YTDQtyRet] [float] NOT NULL,
	[YTDQtySold] [float] NOT NULL,
	[YTDSales] [float] NOT NULL,
	[YTDSalesRet] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_CustItemID]  DEFAULT (' ') FOR [CustItemID]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_FiscYr]  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LastSaleCost]  DEFAULT ((0)) FOR [LastSaleCost]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LastSaleDate]  DEFAULT ('01/01/1900') FOR [LastSaleDate]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LastSalePrice]  DEFAULT ((0)) FOR [LastSalePrice]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LastSaleQty]  DEFAULT ((0)) FOR [LastSaleQty]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYAvgCost]  DEFAULT ((0)) FOR [PYAvgCost]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYAvgPrice]  DEFAULT ((0)) FOR [PYAvgPrice]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYCOGS]  DEFAULT ((0)) FOR [PYCOGS]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYCostRet]  DEFAULT ((0)) FOR [PYCostRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYOrders]  DEFAULT ((0)) FOR [PYOrders]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYQtyRet]  DEFAULT ((0)) FOR [PYQtyRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYQtySold]  DEFAULT ((0)) FOR [PYQtySold]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYSales]  DEFAULT ((0)) FOR [PYSales]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_PYSalesRet]  DEFAULT ((0)) FOR [PYSalesRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDAvgCost]  DEFAULT ((0)) FOR [YTDAvgCost]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDAvgPrice]  DEFAULT ((0)) FOR [YTDAvgPrice]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDCOGS]  DEFAULT ((0)) FOR [YTDCOGS]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDCostRet]  DEFAULT ((0)) FOR [YTDCostRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDOrders]  DEFAULT ((0)) FOR [YTDOrders]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDQtyRet]  DEFAULT ((0)) FOR [YTDQtyRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDQtySold]  DEFAULT ((0)) FOR [YTDQtySold]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDSales]  DEFAULT ((0)) FOR [YTDSales]
GO
ALTER TABLE [dbo].[CustItem] ADD  CONSTRAINT [DF_CustItem_YTDSalesRet]  DEFAULT ((0)) FOR [YTDSalesRet]
GO
