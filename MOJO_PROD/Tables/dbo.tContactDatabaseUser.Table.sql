USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tContactDatabaseUser]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tContactDatabaseUser](
	[ContactDatabaseKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
 CONSTRAINT [PK_tContactDatabaseUser] PRIMARY KEY NONCLUSTERED 
(
	[ContactDatabaseKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
