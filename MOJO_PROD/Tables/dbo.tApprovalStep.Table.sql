USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tApprovalStep]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tApprovalStep](
	[ApprovalStepKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ApprovalTypeKey] [int] NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Subject] [varchar](100) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Action] [smallint] NOT NULL,
	[Instructions] [varchar](1000) NULL,
	[EnableRouting] [tinyint] NULL,
	[AllApprove] [tinyint] NULL,
	[DaysToApprove] [int] NULL,
	[ActiveStep] [tinyint] NULL,
	[Completed] [tinyint] NULL,
	[Private] [tinyint] NULL,
	[Internal] [tinyint] NULL,
	[LoginRequired] [tinyint] NULL,
	[SendReminder] [tinyint] NULL,
	[Pause] [tinyint] NULL,
	[Paused] [tinyint] NULL,
	[DueDate] [datetime] NULL,
	[ApproverStatus] [varchar](5000) NULL,
	[ReminderType] [tinyint] NULL,
	[ReminderInterval] [int] NULL,
	[TimeZoneIndex] [int] NULL,
 CONSTRAINT [PK_tApprovalStep] PRIMARY KEY CLUSTERED 
(
	[ApprovalStepKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tApprovalStep] ADD  CONSTRAINT [DF_tApprovalStep_Action]  DEFAULT ((1)) FOR [Action]
GO
ALTER TABLE [dbo].[tApprovalStep] ADD  CONSTRAINT [DF_tApprovalStep_ActiveStep]  DEFAULT ((0)) FOR [ActiveStep]
GO
ALTER TABLE [dbo].[tApprovalStep] ADD  CONSTRAINT [DF_tApprovalStep_Completed]  DEFAULT ((0)) FOR [Completed]
GO
