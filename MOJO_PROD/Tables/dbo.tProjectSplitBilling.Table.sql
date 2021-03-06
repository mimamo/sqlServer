USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectSplitBilling]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProjectSplitBilling](
	[ProjectSplitBillingKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[PercentageSplit] [decimal](24, 4) NULL,
 CONSTRAINT [PK_tProjectSplitBilling] PRIMARY KEY CLUSTERED 
(
	[ProjectSplitBillingKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
