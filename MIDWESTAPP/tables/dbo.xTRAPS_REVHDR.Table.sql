USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xTRAPS_REVHDR]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_REVHDR](
	[approver] [nchar](10) NOT NULL,
	[create_date] [smalldatetime] NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[est_approve_date] [smalldatetime] NOT NULL,
	[noteid] [int] NOT NULL,
	[post_date] [smalldatetime] NOT NULL,
	[post_period] [nchar](10) NOT NULL,
	[preparer] [nchar](10) NOT NULL,
	[project] [nchar](16) NOT NULL,
	[revid] [nchar](10) NOT NULL,
	[revisiontype] [nchar](10) NOT NULL,
	[revision_desc] [nchar](30) NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[status] [nchar](10) NOT NULL,
	[trigger_status] [nchar](10) NOT NULL,
	[update_type] [nchar](10) NOT NULL
) ON [PRIMARY]
GO
