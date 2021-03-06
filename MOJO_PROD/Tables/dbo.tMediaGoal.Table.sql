USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaGoal]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tMediaGoal](
	[MediaWorksheetKey] [int] NOT NULL,
	[MediaDemographicKey] [int] NOT NULL,
	[MediaMarketKey] [int] NOT NULL,
	[Bucket] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Goal] [decimal](24, 4) NULL,
	[Hiatus] [tinyint] NOT NULL,
 CONSTRAINT [PK_tMediaGoal_1] PRIMARY KEY CLUSTERED 
(
	[MediaWorksheetKey] ASC,
	[MediaDemographicKey] ASC,
	[MediaMarketKey] ASC,
	[Bucket] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tMediaGoal] ADD  CONSTRAINT [DF_tMediaGoal_Hiatus]  DEFAULT ((0)) FOR [Hiatus]
GO
