USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[traps_correction]    Script Date: 12/21/2015 14:33:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[traps_correction](
	[docnbr] [nvarchar](50) NULL,
	[employee] [nvarchar](50) NULL,
	[Column 2] [nvarchar](50) NULL,
	[Column 3] [nvarchar](50) NULL,
	[project] [nvarchar](50) NULL,
	[badDate] [datetime] NULL,
	[goodDate] [datetime] NULL
) ON [PRIMARY]
GO
