USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyMedia]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCompanyMedia](
	[CompanyMediaKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[VendorKey] [int] NULL,
	[MediaKind] [smallint] NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[StationID] [varchar](50) NOT NULL,
	[Date1Days] [int] NOT NULL,
	[Date2Days] [int] NOT NULL,
	[Date3Days] [int] NOT NULL,
	[Date4Days] [int] NOT NULL,
	[Date5Days] [int] NOT NULL,
	[Date6Days] [int] NOT NULL,
	[MediaMarketKey] [int] NULL,
	[ItemKey] [int] NULL,
	[Active] [tinyint] NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[Address3] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](20) NULL,
	[Country] [varchar](50) NULL,
	[LinkID] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[MAddress1] [varchar](100) NULL,
	[MAddress2] [varchar](100) NULL,
	[MAddress3] [varchar](100) NULL,
	[MCity] [varchar](100) NULL,
	[MState] [varchar](50) NULL,
	[MPostalCode] [varchar](20) NULL,
	[MCountry] [varchar](50) NULL,
	[MPhone] [varchar](50) NULL,
	[MFax] [varchar](50) NULL,
	[MEmail] [varchar](200) NULL,
	[MMaterials] [varchar](4000) NULL,
	[PrintMaterialsInfo] [tinyint] NULL,
	[DefaultAddressKey] [int] NULL,
	[MaterialsAddressKey] [int] NULL,
	[Contact] [varchar](200) NULL,
	[Commission] [decimal](24, 4) NULL,
	[MediaCategoryKey] [int] NULL,
	[Circulation] [int] NULL,
	[Frequency] [varchar](50) NULL,
	[DefaultMediaUnitTypeKey] [int] NULL,
	[URL] [varchar](200) NULL,
	[CallLetters] [varchar](50) NULL,
	[MediaAffiliateKey] [int] NULL,
	[Channel] [varchar](50) NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTax2Key] [int] NULL,
 CONSTRAINT [PK_tCompanyMedia] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCompanyMedia] ADD  CONSTRAINT [DF_tCompanyMedia_Active]  DEFAULT ((1)) FOR [Active]
GO
