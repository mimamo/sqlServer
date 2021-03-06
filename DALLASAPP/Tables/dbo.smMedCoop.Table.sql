USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[smMedCoop]    Script Date: 12/21/2015 13:44:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smMedCoop](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MedCoopAddress1] [char](30) NOT NULL,
	[MedCoopAddress2] [char](30) NOT NULL,
	[MedCoopBuyId] [char](10) NOT NULL,
	[MedCoopCity] [char](30) NOT NULL,
	[MedCoopContact] [char](30) NOT NULL,
	[MedCoopFaxNo] [char](15) NOT NULL,
	[MedCoopName] [char](30) NOT NULL,
	[MedCoopPaid] [char](1) NOT NULL,
	[MedCoopPct] [float] NOT NULL,
	[MedCoopPhoneNo] [char](15) NOT NULL,
	[MedCoopState] [char](3) NOT NULL,
	[MedCoopVendorId] [char](15) NOT NULL,
	[MedCoopZip] [char](10) NOT NULL,
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
