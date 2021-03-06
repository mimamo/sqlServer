USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSession]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSession](
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Data] [text] NULL,
 CONSTRAINT [PK_tSession] PRIMARY KEY CLUSTERED 
(
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSession] ADD  CONSTRAINT [DF_tSession_Entity]  DEFAULT (user_name()) FOR [Entity]
GO
