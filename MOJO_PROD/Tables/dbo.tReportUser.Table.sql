USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReportUser]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReportUser](
	[ReportID] [varchar](50) NOT NULL,
	[ReportKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
 CONSTRAINT [PK_tReportUser] PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC,
	[ReportKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
