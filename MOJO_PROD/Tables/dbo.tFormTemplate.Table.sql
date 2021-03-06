USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFormTemplate]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFormTemplate](
	[FormTemplateKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[FormID] [varchar](50) NOT NULL,
	[FormTemplate] [text] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tFormTemplate] PRIMARY KEY CLUSTERED 
(
	[FormTemplateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tFormTemplate] ADD  CONSTRAINT [DF_tFormTemplate_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
