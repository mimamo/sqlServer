USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSalesTax]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSalesTax](
	[SalesTaxKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[SalesTaxID] [varchar](100) NOT NULL,
	[SalesTaxName] [varchar](100) NOT NULL,
	[Description] [varchar](300) NULL,
	[PayTo] [int] NULL,
	[PayableGLAccountKey] [int] NULL,
	[TaxRate] [decimal](24, 4) NULL,
	[PiggyBackTax] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[APPayableGLAccountKey] [int] NULL,
	[LinkID] [varchar](100) NULL,
 CONSTRAINT [PK_tSalesTax] PRIMARY KEY NONCLUSTERED 
(
	[SalesTaxKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSalesTax] ADD  CONSTRAINT [DF_tSalesTax_Active]  DEFAULT ((1)) FOR [Active]
GO
