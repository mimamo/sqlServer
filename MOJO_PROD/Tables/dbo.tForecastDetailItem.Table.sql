USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tForecastDetailItem]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tForecastDetailItem](
	[ForecastDetailKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[Prior] [money] NULL,
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
	[Total] [money] NULL,
	[Sequence] [int] NOT NULL,
	[Labor] [tinyint] NULL,
	[GLAccountKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[ItemKey] [int] NULL,
	[UserKey] [int] NULL,
	[CampaignSegmentKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[DepartmentKey] [int] NULL,
	[ClassKey] [int] NULL,
	[AtNet] [tinyint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Prior]  DEFAULT ((0)) FOR [Prior]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month1]  DEFAULT ((0)) FOR [Month1]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month2]  DEFAULT ((0)) FOR [Month2]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month3]  DEFAULT ((0)) FOR [Month3]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month4]  DEFAULT ((0)) FOR [Month4]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month5]  DEFAULT ((0)) FOR [Month5]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month6]  DEFAULT ((0)) FOR [Month6]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month7]  DEFAULT ((0)) FOR [Month7]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month8]  DEFAULT ((0)) FOR [Month8]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month9]  DEFAULT ((0)) FOR [Month9]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month10]  DEFAULT ((0)) FOR [Month10]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month11]  DEFAULT ((0)) FOR [Month11]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Month12]  DEFAULT ((0)) FOR [Month12]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_NextYear]  DEFAULT ((0)) FOR [NextYear]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Sequence]  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_Labor]  DEFAULT ((1)) FOR [Labor]
GO
ALTER TABLE [dbo].[tForecastDetailItem] ADD  CONSTRAINT [DF_tForecastDetailItem_AtNet]  DEFAULT ((0)) FOR [AtNet]
GO
