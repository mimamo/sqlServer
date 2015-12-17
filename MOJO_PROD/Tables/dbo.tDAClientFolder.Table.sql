USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDAClientFolder]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDAClientFolder](
	[ClientFolderKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[ParentFolderKey] [int] NOT NULL,
	[FolderName] [varchar](300) NOT NULL,
	[FolderDescription] [varchar](4000) NULL,
 CONSTRAINT [PK_tDAClientFolder] PRIMARY KEY CLUSTERED 
(
	[ClientFolderKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
