USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[SFWork2]    Script Date: 12/21/2015 13:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SFWork2](
	[CnvFact] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CustClassDescr] [char](30) NOT NULL,
	[CustClassID] [char](6) NOT NULL,
	[DetRef] [char](5) NOT NULL,
	[DiscPct] [float] NOT NULL,
	[DiscPctS4] [float] NOT NULL,
	[DiscPrcMthd] [char](1) NOT NULL,
	[DiscPrice] [float] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[Exclude] [smallint] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ItemCost] [float] NOT NULL,
	[MaxQty] [float] NOT NULL,
	[MinQty] [float] NOT NULL,
	[MultDiv] [char](1) NOT NULL,
	[PriceBasis] [float] NOT NULL,
	[PriceChgFlag] [smallint] NOT NULL,
	[QtySold] [float] NOT NULL,
	[RvsdDiscPct] [float] NOT NULL,
	[RvsdDiscPrice] [float] NOT NULL,
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
	[SlsPrcID] [char](15) NOT NULL,
	[SlsUnit] [char](6) NOT NULL,
	[SPID] [smallint] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[UOM] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_CustClassDescr]  DEFAULT (' ') FOR [CustClassDescr]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_CustClassID]  DEFAULT (' ') FOR [CustClassID]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_DetRef]  DEFAULT (' ') FOR [DetRef]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_DiscPct]  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_DiscPctS4]  DEFAULT ((0)) FOR [DiscPctS4]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_DiscPrcMthd]  DEFAULT (' ') FOR [DiscPrcMthd]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_DiscPrice]  DEFAULT ((0)) FOR [DiscPrice]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_EndDate]  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_Exclude]  DEFAULT ((0)) FOR [Exclude]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_ItemCost]  DEFAULT ((0)) FOR [ItemCost]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_MaxQty]  DEFAULT ((0)) FOR [MaxQty]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_MinQty]  DEFAULT ((0)) FOR [MinQty]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_MultDiv]  DEFAULT (' ') FOR [MultDiv]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_PriceBasis]  DEFAULT ((0)) FOR [PriceBasis]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_PriceChgFlag]  DEFAULT ((0)) FOR [PriceChgFlag]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_QtySold]  DEFAULT ((0)) FOR [QtySold]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_RvsdDiscPct]  DEFAULT ((0)) FOR [RvsdDiscPct]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_RvsdDiscPrice]  DEFAULT ((0)) FOR [RvsdDiscPrice]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_SlsPrcID]  DEFAULT (' ') FOR [SlsPrcID]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_SlsUnit]  DEFAULT (' ') FOR [SlsUnit]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_SPID]  DEFAULT ((0)) FOR [SPID]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_StartDate]  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[SFWork2] ADD  CONSTRAINT [DF_SFWork2_UOM]  DEFAULT (' ') FOR [UOM]
GO
