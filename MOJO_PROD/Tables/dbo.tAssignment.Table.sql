USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAssignment]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAssignment](
	[AssignmentKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[HourlyRate] [money] NULL,
	[SubscribeDiary] [tinyint] NULL,
	[SubscribeToDo] [tinyint] NULL,
	[DeliverableReviewer] [tinyint] NULL,
	[DeliverableNotify] [tinyint] NULL,
 CONSTRAINT [tAssignment_PK] PRIMARY KEY CLUSTERED 
(
	[AssignmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tAssignment]  WITH CHECK ADD  CONSTRAINT [tProject_tAssignment_FK1] FOREIGN KEY([ProjectKey])
REFERENCES [dbo].[tProject] ([ProjectKey])
GO
ALTER TABLE [dbo].[tAssignment] CHECK CONSTRAINT [tProject_tAssignment_FK1]
GO
ALTER TABLE [dbo].[tAssignment]  WITH NOCHECK ADD  CONSTRAINT [tUser_tAssignment_FK1] FOREIGN KEY([UserKey])
REFERENCES [dbo].[tUser] ([UserKey])
GO
ALTER TABLE [dbo].[tAssignment] CHECK CONSTRAINT [tUser_tAssignment_FK1]
GO
