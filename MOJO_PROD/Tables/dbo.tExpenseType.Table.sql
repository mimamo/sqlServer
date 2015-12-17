USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tExpenseType]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tExpenseType](
	[ExpenseTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[ExpenseID] [varchar](50) NULL,
	[ExpenseGLAccountKey] [int] NULL,
	[WorkTypeKey] [int] NULL,
	[Markup] [decimal](24, 4) NULL,
	[SalesGLAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[DepartmentKey] [int] NULL,
	[ItemKey] [int] NULL,
 CONSTRAINT [tExpenseType_PK] PRIMARY KEY CLUSTERED 
(
	[ExpenseTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tExpenseType]  WITH CHECK ADD  CONSTRAINT [tCompany_tExpenseType_FK1] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tExpenseType] CHECK CONSTRAINT [tCompany_tExpenseType_FK1]
GO
