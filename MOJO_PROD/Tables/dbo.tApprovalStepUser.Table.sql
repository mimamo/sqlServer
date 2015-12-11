USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalStepUser]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tApprovalStepUser](
	[ApprovalStepUserKey] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalStepKey] [int] NOT NULL,
	[AssignedUserKey] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[DateActivated] [smalldatetime] NULL,
	[DueDate] [smalldatetime] NULL,
	[DateCompleted] [smalldatetime] NULL,
	[Action] [smallint] NULL,
	[Comments] [varchar](500) NULL,
	[LastComments] [varchar](500) NULL,
	[ActiveUser] [tinyint] NULL,
	[CompletedUser] [tinyint] NULL,
	[WithChanges] [tinyint] NULL,
	[StartReminder] [datetime] NULL,
	[NextReminder] [datetime] NULL,
 CONSTRAINT [PK_tApprovalStepUser] PRIMARY KEY CLUSTERED 
(
	[ApprovalStepUserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tApprovalStepUser]  WITH NOCHECK ADD  CONSTRAINT [FK_tApprovalStepUser_tApprovalStep] FOREIGN KEY([ApprovalStepKey])
REFERENCES [dbo].[tApprovalStep] ([ApprovalStepKey])
GO
ALTER TABLE [dbo].[tApprovalStepUser] CHECK CONSTRAINT [FK_tApprovalStepUser_tApprovalStep]
GO
ALTER TABLE [dbo].[tApprovalStepUser] ADD  CONSTRAINT [DF_tApprovalStepUser_ActiveUser]  DEFAULT ((0)) FOR [ActiveUser]
GO
ALTER TABLE [dbo].[tApprovalStepUser] ADD  CONSTRAINT [DF_tApprovalStepUser_CompletedUser]  DEFAULT ((0)) FOR [CompletedUser]
GO
