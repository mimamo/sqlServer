USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTaskTempUser]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEstimateTaskTempUser](
	[Entity] [varchar](50) NULL,
	[EntityKey] [int] NOT NULL,
	[UserKey] [int] NULL,
	[TaskKey] [int] NOT NULL,
	[Hours] [decimal](24, 4) NULL,
	[PercComp] [int] NULL,
	[ActStart] [smalldatetime] NULL,
	[ActComplete] [smalldatetime] NULL,
	[ReviewedByTraffic] [tinyint] NULL,
	[ReviewedByDate] [smalldatetime] NULL,
	[ReviewedByKey] [int] NULL,
	[CompletedByDate] [datetime] NULL,
	[CompletedByKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[TaskUserKey] [int] NOT NULL,
	[Subject] [varchar](500) NULL,
	[Description] [text] NULL,
	[Comments] [varchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
