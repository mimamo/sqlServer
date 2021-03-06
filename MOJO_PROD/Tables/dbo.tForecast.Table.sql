USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tForecast]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tForecast](
	[ForecastKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[ForecastName] [varchar](200) NULL,
	[GLCompanyKey] [int] NULL,
	[StartMonth] [smallint] NULL,
	[StartYear] [smallint] NULL,
	[SpreadExpense] [smallint] NULL,
	[CreatedDate] [smalldatetime] NOT NULL,
	[CreatedBy] [int] NULL,
 CONSTRAINT [PK_tForecast] PRIMARY KEY CLUSTERED 
(
	[ForecastKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tForecast] ADD  CONSTRAINT [DF_tForecast_SpreadExpense]  DEFAULT ((0)) FOR [SpreadExpense]
GO
ALTER TABLE [dbo].[tForecast] ADD  CONSTRAINT [DF_tForecast_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
