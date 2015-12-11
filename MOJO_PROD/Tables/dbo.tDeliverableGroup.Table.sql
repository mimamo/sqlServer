USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDeliverableGroup]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDeliverableGroup](
	[DeliverableGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GroupName] [varchar](500) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_tDeliverableGroup] PRIMARY KEY CLUSTERED 
(
	[DeliverableGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
