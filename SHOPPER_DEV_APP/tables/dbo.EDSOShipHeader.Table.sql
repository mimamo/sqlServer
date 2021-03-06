USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[EDSOShipHeader]    Script Date: 12/21/2015 14:33:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDSOShipHeader](
	[BOL] [char](20) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Height] [float] NOT NULL,
	[HeightUOM] [char](6) NOT NULL,
	[LastEDIDate] [smalldatetime] NOT NULL,
	[Len] [float] NOT NULL,
	[LenUOM] [char](6) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[OutboundProcNbr] [char](10) NOT NULL,
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
	[SendViaEDI] [smallint] NOT NULL,
	[ShipperId] [char](15) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[Volume] [float] NOT NULL,
	[VolumeUOM] [char](6) NOT NULL,
	[Weight] [float] NOT NULL,
	[WeightUOM] [char](6) NOT NULL,
	[Width] [float] NOT NULL,
	[WidthUOM] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [BOL]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [CpnyId]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [HeightUOM]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [LastEDIDate]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [Len]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [LenUOM]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [OutboundProcNbr]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [SendViaEDI]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [ShipperId]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [Volume]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [VolumeUOM]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [WeightUOM]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[EDSOShipHeader] ADD  DEFAULT (' ') FOR [WidthUOM]
GO
