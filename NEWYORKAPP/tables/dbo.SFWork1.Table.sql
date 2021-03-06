USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[SFWork1]    Script Date: 12/21/2015 16:00:21 ******/
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
	[ID] [int] IDENTITY(1,1) NOT NULL,
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
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [CatalogNbr]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [CnvFact]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [CuryID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [CustClassDescr]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [CustClassID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [DetCntr]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [DiscPrcMthd]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [DiscPrcTyp]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [ItemCost]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [MaxQty]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [MinQty]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [MultDiv]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [PriceBasis]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [PriceCat]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [SlsPrcID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT ((0)) FOR [SPID]
GO
ALTER TABLE [dbo].[SFWork1] ADD  DEFAULT (' ') FOR [UOM]
GO
