USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCBCodePercent]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCBCodePercent](
	[CBCodePercentKey] [int] IDENTITY(1,1) NOT NULL,
	[CBCodeKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Percentage] [decimal](24, 4) NOT NULL,
 CONSTRAINT [PK_tCBCodePercent] PRIMARY KEY CLUSTERED 
(
	[CBCodePercentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
