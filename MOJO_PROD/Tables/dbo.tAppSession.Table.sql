USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAppSession]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAppSession](
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[GroupID] [varchar](50) NOT NULL,
	[SessionID] [varchar](50) NOT NULL,
	[Value] [varchar](max) NULL,
 CONSTRAINT [PK_tAppSession] PRIMARY KEY CLUSTERED 
(
	[Entity] ASC,
	[EntityKey] ASC,
	[GroupID] ASC,
	[SessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
