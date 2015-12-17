USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTaskAssignmentTypeService]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTaskAssignmentTypeService](
	[TaskAssignmentTypeKey] [int] NOT NULL,
	[ServiceKey] [int] NOT NULL,
	[Used] [tinyint] NULL,
	[Notify] [tinyint] NULL,
 CONSTRAINT [PK_tTaskAssignmentTypeService] PRIMARY KEY CLUSTERED 
(
	[TaskAssignmentTypeKey] ASC,
	[ServiceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tTaskAssignmentTypeService]  WITH CHECK ADD  CONSTRAINT [FK_tTaskAssignmentTypeService_tTaskAssignmentType] FOREIGN KEY([TaskAssignmentTypeKey])
REFERENCES [dbo].[tTaskAssignmentType] ([TaskAssignmentTypeKey])
GO
ALTER TABLE [dbo].[tTaskAssignmentTypeService] CHECK CONSTRAINT [FK_tTaskAssignmentTypeService_tTaskAssignmentType]
GO
