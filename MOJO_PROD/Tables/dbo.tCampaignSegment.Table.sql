USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCampaignSegment]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCampaignSegment](
	[CampaignSegmentKey] [int] IDENTITY(1,1) NOT NULL,
	[CampaignKey] [int] NULL,
	[SegmentName] [varchar](500) NULL,
	[SegmentDescription] [text] NULL,
	[DisplayOrder] [int] NULL,
	[PlanStart] [smalldatetime] NULL,
	[PlanComplete] [smalldatetime] NULL,
	[LeadKey] [int] NULL,
	[ProjectTypeKey] [int] NULL,
	[EstHours] [decimal](24, 4) NULL,
	[BudgetLabor] [money] NULL,
	[EstLabor] [money] NULL,
	[BudgetExpenses] [money] NULL,
	[EstExpenses] [money] NULL,
	[ApprovedCOHours] [decimal](24, 4) NULL,
	[ApprovedCOLabor] [money] NULL,
	[ApprovedCOBudgetLabor] [money] NULL,
	[ApprovedCOExpense] [money] NULL,
	[ApprovedCOBudgetExp] [money] NULL,
	[Contingency] [money] NULL,
 CONSTRAINT [PK_tCampaignSegment] PRIMARY KEY CLUSTERED 
(
	[CampaignSegmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_EstHours]  DEFAULT ((0)) FOR [EstHours]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_BudgetLabor]  DEFAULT ((0)) FOR [BudgetLabor]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_EstLabor]  DEFAULT ((0)) FOR [EstLabor]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_BudgetExpenses]  DEFAULT ((0)) FOR [BudgetExpenses]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_EstExpenses]  DEFAULT ((0)) FOR [EstExpenses]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_ApprovedCOHours]  DEFAULT ((0)) FOR [ApprovedCOHours]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_ApprovedCOLabor]  DEFAULT ((0)) FOR [ApprovedCOLabor]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_ApprovedCOBudgetLabor]  DEFAULT ((0)) FOR [ApprovedCOBudgetLabor]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_ApprovedCOExpense]  DEFAULT ((0)) FOR [ApprovedCOExpense]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_ApprovedCOBudgetExp]  DEFAULT ((0)) FOR [ApprovedCOBudgetExp]
GO
ALTER TABLE [dbo].[tCampaignSegment] ADD  CONSTRAINT [DF_tCampaignSegment_Contingency]  DEFAULT ((0)) FOR [Contingency]
GO
