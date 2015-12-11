USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tContactDatabaseAssignment]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tContactDatabaseAssignment](
	[CompanyKey] [int] NOT NULL,
	[ContactDatabaseKey] [int] NOT NULL,
 CONSTRAINT [PK_tContactDatabaseAssignment] PRIMARY KEY NONCLUSTERED 
(
	[CompanyKey] ASC,
	[ContactDatabaseKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
