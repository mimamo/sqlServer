USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBillingFixedFee]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBillingFixedFee](
	[BillingFixedFeeKey] [int] IDENTITY(1,1) NOT NULL,
	[BillingKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Percentage] [decimal](24, 4) NULL,
	[Amount] [money] NULL,
	[Taxable1] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[DefaultDepartmentKey] [int] NULL,
 CONSTRAINT [PK_tBillingFixedFee] PRIMARY KEY CLUSTERED 
(
	[BillingFixedFeeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
