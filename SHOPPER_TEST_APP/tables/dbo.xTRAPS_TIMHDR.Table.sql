USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xTRAPS_TIMHDR]    Script Date: 12/21/2015 16:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_TIMHDR](
	[docnbr] [nchar](10) NOT NULL,
	[preparer_id] [nchar](10) NOT NULL,
	[project] [nchar](16) NOT NULL,
	[th_date] [smalldatetime] NOT NULL,
	[th_comment] [nchar](30) NOT NULL,
	[trigger_status] [nchar](10) NOT NULL
) ON [PRIMARY]
GO
