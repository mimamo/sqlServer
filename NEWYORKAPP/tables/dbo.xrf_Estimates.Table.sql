USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xrf_Estimates]    Script Date: 12/21/2015 16:00:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xrf_Estimates](
	[ClientID] [float] NULL,
	[ClientCode] [nvarchar](255) NULL,
	[ProductID] [float] NULL,
	[ProductCode] [nvarchar](255) NULL,
	[JobID] [float] NULL,
	[JobCode] [nvarchar](255) NULL,
	[JobName] [nvarchar](255) NULL,
	[FunctionID] [float] NULL,
	[FunctionCode] [nvarchar](255) NULL,
	[EstimateVersionCode] [nvarchar](255) NULL,
	[EstimateCreateDate] [datetime] NULL,
	[Amount] [float] NULL,
	[Rates] [float] NULL,
	[Units] [float] NULL,
	[ClientProductJobEstimate] [nvarchar](255) NULL,
	[HeaderNotes] [nvarchar](max) NULL,
	[SolProject] [nvarchar](255) NULL,
	[FunctionDesc] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL
) ON [PRIMARY]
GO
