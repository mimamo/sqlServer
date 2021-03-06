USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProject]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProject](
	[ProjectKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](100) NOT NULL,
	[ProjectNumber] [varchar](50) NULL,
	[CompanyKey] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientProjectNumber] [varchar](200) NULL,
	[BillingContact] [int] NULL,
	[EstimateKey] [int] NULL,
	[RetainerKey] [int] NULL,
	[BillingMethod] [smallint] NOT NULL,
	[ExpensesNotIncluded] [tinyint] NULL,
	[GetRateFrom] [smallint] NOT NULL,
	[TimeRateSheetKey] [int] NULL,
	[HourlyRate] [money] NOT NULL,
	[OverrideRate] [tinyint] NOT NULL,
	[GetMarkupFrom] [smallint] NULL,
	[ItemRateSheetKey] [int] NULL,
	[ItemMarkup] [decimal](24, 4) NULL,
	[IOCommission] [decimal](24, 4) NULL,
	[BCCommission] [decimal](24, 4) NULL,
	[NonBillable] [tinyint] NULL,
	[Closed] [tinyint] NULL,
	[ProjectStatusKey] [int] NULL,
	[ProjectBillingStatusKey] [int] NULL,
	[ProjectTypeKey] [int] NULL,
	[RequestKey] [int] NULL,
	[KeyPeople1] [int] NULL,
	[KeyPeople2] [int] NULL,
	[KeyPeople3] [int] NULL,
	[KeyPeople4] [int] NULL,
	[KeyPeople5] [int] NULL,
	[KeyPeople6] [int] NULL,
	[Description] [text] NULL,
	[StatusNotes] [varchar](100) NULL,
	[DetailedNotes] [varchar](4000) NULL,
	[ClientNotes] [varchar](4000) NULL,
	[ImageFolderKey] [int] NULL,
	[Active] [tinyint] NULL,
	[CustomFieldKey] [int] NULL,
	[Deleted] [tinyint] NULL,
	[StartDate] [smalldatetime] NULL,
	[CompleteDate] [smalldatetime] NULL,
	[ScheduleDirection] [smallint] NULL,
	[WorkMon] [tinyint] NULL,
	[WorkTue] [tinyint] NULL,
	[WorkWed] [tinyint] NULL,
	[WorkThur] [tinyint] NULL,
	[WorkFri] [tinyint] NULL,
	[WorkSat] [tinyint] NULL,
	[WorkSun] [tinyint] NULL,
	[OfficeKey] [int] NULL,
	[AccountManager] [int] NULL,
	[UserDefined1] [varchar](250) NULL,
	[UserDefined2] [varchar](250) NULL,
	[UserDefined3] [varchar](250) NULL,
	[UserDefined4] [varchar](250) NULL,
	[UserDefined5] [varchar](250) NULL,
	[UserDefined6] [varchar](250) NULL,
	[UserDefined7] [varchar](250) NULL,
	[UserDefined8] [varchar](250) NULL,
	[UserDefined9] [varchar](250) NULL,
	[UserDefined10] [varchar](250) NULL,
	[CampaignKey] [int] NULL,
	[ClientDivisionKey] [int] NULL,
	[ClientProductKey] [int] NULL,
	[EstHours] [decimal](24, 4) NOT NULL,
	[BudgetLabor] [money] NULL,
	[EstLabor] [money] NOT NULL,
	[BudgetExpenses] [money] NOT NULL,
	[EstExpenses] [money] NOT NULL,
	[ApprovedCOHours] [decimal](24, 4) NOT NULL,
	[ApprovedCOLabor] [money] NOT NULL,
	[ApprovedCOBudgetLabor] [money] NULL,
	[ApprovedCOExpense] [money] NOT NULL,
	[ApprovedCOBudgetExp] [money] NOT NULL,
	[Contingency] [money] NOT NULL,
	[CreatedDate] [smalldatetime] NULL,
	[CreatedByKey] [int] NULL,
	[Template] [tinyint] NULL,
	[FlightStartDate] [smalldatetime] NULL,
	[FlightEndDate] [smalldatetime] NULL,
	[FlightInterval] [tinyint] NULL,
	[SalesTax] [money] NULL,
	[ApprovedCOSalesTax] [money] NULL,
	[ScheduleLockedByKey] [int] NULL,
	[Duration] [int] NULL,
	[PercComp] [int] NULL,
	[TaskStatus] [smallint] NULL,
	[ProjectColor] [varchar](10) NULL,
	[CampaignBudgetKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[ClassKey] [int] NULL,
	[LeadKey] [int] NULL,
	[TeamKey] [int] NULL,
	[CampaignSegmentKey] [int] NULL,
	[LayoutKey] [int] NULL,
	[AutoIDTask] [tinyint] NULL,
	[SimpleSchedule] [tinyint] NULL,
	[CampaignOrder] [int] NULL,
	[ProjectCloseDate] [smalldatetime] NULL,
	[FilesArchived] [tinyint] NULL,
	[ClientBHours] [tinyint] NULL,
	[ClientBLabor] [tinyint] NULL,
	[ClientBExpenses] [tinyint] NULL,
	[ClientBCO] [tinyint] NULL,
	[ClientAHours] [tinyint] NULL,
	[ClientALabor] [tinyint] NULL,
	[ClientAPO] [tinyint] NULL,
	[ClientAExpenses] [tinyint] NULL,
	[GLCompanySource] [smallint] NULL,
	[ShowTransactionsOnInvoices] [tinyint] NULL,
	[DoNotPostWIP] [tinyint] NULL,
	[BillingGroupCode] [varchar](50) NULL,
	[UtilizationType] [varchar](50) NULL,
	[BillingGroupKey] [int] NULL,
	[WebDavProjectNumber] [varchar](100) NULL,
	[WebDavProjectName] [varchar](100) NULL,
	[ModelYear] [varchar](10) NULL,
	[PrimaryDemographic] [int] NULL,
	[FlightStartDay] [smallint] NULL,
	[CurrencyID] [varchar](10) NULL,
	[BillingManagerKey] [int] NULL,
	[TitleRateSheetKey] [int] NULL,
	[AnyoneChargeTime] [tinyint] NOT NULL,
 CONSTRAINT [tProject_PK] PRIMARY KEY CLUSTERED 
(
	[ProjectKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProject]  WITH NOCHECK ADD  CONSTRAINT [FK_tProject_tCampaign] FOREIGN KEY([CampaignKey])
REFERENCES [dbo].[tCampaign] ([CampaignKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tProject] CHECK CONSTRAINT [FK_tProject_tCampaign]
GO
ALTER TABLE [dbo].[tProject]  WITH NOCHECK ADD  CONSTRAINT [FK_tProject_tClientProduct] FOREIGN KEY([ClientProductKey])
REFERENCES [dbo].[tClientProduct] ([ClientProductKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tProject] CHECK CONSTRAINT [FK_tProject_tClientProduct]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_BillingMethod]  DEFAULT ((1)) FOR [BillingMethod]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_GetRateFrom]  DEFAULT ((2)) FOR [GetRateFrom]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_HourlyRate]  DEFAULT ((0)) FOR [HourlyRate]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_OverrideRate]  DEFAULT ((0)) FOR [OverrideRate]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_GetItemRateFrom]  DEFAULT ((2)) FOR [GetMarkupFrom]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ItemMarkup]  DEFAULT ((0)) FOR [ItemMarkup]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_NonBillable]  DEFAULT ((0)) FOR [NonBillable]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_Closed]  DEFAULT ((0)) FOR [Closed]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_StartDate]  DEFAULT ((((CONVERT([varchar](2),datepart(month,getdate()),0)+'/')+CONVERT([varchar](2),datepart(day,getdate()),0))+'/')+CONVERT([varchar](4),datepart(year,getdate()),0)) FOR [StartDate]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ScheduleDirection]  DEFAULT ((1)) FOR [ScheduleDirection]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkMon]  DEFAULT ((1)) FOR [WorkMon]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkTue]  DEFAULT ((1)) FOR [WorkTue]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkWed]  DEFAULT ((1)) FOR [WorkWed]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkThur]  DEFAULT ((1)) FOR [WorkThur]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkFri]  DEFAULT ((1)) FOR [WorkFri]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkSat]  DEFAULT ((0)) FOR [WorkSat]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_WorkSun]  DEFAULT ((0)) FOR [WorkSun]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_EstHours]  DEFAULT ((0)) FOR [EstHours]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_BudgetLabor]  DEFAULT ((0)) FOR [BudgetLabor]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_EstLabor]  DEFAULT ((0)) FOR [EstLabor]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_BudgetExpenses]  DEFAULT ((0)) FOR [BudgetExpenses]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_EstExpenses]  DEFAULT ((0)) FOR [EstExpenses]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ApprovedCOHours]  DEFAULT ((0)) FOR [ApprovedCOHours]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ApprovedCOLabor]  DEFAULT ((0)) FOR [ApprovedCOLabor]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ApprovedCOBudgetLabor]  DEFAULT ((0)) FOR [ApprovedCOBudgetLabor]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ApprovedCOExpense]  DEFAULT ((0)) FOR [ApprovedCOExpense]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ApprovedCOBudgetExp]  DEFAULT ((0)) FOR [ApprovedCOBudgetExp]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_Contingency]  DEFAULT ((0)) FOR [Contingency]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_TaskStatus]  DEFAULT ((1)) FOR [TaskStatus]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_CampaignOrder]  DEFAULT ((0)) FOR [CampaignOrder]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientBHours]  DEFAULT ((1)) FOR [ClientBHours]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientBLabor]  DEFAULT ((1)) FOR [ClientBLabor]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientBExpenses]  DEFAULT ((1)) FOR [ClientBExpenses]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientBCO]  DEFAULT ((1)) FOR [ClientBCO]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientAHours]  DEFAULT ((1)) FOR [ClientAHours]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientALabor]  DEFAULT ((1)) FOR [ClientALabor]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientAPO]  DEFAULT ((1)) FOR [ClientAPO]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_ClientAExpenses]  DEFAULT ((1)) FOR [ClientAExpenses]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_GLCompanySource]  DEFAULT ((0)) FOR [GLCompanySource]
GO
ALTER TABLE [dbo].[tProject] ADD  CONSTRAINT [DF_tProject_AnyoneChargeTime]  DEFAULT ((0)) FOR [AnyoneChargeTime]
GO
