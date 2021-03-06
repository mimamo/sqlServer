USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tContactDatabase]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tContactDatabase](
	[ContactDatabaseKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[DatabaseID] [varchar](50) NOT NULL,
	[DatabaseName] [varchar](300) NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tContactDatabase] PRIMARY KEY NONCLUSTERED 
(
	[ContactDatabaseKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tContactDatabase] ADD  CONSTRAINT [DF_tContactDatabase_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
