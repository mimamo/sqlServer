USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpBadJobs]    Script Date: 12/21/2015 16:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xtmpBadJobs](
	[clientCode] [nvarchar](50) NULL,
	[productCode] [nvarchar](50) NULL,
	[longJobCode] [nvarchar](50) NULL,
	[errorJobCode] [nvarchar](50) NULL,
	[slJob] [nvarchar](50) NULL
) ON [PRIMARY]
GO
