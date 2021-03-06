USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCompanyType]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCompanyType](
	[CompanyTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[CompanyTypeName] [varchar](50) NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [tCompanyType_PK] PRIMARY KEY CLUSTERED 
(
	[CompanyTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCompanyType] ADD  CONSTRAINT [DF_tCompanyType_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
