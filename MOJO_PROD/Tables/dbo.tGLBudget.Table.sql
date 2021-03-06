USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLBudget]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tGLBudget](
	[GLBudgetKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[BudgetType] [smallint] NOT NULL,
	[BudgetName] [varchar](100) NOT NULL,
	[Active] [tinyint] NOT NULL,
 CONSTRAINT [PK_tGLBudget] PRIMARY KEY CLUSTERED 
(
	[GLBudgetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tGLBudget] ADD  CONSTRAINT [DF_tGLBudget_BudgetType]  DEFAULT ((1)) FOR [BudgetType]
GO
ALTER TABLE [dbo].[tGLBudget] ADD  CONSTRAINT [DF_tGLBudget_Active]  DEFAULT ((1)) FOR [Active]
GO
