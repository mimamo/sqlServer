USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLead]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLead](
	[LeadKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Subject] [varchar](200) NULL,
	[ContactCompanyKey] [int] NULL,
	[ContactKey] [int] NULL,
	[AccountManagerKey] [int] NULL,
	[ProjectTypeKey] [int] NULL,
	[Competitors] [varchar](1000) NULL,
	[LeadStatusKey] [int] NULL,
	[LeadStageKey] [int] NULL,
	[LeadOutcomeKey] [int] NULL,
	[CurrentStatus] [varchar](300) NULL,
	[OutcomeComment] [text] NULL,
	[User1] [varchar](250) NULL,
	[User2] [varchar](250) NULL,
	[User3] [varchar](250) NULL,
	[User4] [varchar](250) NULL,
	[User5] [varchar](250) NULL,
	[User6] [varchar](250) NULL,
	[User7] [varchar](250) NULL,
	[User8] [varchar](250) NULL,
	[User9] [varchar](250) NULL,
	[User10] [varchar](250) NULL,
	[Probability] [int] NULL,
	[SaleAmount] [money] NULL,
	[SubAmount] [money] NULL,
	[Margin] [int] NULL,
	[Bid] [tinyint] NULL,
	[BidDate] [smalldatetime] NULL,
	[StartDate] [smalldatetime] NULL,
	[EstCloseDate] [smalldatetime] NULL,
	[ActualCloseDate] [smalldatetime] NULL,
	[Comments] [text] NULL,
	[ProjectKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[WWPCurrentLevel] [smallint] NULL,
	[WWPNeedSupply] [tinyint] NULL,
	[WWPNeedSupplyComment] [text] NULL,
	[WWPTimeline] [tinyint] NULL,
	[WWPTimelineComment] [text] NULL,
	[WWPDecisionMakers] [tinyint] NULL,
	[WWPDecisionMakersComment] [text] NULL,
	[WWPBudget] [tinyint] NULL,
	[WWPBudgetComment] [text] NULL,
	[AddedByKey] [int] NULL,
	[UpdatedByKey] [int] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[LastActivityKey] [int] NULL,
	[NextActivityKey] [int] NULL,
	[CMFolderKey] [int] NULL,
	[OutsideCostsGross] [money] NULL,
	[MediaGross] [money] NULL,
	[OutsideCostsPerc] [decimal](24, 4) NULL,
	[MediaPerc] [decimal](24, 4) NULL,
	[AGI] [money] NULL,
	[DateConverted] [smalldatetime] NULL,
	[MultipleSegments] [tinyint] NULL,
	[EstimateType] [smallint] NULL,
	[TemplateProjectKey] [int] NULL,
	[LayoutKey] [int] NULL,
	[ConvertEntity] [varchar](50) NULL,
	[ConvertEntityKey] [int] NULL,
	[ConvertedByKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[Labor] [money] NULL,
	[Months] [int] NULL,
	[SpreadExpense] [smallint] NULL,
	[ClientProductKey] [int] NULL,
	[ClientDivisionKey] [int] NULL,
 CONSTRAINT [PK_tLead] PRIMARY KEY NONCLUSTERED 
(
	[LeadKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tLead]  WITH CHECK ADD  CONSTRAINT [FK_tLead_tLeadStage] FOREIGN KEY([LeadStageKey])
REFERENCES [dbo].[tLeadStage] ([LeadStageKey])
GO
ALTER TABLE [dbo].[tLead] CHECK CONSTRAINT [FK_tLead_tLeadStage]
GO
ALTER TABLE [dbo].[tLead]  WITH CHECK ADD  CONSTRAINT [FK_tLead_tLeadStatus] FOREIGN KEY([LeadStatusKey])
REFERENCES [dbo].[tLeadStatus] ([LeadStatusKey])
GO
ALTER TABLE [dbo].[tLead] CHECK CONSTRAINT [FK_tLead_tLeadStatus]
GO
ALTER TABLE [dbo].[tLead] ADD  CONSTRAINT [DF_tLead_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[tLead] ADD  CONSTRAINT [DF_tLead_DateUpdated]  DEFAULT (getdate()) FOR [DateUpdated]
GO
ALTER TABLE [dbo].[tLead] ADD  CONSTRAINT [DF_tLead_MultipleSegments]  DEFAULT ((0)) FOR [MultipleSegments]
GO
ALTER TABLE [dbo].[tLead] ADD  CONSTRAINT [DF_tLead_EstimateType]  DEFAULT ((1)) FOR [EstimateType]
GO
