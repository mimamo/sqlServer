USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xtmpBadJobs]    Script Date: 12/21/2015 15:54:58 ******/
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
