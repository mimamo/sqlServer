USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTimer]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTimer](
	[TimerKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[DetailTaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[RateLevel] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[PauseTime] [datetime] NULL,
	[Paused] [tinyint] NOT NULL,
	[Comments] [varchar](2000) NULL,
	[PauseSeconds] [int] NULL,
	[TaskUserKey] [int] NULL,
 CONSTRAINT [PK_tTimer] PRIMARY KEY CLUSTERED 
(
	[TimerKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTimer] ADD  CONSTRAINT [DF_tTimer_RateLevel]  DEFAULT ((1)) FOR [RateLevel]
GO
