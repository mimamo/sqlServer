USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLCompanyMap]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGLCompanyMap](
	[GLCompanyMapKey] [int] IDENTITY(1,1) NOT NULL,
	[SourceGLCompanyKey] [int] NOT NULL,
	[TargetGLCompanyKey] [int] NOT NULL,
	[APDueToAccountKey] [int] NULL,
	[APDueFromAccountKey] [int] NULL,
	[ARDueToAccountKey] [int] NULL,
	[ARDueFromAccountKey] [int] NULL,
	[JEDueToAccountKey] [int] NULL,
	[JEDueFromAccountKey] [int] NULL,
	[CSDueToAccountKey] [int] NULL,
	[CSDueFromAccountKey] [int] NULL,
 CONSTRAINT [PK_tGLCompanyMap] PRIMARY KEY CLUSTERED 
(
	[GLCompanyMapKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
