USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xReportUsage_06152011]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xReportUsage_06152011](
	[UsageID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID] [char](30) NOT NULL,
	[Reportformat] [char](30) NOT NULL,
	[RI_Where] [char](255) NOT NULL,
	[UserId] [char](47) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
