USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalStepUserDef]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tApprovalStepUserDef](
	[ApprovalStepUserDefKey] [int] IDENTITY(1,1) NOT NULL,
	[ApprovalStepDefKey] [int] NOT NULL,
	[AssignedUserKey] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[ServiceKey] [int] NULL,
 CONSTRAINT [PK_tApprovalStepUserDef] PRIMARY KEY CLUSTERED 
(
	[ApprovalStepUserDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tApprovalStepUserDef]  WITH NOCHECK ADD  CONSTRAINT [FK_tApprovalStepUserDef_tApprovalStepDef] FOREIGN KEY([ApprovalStepDefKey])
REFERENCES [dbo].[tApprovalStepDef] ([ApprovalStepDefKey])
GO
ALTER TABLE [dbo].[tApprovalStepUserDef] CHECK CONSTRAINT [FK_tApprovalStepUserDef_tApprovalStepDef]
GO
