USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGoal]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tGoal](
	[GoalKey] [int] IDENTITY(1,1) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Total] [decimal](24, 4) NULL,
	[Month1] [decimal](24, 4) NULL,
	[Month2] [decimal](24, 4) NULL,
	[Month3] [decimal](24, 4) NULL,
	[Month4] [decimal](24, 4) NULL,
	[Month5] [decimal](24, 4) NULL,
	[Month6] [decimal](24, 4) NULL,
	[Month7] [decimal](24, 4) NULL,
	[Month8] [decimal](24, 4) NULL,
	[Month9] [decimal](24, 4) NULL,
	[Month10] [decimal](24, 4) NULL,
	[Month11] [decimal](24, 4) NULL,
	[Month12] [decimal](24, 4) NULL,
 CONSTRAINT [PK_tGoal] PRIMARY KEY CLUSTERED 
(
	[GoalKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
