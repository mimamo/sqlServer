USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCampaign]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCampaign](
	[CampaignKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[CampaignID] [varchar](50) NOT NULL,
	[CampaignName] [varchar](200) NOT NULL,
	[ClientKey] [int] NOT NULL,
	[Description] [text] NULL,
	[Objective] [text] NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[AEKey] [int] NULL,
	[LaborHours] [int] NULL,
	[LaborBudget] [money] NULL,
	[OutsideExpenseNet] [money] NULL,
	[OutsideExpenseGross] [money] NULL,
	[MediaNet] [money] NULL,
	[MediaGross] [money] NULL,
	[Active] [tinyint] NULL,
	[CustomFieldKey] [int] NULL,
	[GetActualsBy] [smallint] NULL,
	[MultipleSegments] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[LayoutKey] [int] NULL,
	[BillBy] [smallint] NULL,
	[LeadKey] [int] NULL,
	[OneLinePer] [smallint] NULL,
	[ContactKey] [int] NULL,
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
	[SalesTax] [money] NULL,
	[ApprovedCOSalesTax] [money] NULL,
	[GLCompanyKey] [int] NULL,
	[ClientDivisionKey] [int] NULL,
	[ClientProductKey] [int] NULL,
	[NextProjectNum] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
 CONSTRAINT [PK_tCampaign] PRIMARY KEY CLUSTERED 
(
	[CampaignKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_EstHours]  DEFAULT ((0)) FOR [EstHours]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_BudgetLabor]  DEFAULT ((0)) FOR [BudgetLabor]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_EstLabor]  DEFAULT ((0)) FOR [EstLabor]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_BudgetExpenses]  DEFAULT ((0)) FOR [BudgetExpenses]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_EstExpenses]  DEFAULT ((0)) FOR [EstExpenses]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_ApprovedCOHours]  DEFAULT ((0)) FOR [ApprovedCOHours]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_ApprovedCOLabor]  DEFAULT ((0)) FOR [ApprovedCOLabor]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_ApprovedCOBudgetLabor]  DEFAULT ((0)) FOR [ApprovedCOBudgetLabor]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_ApprovedCOExpense]  DEFAULT ((0)) FOR [ApprovedCOExpense]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_ApprovedCOBudgetExp]  DEFAULT ((0)) FOR [ApprovedCOBudgetExp]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_Contingency]  DEFAULT ((0)) FOR [Contingency]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_SalesTax]  DEFAULT ((0)) FOR [SalesTax]
GO
ALTER TABLE [dbo].[tCampaign] ADD  CONSTRAINT [DF_tCampaign_ApproveCOSalesTax]  DEFAULT ((0)) FOR [ApprovedCOSalesTax]
GO
