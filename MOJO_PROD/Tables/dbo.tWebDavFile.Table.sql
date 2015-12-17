USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWebDavFile]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWebDavFile](
	[FileKey] [uniqueidentifier] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[Path] [varchar](2000) NULL,
	[FileName] [varchar](300) NULL,
	[LastModified] [smalldatetime] NULL,
	[LastModifiedBy] [int] NULL,
	[Description] [text] NULL,
 CONSTRAINT [PK_tWebDavFile] PRIMARY KEY CLUSTERED 
(
	[FileKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tWebDavFile] ADD  CONSTRAINT [DF_tWebDavFile_FileKey]  DEFAULT (newid()) FOR [FileKey]
GO
