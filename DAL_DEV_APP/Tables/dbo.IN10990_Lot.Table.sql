USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[IN10990_Lot]    Script Date: 12/21/2015 13:35:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10990_Lot](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LineID] [int] IDENTITY(1,1) NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[WhseLoc] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
