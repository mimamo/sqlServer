USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tStringCompany]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tStringCompany](
	[CompanyKey] [int] NOT NULL,
	[StringID] [varchar](50) NOT NULL,
	[StringSingular] [varchar](500) NULL,
	[StringPlural] [varchar](500) NULL,
	[StringDropDown] [varchar](4000) NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tStringCompany] PRIMARY KEY CLUSTERED 
(
	[CompanyKey] ASC,
	[StringID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tStringCompany] ADD  CONSTRAINT [DF_tStringCompany_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
