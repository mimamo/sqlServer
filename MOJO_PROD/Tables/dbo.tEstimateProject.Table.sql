USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateProject]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateProject](
	[EstimateKey] [int] NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[ProjectEstimateKey] [int] NULL
) ON [PRIMARY]
GO
