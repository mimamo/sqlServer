USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDAFolder]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDAFolder](
	[FolderKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[ParentFolderKey] [int] NOT NULL,
	[FolderName] [varchar](300) NOT NULL,
	[FolderDescription] [varchar](4000) NULL,
	[SystemPath] [varchar](255) NULL,
	[WebDavPath] [varchar](2000) NULL,
	[WebDavRelativePath] [varchar](2000) NULL,
 CONSTRAINT [PK_tDAFolder] PRIMARY KEY CLUSTERED 
(
	[FolderKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
