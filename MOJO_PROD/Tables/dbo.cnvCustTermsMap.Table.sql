USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[cnvCustTermsMap]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cnvCustTermsMap](
	[CompanyKey] [int] NOT NULL,
	[UDField] [varchar](500) NOT NULL,
	[CFField] [varchar](500) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[StringID] [varchar](50) NULL,
	[FieldDefKey] [int] NULL,
	[FieldSetKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
