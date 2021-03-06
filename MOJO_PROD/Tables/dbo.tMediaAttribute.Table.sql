USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaAttribute]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaAttribute](
	[MediaAttributeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[AttributeName] [varchar](1000) NOT NULL,
	[POKind] [smallint] NOT NULL,
 CONSTRAINT [PK_tMediaAttribute] PRIMARY KEY CLUSTERED 
(
	[MediaAttributeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
