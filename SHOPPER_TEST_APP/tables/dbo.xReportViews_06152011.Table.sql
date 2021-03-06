USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xReportViews_06152011]    Script Date: 12/21/2015 16:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xReportViews_06152011](
	[ReportID] [char](30) NOT NULL,
	[ReportName] [char](40) NOT NULL,
	[Total_Views] [float] NOT NULL,
	[Last_Viewed] [smalldatetime] NOT NULL,
	[Last_Viewed_User] [varchar](50) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_User] [varchar](50) NOT NULL,
	[Source] [varchar](10) NULL,
	[timestamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
