USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xReportViews]    Script Date: 12/21/2015 14:33:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xReportViews](
	[ReportID] [char](30) NOT NULL,
	[ReportName] [char](40) NOT NULL,
	[Total_Views] [float] NOT NULL,
	[Last_Viewed] [smalldatetime] NOT NULL,
	[Last_Viewed_User] [varchar](50) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_User] [varchar](50) NOT NULL,
	[Source] [varchar](10) NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_xReportViews] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xReportViews] ADD  CONSTRAINT [DF_xReportViews_Total_Views]  DEFAULT ((0)) FOR [Total_Views]
GO
