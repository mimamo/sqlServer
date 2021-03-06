USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaClientLink]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaClientLink](
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
 CONSTRAINT [PK_tMediaClientLink] PRIMARY KEY CLUSTERED 
(
	[Entity] ASC,
	[EntityKey] ASC,
	[ClientKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
