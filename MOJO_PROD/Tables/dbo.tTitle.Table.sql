USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTitle]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTitle](
	[TitleKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[TitleID] [varchar](50) NOT NULL,
	[TitleName] [varchar](500) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[HourlyRate] [money] NULL,
	[HourlyCost] [money] NULL,
	[DepartmentKey] [int] NULL,
	[WorkTypeKey] [int] NULL,
	[GLAccountKey] [int] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
 CONSTRAINT [PK_tTitle] PRIMARY KEY CLUSTERED 
(
	[TitleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
