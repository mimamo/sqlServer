USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalStepDef]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tApprovalStepDef](
	[ApprovalStepDefKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Subject] [varchar](100) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Action] [smallint] NOT NULL,
	[Instructions] [varchar](1000) NULL,
	[EnableRouting] [tinyint] NULL,
	[AllApprove] [tinyint] NULL,
	[DaysToApprove] [int] NULL,
	[ApprovalTypeKey] [int] NULL,
 CONSTRAINT [PK_tApprovalStepDef] PRIMARY KEY CLUSTERED 
(
	[ApprovalStepDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tApprovalStepDef]  WITH NOCHECK ADD  CONSTRAINT [FK_tApprovalStepDef_tApprovalType] FOREIGN KEY([ApprovalTypeKey])
REFERENCES [dbo].[tApprovalType] ([ApprovalTypeKey])
GO
ALTER TABLE [dbo].[tApprovalStepDef] CHECK CONSTRAINT [FK_tApprovalStepDef_tApprovalType]
GO
ALTER TABLE [dbo].[tApprovalStepDef] ADD  CONSTRAINT [DF_tApprovalStepDef_Action]  DEFAULT ((1)) FOR [Action]
GO
