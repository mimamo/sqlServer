USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRightLevel]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRightLevel](
	[RightKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Level] [int] NOT NULL,
 CONSTRAINT [PK_tRightLevel] PRIMARY KEY CLUSTERED 
(
	[RightKey] ASC,
	[CompanyKey] ASC,
	[Level] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
