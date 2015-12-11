USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTaskAssignmentUser]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTaskAssignmentUser](
	[TaskAssignmentKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[TaskKey] [int] NOT NULL,
	[Hours] [decimal](24, 4) NULL,
 CONSTRAINT [PK_tTaskAssignmentUser] PRIMARY KEY CLUSTERED 
(
	[TaskAssignmentKey] ASC,
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
