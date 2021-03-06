USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMobileSearchCondition]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMobileSearchCondition](
	[MobileSearchConditionKey] [int] IDENTITY(3000,1) NOT NULL,
	[MobileSearchKey] [int] NOT NULL,
	[FieldName] [varchar](200) NOT NULL,
	[Condition] [varchar](100) NOT NULL,
	[Value1] [varchar](500) NULL,
	[Value2] [varchar](500) NULL,
 CONSTRAINT [PK_tMobileSearchCondition] PRIMARY KEY CLUSTERED 
(
	[MobileSearchConditionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
