USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateService]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateService](
	[EstimateKey] [int] NOT NULL,
	[ServiceKey] [int] NOT NULL,
	[Rate] [money] NULL,
	[Cost] [money] NULL,
 CONSTRAINT [PK_tEstimateService] PRIMARY KEY CLUSTERED 
(
	[EstimateKey] ASC,
	[ServiceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateService] ADD  CONSTRAINT [DF_tEstimateService_Rate]  DEFAULT ((0)) FOR [Rate]
GO
