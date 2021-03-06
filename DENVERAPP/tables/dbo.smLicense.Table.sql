USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[smLicense]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smLicense](
	[AgencyDescription] [char](30) NOT NULL,
	[BusActiveFlag] [smallint] NOT NULL,
	[BusEffectiveDate] [smalldatetime] NOT NULL,
	[BusExpiredDate] [smalldatetime] NOT NULL,
	[CertificateRequired] [smallint] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Ctrd_DateTime] [smalldatetime] NOT NULL,
	[Description] [char](30) NOT NULL,
	[InitialAmount] [float] NOT NULL,
	[InitialTerm] [smallint] NOT NULL,
	[InitialTermType] [char](1) NOT NULL,
	[IssuingAgency] [char](10) NOT NULL,
	[LicenseID] [char](10) NOT NULL,
	[LicenseType] [char](1) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[RenewalAmount] [float] NOT NULL,
	[RenewalTerm] [smallint] NOT NULL,
	[RenewalTermType] [char](1) NOT NULL,
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
