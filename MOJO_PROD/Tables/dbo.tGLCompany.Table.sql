USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLCompany]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tGLCompany](
	[GLCompanyKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GLCompanyName] [varchar](500) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[AddressKey] [int] NULL,
	[GLCompanyID] [varchar](50) NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[PrintedName] [varchar](500) NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[EINNumber] [varchar](30) NULL,
	[StateEINNumber] [varchar](30) NULL,
	[WebSite] [varchar](100) NULL,
	[BankAccountKey] [int] NULL,
	[GLCloseDate] [smalldatetime] NULL,
 CONSTRAINT [PK_tGLCompany] PRIMARY KEY CLUSTERED 
(
	[GLCompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tGLCompany] ADD  CONSTRAINT [DF_tGLCompany_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tGLCompany] ADD  CONSTRAINT [DF_tGLCompany_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
