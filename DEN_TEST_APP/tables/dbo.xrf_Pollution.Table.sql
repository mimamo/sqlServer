USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xrf_Pollution]    Script Date: 12/21/2015 14:10:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xrf_Pollution](
	[ClientCode] [nvarchar](255) NULL,
	[ProductCode] [nvarchar](255) NULL,
	[LongJobCode] [nvarchar](255) NULL,
	[PollutedJobCode] [nvarchar](255) NULL
) ON [PRIMARY]
GO
