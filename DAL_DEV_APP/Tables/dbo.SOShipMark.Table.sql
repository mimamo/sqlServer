USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[SOShipMark]    Script Date: 12/21/2015 13:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOShipMark](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[AddrID] [char](10) NOT NULL,
	[AddrSpecial] [smallint] NOT NULL,
	[Attn] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MarkForID] [char](10) NOT NULL,
	[MarkForType] [char](1) NOT NULL,
	[Name1] [char](60) NOT NULL,
	[Name2] [char](60) NOT NULL,
	[Name3] [char](60) NOT NULL,
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
	[ShipViaID] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[State] [char](3) NOT NULL,
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
	[VendAddrID] [char](10) NOT NULL,
	[VendID] [char](15) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Addr1]  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Addr2]  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_AddrID]  DEFAULT (' ') FOR [AddrID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_AddrSpecial]  DEFAULT ((0)) FOR [AddrSpecial]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Attn]  DEFAULT (' ') FOR [Attn]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_City]  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Country]  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_CustID]  DEFAULT (' ') FOR [CustID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_MarkForID]  DEFAULT (' ') FOR [MarkForID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_MarkForType]  DEFAULT (' ') FOR [MarkForType]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Name1]  DEFAULT (' ') FOR [Name1]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Name2]  DEFAULT (' ') FOR [Name2]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Name3]  DEFAULT (' ') FOR [Name3]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_ShipViaID]  DEFAULT (' ') FOR [ShipViaID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_State]  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User10]  DEFAULT ('01/01/1900') FOR [User10]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User3]  DEFAULT (' ') FOR [User3]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User4]  DEFAULT (' ') FOR [User4]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User5]  DEFAULT ((0)) FOR [User5]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User6]  DEFAULT ((0)) FOR [User6]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User7]  DEFAULT (' ') FOR [User7]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User8]  DEFAULT (' ') FOR [User8]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_User9]  DEFAULT ('01/01/1900') FOR [User9]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_VendAddrID]  DEFAULT (' ') FOR [VendAddrID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_VendID]  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[SOShipMark] ADD  CONSTRAINT [DF_SOShipMark_Zip]  DEFAULT (' ') FOR [Zip]
GO
