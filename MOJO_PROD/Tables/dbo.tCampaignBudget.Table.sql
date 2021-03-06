USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCampaignBudget]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCampaignBudget](
	[CampaignBudgetKey] [int] IDENTITY(1,1) NOT NULL,
	[CampaignKey] [int] NOT NULL,
	[ItemName] [varchar](500) NOT NULL,
	[Description] [text] NULL,
	[DisplayOrder] [int] NULL,
	[Qty] [decimal](24, 4) NULL,
	[Net] [money] NULL,
	[Gross] [money] NULL,
	[StartDate] [smalldatetime] NULL,
	[DueDate] [smalldatetime] NULL,
	[EstHours] [decimal](24, 4) NOT NULL,
	[BudgetLabor] [money] NULL,
	[EstLabor] [money] NOT NULL,
	[BudgetExpenses] [money] NOT NULL,
	[EstExpenses] [money] NOT NULL,
	[ApprovedCOHours] [decimal](24, 4) NOT NULL,
	[ApprovedCOLabor] [money] NOT NULL,
	[ApprovedCOBudgetLabor] [money] NULL,
	[ApprovedCOExpense] [money] NOT NULL,
	[ApprovedCOBudgetExp] [money] NULL,
 CONSTRAINT [PK_tCampaignBudget] PRIMARY KEY CLUSTERED 
(
	[CampaignBudgetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_EstHours]  DEFAULT ((0)) FOR [EstHours]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_BudgetLabor]  DEFAULT ((0)) FOR [BudgetLabor]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_EstLabor]  DEFAULT ((0)) FOR [EstLabor]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_BudgetExpenses]  DEFAULT ((0)) FOR [BudgetExpenses]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_EstExpenses]  DEFAULT ((0)) FOR [EstExpenses]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_ApprovedCOHours]  DEFAULT ((0)) FOR [ApprovedCOHours]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_ApprovedCOLabor]  DEFAULT ((0)) FOR [ApprovedCOLabor]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_ApprovedCOBudgetLabor]  DEFAULT ((0)) FOR [ApprovedCOBudgetLabor]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_ApprovedCOExpense]  DEFAULT ((0)) FOR [ApprovedCOExpense]
GO
ALTER TABLE [dbo].[tCampaignBudget] ADD  CONSTRAINT [DF_tCampaignBudget_ApprovedCOBudgetExp]  DEFAULT ((0)) FOR [ApprovedCOBudgetExp]
GO
