USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[CustItem]    Script Date: 12/21/2015 14:26:28 ******/
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
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [CustItemID]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [LastSaleCost]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ('01/01/1900') FOR [LastSaleDate]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [LastSalePrice]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [LastSaleQty]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYAvgCost]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYAvgPrice]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYCOGS]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYCostRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYOrders]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYQtyRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYQtySold]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYSales]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [PYSalesRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDAvgCost]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDAvgPrice]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDCOGS]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDCostRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDOrders]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDQtyRet]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDQtySold]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDSales]
GO
ALTER TABLE [dbo].[CustItem] ADD  DEFAULT ((0)) FOR [YTDSalesRet]
GO
