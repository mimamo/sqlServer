USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLink]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLink](
	[LinkKey] [int] IDENTITY(1,1) NOT NULL,
	[AssociatedEntity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Type] [smallint] NOT NULL,
	[AddedBy] [int] NULL,
	[FileKey] [int] NULL,
	[FormKey] [int] NULL,
	[URL] [varchar](1000) NULL,
	[URLName] [varchar](300) NULL,
	[URLDescription] [varchar](500) NULL,
	[ProjectKey] [int] NULL,
	[WebDavPath] [varchar](2000) NULL,
	[WebDavFileName] [varchar](500) NULL,
 CONSTRAINT [PK_tLink] PRIMARY KEY NONCLUSTERED 
(
	[LinkKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
