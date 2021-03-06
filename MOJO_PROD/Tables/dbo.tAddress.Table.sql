USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAddress]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAddress](
	[AddressKey] [int] IDENTITY(1,1) NOT NULL,
	[OwnerCompanyKey] [int] NOT NULL,
	[CompanyKey] [int] NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[AddressName] [varchar](200) NOT NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[Address3] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](50) NULL,
	[PostalCode] [varchar](20) NULL,
	[Country] [varchar](50) NULL,
	[Active] [tinyint] NOT NULL,
 CONSTRAINT [PK_tAddress] PRIMARY KEY CLUSTERED 
(
	[AddressKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tAddress] ADD  CONSTRAINT [DF_tAddress_Active]  DEFAULT ((1)) FOR [Active]
GO
