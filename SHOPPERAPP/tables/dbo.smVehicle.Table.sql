USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[smVehicle]    Script Date: 12/21/2015 16:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smVehicle](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VehicleDesc] [char](30) NOT NULL,
	[VehicleId] [char](10) NOT NULL,
	[VehicleMake] [char](16) NOT NULL,
	[VehicleMfgVIN] [char](30) NOT NULL,
	[VehicleModel] [char](16) NOT NULL,
	[VehiclePurchaseDate] [smalldatetime] NOT NULL,
	[VehicleSiteId] [char](10) NOT NULL,
	[VehicleYear] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
