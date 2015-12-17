USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tForecastDetail]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tForecastDetail](
	[ForecastDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[ForecastKey] [int] NOT NULL,
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NULL,
	[EntityName] [varchar](250) NULL,
	[StartDate] [smalldatetime] NULL,
	[Months] [int] NULL,
	[Probability] [smallint] NULL,
	[Total] [money] NULL,
	[Month1] [money] NULL,
	[Month2] [money] NULL,
	[Month3] [money] NULL,
	[Month4] [money] NULL,
	[Month5] [money] NULL,
	[Month6] [money] NULL,
	[Month7] [money] NULL,
	[Month8] [money] NULL,
	[Month9] [money] NULL,
	[Month10] [money] NULL,
	[Month11] [money] NULL,
	[Month12] [money] NULL,
	[NextYear] [money] NULL,
	[Prior] [money] NULL,
	[ClientKey] [int] NULL,
	[AccountManagerKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[FromEstimate] [tinyint] NULL,
	[EntityID] [varchar](250) NULL,
	[GeneratedDate] [smalldatetime] NULL,
	[GeneratedBy] [int] NULL,
	[ManualUpdateDate] [smalldatetime] NULL,
	[ManualUpdateBy] [int] NULL,
	[RecalcNeeded] [tinyint] NULL,
	[RegenerateNeeded] [tinyint] NULL,
	[ReviewComplete] [tinyint] NULL,
	[Month1N] [money] NULL,
	[Month2N] [money] NULL,
	[Month3N] [money] NULL,
	[Month4N] [money] NULL,
	[Month5N] [money] NULL,
	[Month6N] [money] NULL,
	[Month7N] [money] NULL,
	[Month8N] [money] NULL,
	[Month9N] [money] NULL,
	[Month10N] [money] NULL,
	[Month11N] [money] NULL,
	[Month12N] [money] NULL,
	[PriorN] [money] NULL,
	[NextYearN] [money] NULL,
	[TotalN] [money] NULL,
	[EndDate] [smalldatetime] NULL,
 CONSTRAINT [PK_tForecastDetail] PRIMARY KEY CLUSTERED 
(
	[ForecastDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month1]  DEFAULT ((0)) FOR [Month1]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month2]  DEFAULT ((0)) FOR [Month2]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month3]  DEFAULT ((0)) FOR [Month3]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month4]  DEFAULT ((0)) FOR [Month4]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month5]  DEFAULT ((0)) FOR [Month5]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month6]  DEFAULT ((0)) FOR [Month6]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month7]  DEFAULT ((0)) FOR [Month7]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month8]  DEFAULT ((0)) FOR [Month8]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month9]  DEFAULT ((0)) FOR [Month9]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month10]  DEFAULT ((0)) FOR [Month10]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month11]  DEFAULT ((0)) FOR [Month11]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Month12]  DEFAULT ((0)) FOR [Month12]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_NextYear]  DEFAULT ((0)) FOR [NextYear]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_Prior]  DEFAULT ((0)) FOR [Prior]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_FromEstimate]  DEFAULT ((0)) FOR [FromEstimate]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_GeneratedDate]  DEFAULT (getutcdate()) FOR [GeneratedDate]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_RecalcNeeded]  DEFAULT ((0)) FOR [RecalcNeeded]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_RegenerateNeeded]  DEFAULT ((0)) FOR [RegenerateNeeded]
GO
ALTER TABLE [dbo].[tForecastDetail] ADD  CONSTRAINT [DF_tForecastDetail_ReviewComplete]  DEFAULT ((0)) FOR [ReviewComplete]
GO
