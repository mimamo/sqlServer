USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimate]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEstimate](
	[EstimateKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[EstimateName] [varchar](100) NULL,
	[EstimateDate] [smalldatetime] NULL,
	[Revision] [int] NULL,
	[EstType] [smallint] NULL,
	[EstDescription] [text] NULL,
	[EstimateTemplateKey] [int] NULL,
	[SalesTaxKey] [int] NULL,
	[SalesTaxAmount] [money] NULL,
	[SalesTax2Key] [int] NULL,
	[SalesTax2Amount] [money] NULL,
	[LaborTaxable] [tinyint] NULL,
	[Contingency] [decimal](24, 4) NULL,
	[ChangeOrder] [tinyint] NULL,
	[InternalApprover] [int] NULL,
	[InternalApproval] [smalldatetime] NULL,
	[InternalStatus] [smallint] NULL,
	[InternalComments] [text] NULL,
	[InternalDueDate] [smalldatetime] NULL,
	[ExternalApprover] [int] NULL,
	[ExternalApproval] [smalldatetime] NULL,
	[ExternalStatus] [smallint] NULL,
	[ExternalComments] [text] NULL,
	[ExternalDueDate] [smalldatetime] NULL,
	[MultipleQty] [tinyint] NULL,
	[ApprovedQty] [smallint] NULL,
	[Expense1] [varchar](100) NULL,
	[Expense2] [varchar](100) NULL,
	[Expense3] [varchar](100) NULL,
	[Expense4] [varchar](100) NULL,
	[Expense5] [varchar](100) NULL,
	[Expense6] [varchar](100) NULL,
	[EnteredBy] [int] NULL,
	[DateAdded] [smalldatetime] NULL,
	[EstimateTotal] [money] NULL,
	[LaborGross] [money] NULL,
	[ExpenseGross] [money] NULL,
	[TaxableTotal] [money] NULL,
	[ContingencyTotal] [money] NULL,
	[LaborNet] [money] NULL,
	[ExpenseNet] [money] NULL,
	[Hours] [decimal](24, 4) NULL,
	[EstimateNumber] [varchar](50) NULL,
	[DeliveryDate] [smalldatetime] NULL,
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
	[PrimaryContactKey] [int] NULL,
	[AddressKey] [int] NULL,
	[CampaignKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LayoutKey] [int] NULL,
	[LineFormat] [smallint] NULL,
	[HideZeroAmountServices] [tinyint] NULL,
	[UseRateLevel] [tinyint] NULL,
	[IncludeInForecast] [tinyint] NOT NULL,
	[UseTitle] [tinyint] NOT NULL,
 CONSTRAINT [PK_tEstimate] PRIMARY KEY NONCLUSTERED 
(
	[EstimateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_Type]  DEFAULT ((1)) FOR [EstType]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_LaborTaxable]  DEFAULT ((0)) FOR [LaborTaxable]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_Contingency]  DEFAULT ((0)) FOR [Contingency]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_ChangeOrder]  DEFAULT ((0)) FOR [ChangeOrder]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_InternalStatus]  DEFAULT ((1)) FOR [InternalStatus]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_ExternalStatus]  DEFAULT ((1)) FOR [ExternalStatus]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_MultipleQtyOptions]  DEFAULT ((0)) FOR [MultipleQty]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_ApprovedQty]  DEFAULT ((1)) FOR [ApprovedQty]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_UseRateLevel]  DEFAULT ((0)) FOR [UseRateLevel]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_IncludeInForecast]  DEFAULT ((0)) FOR [IncludeInForecast]
GO
ALTER TABLE [dbo].[tEstimate] ADD  CONSTRAINT [DF_tEstimate_UseTitle]  DEFAULT ((0)) FOR [UseTitle]
GO
