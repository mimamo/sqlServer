USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[SHShipHeader]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SHShipHeader](
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
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
	[ShipDateAct] [smalldatetime] NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[ShippingConfirmed] [smallint] NOT NULL,
	[ShippingManifested] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [smalldatetime] NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [char](30) NOT NULL,
	[User4] [char](30) NOT NULL,
	[User5] [float] NOT NULL,
	[User6] [float] NOT NULL,
	[User7] [char](10) NOT NULL,
	[User8] [char](10) NOT NULL,
	[User9] [smalldatetime] NOT NULL,
	[Zone] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_ShipDateAct]  DEFAULT ('01/01/1900') FOR [ShipDateAct]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_ShippingConfirmed]  DEFAULT ((0)) FOR [ShippingConfirmed]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_ShippingManifested]  DEFAULT ((0)) FOR [ShippingManifested]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SHShipHeader] ADD  CONSTRAINT [DF_SHShipHeader_Zone]  DEFAULT (' ') FOR [Zone]
GO
