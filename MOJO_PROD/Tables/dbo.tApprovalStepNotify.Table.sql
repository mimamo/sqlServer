USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalStepNotify]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tApprovalStepNotify](
	[ApprovalStepKey] [int] NOT NULL,
	[AssignedUserKey] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tApprovalStepNotify]  WITH NOCHECK ADD  CONSTRAINT [FK_tApprovalStepNotify_tApprovalStep] FOREIGN KEY([ApprovalStepKey])
REFERENCES [dbo].[tApprovalStep] ([ApprovalStepKey])
GO
ALTER TABLE [dbo].[tApprovalStepNotify] CHECK CONSTRAINT [FK_tApprovalStepNotify_tApprovalStep]
GO
