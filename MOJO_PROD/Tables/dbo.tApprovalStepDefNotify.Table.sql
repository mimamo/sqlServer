USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalStepDefNotify]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tApprovalStepDefNotify](
	[ApprovalStepDefKey] [int] NOT NULL,
	[UserKey] [int] NULL,
	[ServiceKey] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tApprovalStepDefNotify]  WITH NOCHECK ADD  CONSTRAINT [FK_tApprovalStepDefNotify_tApprovalStepDef] FOREIGN KEY([ApprovalStepDefKey])
REFERENCES [dbo].[tApprovalStepDef] ([ApprovalStepDefKey])
GO
ALTER TABLE [dbo].[tApprovalStepDefNotify] CHECK CONSTRAINT [FK_tApprovalStepDefNotify_tApprovalStepDef]
GO
