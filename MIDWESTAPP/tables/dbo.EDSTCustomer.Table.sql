USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[EDSTCustomer]    Script Date: 12/21/2015 15:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDSTCustomer](
	[AddressType] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[DistCenterShipToID] [char](10) NOT NULL,
	[EdiDistCenterRef] [char](20) NOT NULL,
	[EdiShipToRef] [char](17) NOT NULL,
	[FSFlag] [int] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MaxBillZone] [char](5) NOT NULL,
	[RegionID] [char](10) NOT NULL,
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
	[ShipToID] [char](10) NOT NULL,
	[TerritoryID] [char](10) NOT NULL,
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
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [AddressType]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [DistCenterShipToID]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [EdiDistCenterRef]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [EdiShipToRef]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [FSFlag]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [MaxBillZone]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [RegionID]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [ShipToID]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [TerritoryID]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[EDSTCustomer] ADD  DEFAULT ('01/01/1900') FOR [User9]
GO
