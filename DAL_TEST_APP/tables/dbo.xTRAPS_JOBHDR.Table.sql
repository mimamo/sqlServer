USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xTRAPS_JOBHDR]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xTRAPS_JOBHDR](
	[job_number] [varchar](20) NOT NULL,
	[job_title] [varchar](255) NOT NULL,
	[parent_job] [varchar](16) NOT NULL,
	[child_job] [varchar](16) NOT NULL,
	[status] [varchar](1) NOT NULL,
	[progress] [varchar](1) NOT NULL,
	[noteid] [bigint] NOT NULL,
	[sub_prod_code] [varchar](5) NOT NULL,
	[date_created] [smalldatetime] NOT NULL,
	[billable] [varchar](1) NOT NULL,
	[trigger_status] [varchar](2) NOT NULL,
 CONSTRAINT [PK_xTRAPS_JOBHDR] PRIMARY KEY CLUSTERED 
(
	[job_number] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
