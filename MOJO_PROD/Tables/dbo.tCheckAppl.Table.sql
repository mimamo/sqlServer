USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCheckAppl]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCheckAppl](
	[CheckApplKey] [int] IDENTITY(1,1) NOT NULL,
	[CheckKey] [int] NOT NULL,
	[InvoiceKey] [int] NULL,
	[SalesAccountKey] [int] NOT NULL,
	[ClassKey] [int] NULL,
	[Description] [varchar](500) NULL,
	[Amount] [money] NOT NULL,
	[Prepay] [tinyint] NOT NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[TargetGLCompanyKey] [int] NULL,
 CONSTRAINT [PK_tCheckAppl] PRIMARY KEY NONCLUSTERED 
(
	[CheckApplKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCheckAppl] ADD  CONSTRAINT [DF_tCheckAppl_SalesAccountKey]  DEFAULT ((0)) FOR [SalesAccountKey]
GO
ALTER TABLE [dbo].[tCheckAppl] ADD  CONSTRAINT [DF_tCheckAppl_Prepay]  DEFAULT ((0)) FOR [Prepay]
GO
