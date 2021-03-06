USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[smRentBilling]    Script Date: 12/21/2015 16:00:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smRentBilling](
	[Acct] [char](10) NOT NULL,
	[Basis] [char](2) NOT NULL,
	[Contact] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustOrdNbr] [char](15) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[EquipID] [char](10) NOT NULL,
	[Frequency] [char](1) NOT NULL,
	[Internal] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MiscAmt] [float] NOT NULL,
	[Multiplier] [float] NOT NULL,
	[OrdNbr] [char](10) NOT NULL,
	[Phone] [char](15) NOT NULL,
	[Rate] [float] NOT NULL,
	[RentalID] [char](10) NOT NULL,
	[RentAmt] [float] NOT NULL,
	[SlsPerId] [char](10) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[Sub] [char](24) NOT NULL,
	[Tax] [float] NOT NULL,
	[TotalAmt] [float] NOT NULL,
	[TransID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
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
