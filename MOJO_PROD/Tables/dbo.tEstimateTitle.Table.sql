USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTitle]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tEstimateTitle](
	[EstimateKey] [int] NOT NULL,
	[TitleKey] [int] NOT NULL,
	[Rate] [money] NULL,
	[Cost] [money] NULL,
 CONSTRAINT [PK_tEstimateTitle] PRIMARY KEY CLUSTERED 
(
	[EstimateKey] ASC,
	[TitleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tEstimateTitle] ADD  CONSTRAINT [DF_tEstimateTitle_Rate]  DEFAULT ((0)) FOR [Rate]
GO
