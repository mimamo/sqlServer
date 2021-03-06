USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[smSOAddress]    Script Date: 12/21/2015 14:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smSOAddress](
	[BlanketPONbr] [char](15) NOT NULL,
	[BranchID] [char](10) NOT NULL,
	[CreatedBy] [char](47) NOT NULL,
	[CreatedDate] [smalldatetime] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Ctrd_Prog] [char](8) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[DefaultCallType] [char](10) NOT NULL,
	[DefaultPrcPlanID] [char](10) NOT NULL,
	[DefaultProjManager] [char](10) NOT NULL,
	[DefaultPytMethod] [char](1) NOT NULL,
	[DefaultSalesPerson] [char](10) NOT NULL,
	[DefaultStatusID] [char](10) NOT NULL,
	[DefaultTechnician] [char](10) NOT NULL,
	[DwellingType] [char](10) NOT NULL,
	[GeographicZone] [char](10) NOT NULL,
	[LabMarkupID] [char](10) NOT NULL,
	[Latitude] [char](10) NOT NULL,
	[Longitude] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MapCoordinates] [char](10) NOT NULL,
	[MapPage] [char](10) NOT NULL,
	[MatMarkupID] [char](10) NOT NULL,
	[MaxServAmount] [float] NOT NULL,
	[OriginalMediaID] [char](10) NOT NULL,
	[POEndDate] [smalldatetime] NOT NULL,
	[POStartDate] [smalldatetime] NOT NULL,
	[POOption] [char](1) NOT NULL,
	[PrintFlag] [smallint] NOT NULL,
	[Priority] [char](1) NOT NULL,
	[RouteID] [char](10) NOT NULL,
	[SecurityEntryCode] [char](30) NOT NULL,
	[ShiptoID] [char](10) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaxID] [char](10) NOT NULL,
	[TenantAuthorizeCall] [char](1) NOT NULL,
	[TImeZone] [char](6) NOT NULL,
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
