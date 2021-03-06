USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLBudgetDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGLBudgetDetail](
	[GLBudgetKey] [int] NOT NULL,
	[GLAccountKey] [int] NOT NULL,
	[ClassKey] [int] NOT NULL,
	[Month1] [money] NOT NULL,
	[Month2] [money] NOT NULL,
	[Month3] [money] NOT NULL,
	[Month4] [money] NOT NULL,
	[Month5] [money] NOT NULL,
	[Month6] [money] NOT NULL,
	[Month7] [money] NOT NULL,
	[Month8] [money] NOT NULL,
	[Month9] [money] NOT NULL,
	[Month10] [money] NOT NULL,
	[Month11] [money] NOT NULL,
	[Month12] [money] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[GLCompanyKey] [int] NOT NULL,
	[OfficeKey] [int] NOT NULL,
	[DepartmentKey] [int] NOT NULL,
 CONSTRAINT [PK_tGLBudgetDetail] PRIMARY KEY CLUSTERED 
(
	[GLBudgetKey] ASC,
	[GLAccountKey] ASC,
	[ClassKey] ASC,
	[ClientKey] ASC,
	[GLCompanyKey] ASC,
	[OfficeKey] ASC,
	[DepartmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tGLBudgetDetail] ADD  CONSTRAINT [DF_tGLBudgetDetail_ClassKey]  DEFAULT ((0)) FOR [ClassKey]
GO
ALTER TABLE [dbo].[tGLBudgetDetail] ADD  CONSTRAINT [DF_tGLBudgetDetail_ClientKey]  DEFAULT ((0)) FOR [ClientKey]
GO
ALTER TABLE [dbo].[tGLBudgetDetail] ADD  CONSTRAINT [DF_tGLBudgetDetail_GLCompanyKey]  DEFAULT ((0)) FOR [GLCompanyKey]
GO
ALTER TABLE [dbo].[tGLBudgetDetail] ADD  CONSTRAINT [DF_tGLBudgetDetail_OfficeKey]  DEFAULT ((0)) FOR [OfficeKey]
GO
ALTER TABLE [dbo].[tGLBudgetDetail] ADD  CONSTRAINT [DF_tGLBudgetDetail_DepartmentKey]  DEFAULT ((0)) FOR [DepartmentKey]
GO
