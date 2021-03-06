USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[SFWork1]    Script Date: 12/21/2015 14:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SFWork1](
	[CatalogNbr] [char](15) NOT NULL,
	[CnvFact] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CustClassDescr] [char](30) NOT NULL,
	[CustClassID] [char](6) NOT NULL,
	[DetCntr] [char](5) NOT NULL,
	[DiscPrcMthd] [char](1) NOT NULL,
	[DiscPrcTyp] [char](1) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ItemCost] [float] NOT NULL,
	[MaxQty] [float] NOT NULL,
	[MinQty] [float] NOT NULL,
	[MultDiv] [char](1) NOT NULL,
	[PriceBasis] [float] NOT NULL,
	[PriceCat] [char](2) NOT NULL,
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
	[SPID] [smallint] NOT NULL,
	[UOM] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_CatalogNbr]  DEFAULT (' ') FOR [CatalogNbr]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_CnvFact]  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_CuryID]  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_CustClassDescr]  DEFAULT (' ') FOR [CustClassDescr]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_CustClassID]  DEFAULT (' ') FOR [CustClassID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_DetCntr]  DEFAULT (' ') FOR [DetCntr]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_DiscPrcMthd]  DEFAULT (' ') FOR [DiscPrcMthd]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_DiscPrcTyp]  DEFAULT (' ') FOR [DiscPrcTyp]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_ItemCost]  DEFAULT ((0)) FOR [ItemCost]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_MaxQty]  DEFAULT ((0)) FOR [MaxQty]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_MinQty]  DEFAULT ((0)) FOR [MinQty]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_MultDiv]  DEFAULT (' ') FOR [MultDiv]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_PriceBasis]  DEFAULT ((0)) FOR [PriceBasis]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_PriceCat]  DEFAULT (' ') FOR [PriceCat]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_SlsPrcID]  DEFAULT (' ') FOR [SlsPrcID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_SPID]  DEFAULT ((0)) FOR [SPID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  CONSTRAINT [DF_SFWork1_UOM]  DEFAULT (' ') FOR [UOM]
GO
