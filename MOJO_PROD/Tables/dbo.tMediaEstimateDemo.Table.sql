USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaEstimateDemo]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tMediaEstimateDemo](
	[MediaWorksheetDemoKey] [int] IDENTITY(1,1) NOT NULL,
	[MediaWorksheetKey] [int] NOT NULL,
	[MediaDemographicKey] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[RatingDemo] [tinyint] NOT NULL,
 CONSTRAINT [PK_tMediaEstimateDemo] PRIMARY KEY CLUSTERED 
(
	[MediaWorksheetDemoKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
