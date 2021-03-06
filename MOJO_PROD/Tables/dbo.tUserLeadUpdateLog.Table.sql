USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tUserLeadUpdateLog]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tUserLeadUpdateLog](
	[ModifiedByKey] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Action] [char](1) NOT NULL,
	[StoredProc] [varchar](50) NOT NULL,
	[ParameterList] [varchar](2000) NOT NULL,
	[Application] [varchar](50) NULL,
	[UserLeadKey] [int] NULL,
	[CompanyKey] [int] NULL,
	[FirstName] [varchar](100) NULL,
	[MiddleName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[Salutation] [varchar](10) NULL,
	[Phone1] [varchar](50) NULL,
	[Phone2] [varchar](50) NULL,
	[Cell] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Pager] [varchar](50) NULL,
	[Title] [varchar](200) NULL,
	[Email] [varchar](100) NULL,
	[CompanyName] [varchar](200) NULL,
	[CompanyPhone] [varchar](50) NULL,
	[CompanyFax] [varchar](50) NULL,
	[CompanyWebsite] [varchar](100) NULL,
	[CompanySourceKey] [int] NULL,
	[CompanyTypeKey] [int] NULL,
	[OppSubject] [varchar](200) NULL,
	[OppAmount] [money] NULL,
	[OppProjectTypeKey] [int] NULL,
	[OppDescription] [varchar](4000) NULL,
	[ContactMethod] [tinyint] NULL,
	[DoNotCall] [tinyint] NULL,
	[DoNotEmail] [tinyint] NULL,
	[DoNotMail] [tinyint] NULL,
	[DoNotFax] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[UserCustomFieldKey] [int] NULL,
	[CompanyCustomFieldKey] [int] NULL,
	[OppCustomFieldKey] [int] NULL,
	[AddedByKey] [int] NULL,
	[UpdatedByKey] [int] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[TimeZoneIndex] [int] NULL,
	[OwnerKey] [int] NULL,
	[CMFolderKey] [int] NULL,
	[AddressKey] [int] NULL,
	[HomeAddressKey] [int] NULL,
	[OtherAddressKey] [int] NULL,
	[Department] [varchar](300) NULL,
	[UserRole] [varchar](300) NULL,
	[Assistant] [varchar](300) NULL,
	[AssistantPhone] [varchar](50) NULL,
	[AssistantEmail] [varchar](100) NULL,
	[Birthday] [datetime] NULL,
	[SpouseName] [varchar](300) NULL,
	[Children] [varchar](500) NULL,
	[Anniversary] [datetime] NULL,
	[Hobbies] [varchar](500) NULL,
	[LastActivityKey] [int] NULL,
	[NextActivityKey] [int] NULL,
	[Comments] [text] NULL,
	[InactiveDate] [smalldatetime] NULL,
	[ExternalMarketingKey] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
