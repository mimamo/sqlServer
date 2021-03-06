USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tImport]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tImport](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ImportType] [int] NOT NULL,
	[FileName] [varchar](300) NOT NULL,
	[OriginalFileName] [varchar](300) NULL,
	[DateAdded] [smalldatetime] NOT NULL,
	[DateImported] [smalldatetime] NULL,
	[Status] [smallint] NOT NULL,
	[LogText] [text] NULL,
	[Delimiter] [smallint] NULL,
	[TextQualifier] [smallint] NULL,
 CONSTRAINT [PK_tImport] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tImport] ADD  CONSTRAINT [DF_tImport_Status]  DEFAULT ((1)) FOR [Status]
GO
