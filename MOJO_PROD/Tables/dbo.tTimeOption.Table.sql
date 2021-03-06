USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTimeOption]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTimeOption](
	[CompanyKey] [int] NOT NULL,
	[ShowServicesOnGrid] [tinyint] NOT NULL,
	[ReqProjectOnTime] [tinyint] NOT NULL,
	[ReqServiceOnTime] [tinyint] NOT NULL,
	[TimeSheetPeriod] [smallint] NOT NULL,
	[StartTimeOn] [smallint] NOT NULL,
	[AllowOverlap] [tinyint] NOT NULL,
	[PrintAsGrid] [tinyint] NULL,
	[AllowCustomDates] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [tTimeOptions_PK] PRIMARY KEY CLUSTERED 
(
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_ShowServicesOnGrid]  DEFAULT ((0)) FOR [ShowServicesOnGrid]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_ReqProjectOnTime]  DEFAULT ((0)) FOR [ReqProjectOnTime]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_ReqServiceOnTime]  DEFAULT ((0)) FOR [ReqServiceOnTime]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_TimeSheetPeriod]  DEFAULT ((1)) FOR [TimeSheetPeriod]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_StartTimeOn]  DEFAULT ((1)) FOR [StartTimeOn]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_AllowOverlap]  DEFAULT ((0)) FOR [AllowOverlap]
GO
ALTER TABLE [dbo].[tTimeOption] ADD  CONSTRAINT [DF_tTimeOption_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
