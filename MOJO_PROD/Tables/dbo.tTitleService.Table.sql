USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTitleService]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTitleService](
	[TitleKey] [int] NOT NULL,
	[ServiceKey] [int] NOT NULL,
 CONSTRAINT [PK_tTitleService] PRIMARY KEY CLUSTERED 
(
	[TitleKey] ASC,
	[ServiceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
