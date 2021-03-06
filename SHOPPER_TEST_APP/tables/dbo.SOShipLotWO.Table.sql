USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[SOShipLotWO]    Script Date: 12/21/2015 16:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOShipLotWO](
	[BuildActQty] [float] NOT NULL,
	[BuildLotSerRef] [char](5) NOT NULL,
	[BuildQty] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MfgrLotSerNbr] [char](25) NOT NULL,
	[NoteID] [int] NOT NULL,
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
	[ShipperID] [char](15) NOT NULL,
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
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [BuildActQty]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [BuildLotSerRef]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [BuildQty]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [LotSerNbr]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [MfgrLotSerNbr]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOShipLotWO] ADD  DEFAULT (' ') FOR [WhseLoc]
GO
