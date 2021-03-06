USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMasterTaskAssignment]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMasterTaskAssignment](
	[MasterTaskAssignmentKey] [int] IDENTITY(1,1) NOT NULL,
	[MasterTaskKey] [int] NOT NULL,
	[TaskAssignmentTypeKey] [int] NULL,
	[Priority] [smallint] NOT NULL,
	[WorkOrder] [int] NOT NULL,
	[Title] [varchar](500) NULL,
	[WorkDescription] [varchar](4000) NULL,
	[Duration] [int] NULL,
 CONSTRAINT [PK_tMasterTaskAssignment] PRIMARY KEY CLUSTERED 
(
	[MasterTaskAssignmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMasterTaskAssignment]  WITH NOCHECK ADD  CONSTRAINT [FK_tMasterTaskAssignment_tTaskAssignmentType] FOREIGN KEY([TaskAssignmentTypeKey])
REFERENCES [dbo].[tTaskAssignmentType] ([TaskAssignmentTypeKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tMasterTaskAssignment] CHECK CONSTRAINT [FK_tMasterTaskAssignment_tTaskAssignmentType]
GO
ALTER TABLE [dbo].[tMasterTaskAssignment] ADD  CONSTRAINT [DF_tMasterTaskAssignment_Priority]  DEFAULT ((2)) FOR [Priority]
GO
ALTER TABLE [dbo].[tMasterTaskAssignment] ADD  CONSTRAINT [DF_tMasterTaskAssignment_WorkOrder]  DEFAULT ((1)) FOR [WorkOrder]
GO
ALTER TABLE [dbo].[tMasterTaskAssignment] ADD  CONSTRAINT [DF_tMasterTaskAssignment_Duration]  DEFAULT ((0)) FOR [Duration]
GO
