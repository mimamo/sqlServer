USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDAFileVersion]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDAFileVersion](
	[FileVersionKey] [int] IDENTITY(1,1) NOT NULL,
	[FileKey] [int] NOT NULL,
	[VersionNumber] [int] NOT NULL,
	[VersionComments] [varchar](4000) NULL,
	[FileSize] [int] NULL,
	[Status] [smallint] NULL,
	[Deleted] [tinyint] NULL,
	[VersionDate] [smalldatetime] NULL,
	[VersionByKey] [int] NULL,
 CONSTRAINT [PK_tDAFileVersion] PRIMARY KEY CLUSTERED 
(
	[FileVersionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDAFileVersion]  WITH CHECK ADD  CONSTRAINT [FK_tDAFileVersion_tDAFile] FOREIGN KEY([FileKey])
REFERENCES [dbo].[tDAFile] ([FileKey])
GO
ALTER TABLE [dbo].[tDAFileVersion] CHECK CONSTRAINT [FK_tDAFileVersion_tDAFile]
GO
