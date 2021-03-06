USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xtmpProjectHeader_source]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpProjectHeader_source](
	[RecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CLIENT_CODE] [nvarchar](255) NULL,
	[CLIENT_NAME] [nvarchar](255) NULL,
	[JOB_CODE] [nvarchar](255) NULL,
	[JOB_NAME] [nvarchar](max) NULL,
	[JOB_OPEN_DATE] [datetime] NULL,
	[JOB_DUE_DATE] [datetime] NULL,
	[JOB_CLOSE_DATE] [nvarchar](255) NULL,
	[JOB_CLIENT_PO_NUMBER] [nvarchar](255) NULL,
	[JOB_TYPE_NAME] [nvarchar](255) NULL,
	[JOB_TYPE_CODE] [nvarchar](255) NULL,
	[PRODUCT_CODE] [nvarchar](255) NULL,
	[JOB_STATUS_NAME] [nvarchar](255) NULL,
	[JOB_CATEGORY_NAME] [nvarchar](255) NULL,
	[JOB_STATUS_CODE] [nvarchar](255) NULL,
	[JOB_CATEGORY_CODE] [nvarchar](255) NULL,
	[CREATE_DATE] [datetime] NULL,
	[CREATOR] [nvarchar](255) NULL,
	[JOB_SHORT_NAME] [nvarchar](max) NULL,
	[JOB_DESCRIPTION] [nvarchar](max) NULL
) ON [PRIMARY]
GO
