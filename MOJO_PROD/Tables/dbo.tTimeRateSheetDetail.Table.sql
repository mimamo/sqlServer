USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTimeRateSheetDetail]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTimeRateSheetDetail](
	[TimeRateSheetDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[TimeRateSheetKey] [int] NOT NULL,
	[ServiceKey] [int] NOT NULL,
	[HourlyRate1] [money] NOT NULL,
	[HourlyRate2] [money] NULL,
	[HourlyRate3] [money] NULL,
	[HourlyRate4] [money] NULL,
	[HourlyRate5] [money] NULL,
 CONSTRAINT [PK_tTimeRateSheetDetail] PRIMARY KEY NONCLUSTERED 
(
	[TimeRateSheetDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_tTimeRateSheetDetail_tTimeRateSheet] FOREIGN KEY([TimeRateSheetKey])
REFERENCES [dbo].[tTimeRateSheet] ([TimeRateSheetKey])
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail] CHECK CONSTRAINT [FK_tTimeRateSheetDetail_tTimeRateSheet]
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail] ADD  CONSTRAINT [DF_tTimeRateSheetDetail_HourlyRate]  DEFAULT ((0)) FOR [HourlyRate1]
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail] ADD  CONSTRAINT [DF_tTimeRateSheetDetail_HourlyRate2]  DEFAULT ((0)) FOR [HourlyRate2]
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail] ADD  CONSTRAINT [DF_tTimeRateSheetDetail_HourlyRate3]  DEFAULT ((0)) FOR [HourlyRate3]
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail] ADD  CONSTRAINT [DF_tTimeRateSheetDetail_HourlyRate4]  DEFAULT ((0)) FOR [HourlyRate4]
GO
ALTER TABLE [dbo].[tTimeRateSheetDetail] ADD  CONSTRAINT [DF_tTimeRateSheetDetail_HourlyRate5]  DEFAULT ((0)) FOR [HourlyRate5]
GO
