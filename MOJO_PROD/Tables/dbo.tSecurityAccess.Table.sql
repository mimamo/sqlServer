USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSecurityAccess]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSecurityAccess](
	[CompanyKey] [int] NULL,
	[EntityKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[SecurityGroupKey] [int] NOT NULL,
 CONSTRAINT [PK_tSecurityAccess] PRIMARY KEY CLUSTERED 
(
	[EntityKey] ASC,
	[Entity] ASC,
	[SecurityGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
