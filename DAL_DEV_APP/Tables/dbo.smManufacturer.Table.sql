USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[smManufacturer]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smManufacturer](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[Auth] [smallint] NOT NULL,
	[AuthorizationLimit] [float] NOT NULL,
	[City] [char](30) NOT NULL,
	[Contact] [char](30) NOT NULL,
	[Country] [char](3) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Fax] [char](15) NOT NULL,
	[Labor] [smallint] NOT NULL,
	[LaborIncluded] [smallint] NOT NULL,
	[LaborType] [char](1) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[ManufId] [char](10) NOT NULL,
	[Material] [smallint] NOT NULL,
	[MaterialType] [char](1) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PartsIncluded] [smallint] NOT NULL,
	[Phone] [char](15) NOT NULL,
	[RmaRequired] [smallint] NOT NULL,
	[State] [char](3) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Vendid] [char](15) NOT NULL,
	[WarrantyMonths] [smallint] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
