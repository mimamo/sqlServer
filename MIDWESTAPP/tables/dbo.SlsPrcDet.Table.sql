USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[SlsPrcDet]    Script Date: 12/21/2015 15:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SlsPrcDet](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DetRef] [char](5) NOT NULL,
	[DiscPct] [float] NOT NULL,
	[DiscPrice] [float] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PrcLvlID] [char](10) NOT NULL,
	[PriceChgFlag] [smallint] NOT NULL,
	[QtyBreak] [float] NOT NULL,
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
	[StartDate] [smalldatetime] NOT NULL,
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
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [DetRef]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [DiscPct]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [DiscPrice]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [PrcLvlID]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [PriceChgFlag]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [QtyBreak]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [QtySold]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [RvsdDiscPct]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [RvsdDiscPrice]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [SlsPrcID]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [SlsUnit]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[SlsPrcDet] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
