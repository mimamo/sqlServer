USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateTemplate]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEstimateTemplate](
	[EstimateTemplateKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[TemplateName] [varchar](200) NOT NULL,
	[EstDisplayMode] [smallint] NULL,
	[EstShowQuantity] [tinyint] NULL,
	[EstShowRate] [tinyint] NULL,
	[EstShowExpQuantity] [tinyint] NULL,
	[EstShowExpRate] [tinyint] NULL,
	[EstShowSubTasks] [smallint] NULL,
	[EstShowZeroAmounts] [tinyint] NULL,
	[EstShowDetail] [tinyint] NULL,
	[EstShowQuantityText] [tinyint] NULL,
	[EstBreakoutExpenses] [tinyint] NULL,
	[ShowAmountOnSummary] [tinyint] NULL,
	[GroupByBillingItem] [tinyint] NULL,
	[ShowProjectDescription] [tinyint] NULL,
	[LogoTop] [decimal](24, 4) NULL,
	[LogoLeft] [decimal](24, 4) NULL,
	[LogoHeight] [decimal](24, 4) NULL,
	[LogoWidth] [decimal](24, 4) NULL,
	[CompanyAddressTop] [decimal](24, 4) NULL,
	[CompanyAddressLeft] [decimal](24, 4) NULL,
	[CompanyAddressWidth] [decimal](24, 4) NULL,
	[ClientAddressTop] [decimal](24, 4) NULL,
	[ClientAddressLeft] [decimal](24, 4) NULL,
	[ClientAddressWidth] [decimal](24, 4) NULL,
	[Address1] [varchar](200) NULL,
	[Address2] [varchar](200) NULL,
	[Address3] [varchar](200) NULL,
	[Address4] [varchar](200) NULL,
	[Address5] [varchar](200) NULL,
	[CustomLogo] [tinyint] NULL,
	[LabelTop] [decimal](24, 4) NULL,
	[LabelLeft] [decimal](24, 4) NULL,
	[LabelWidth] [decimal](24, 4) NULL,
	[LabelSize] [int] NULL,
	[LabelFontName] [varchar](50) NULL,
	[LabelText] [varchar](50) NULL,
	[SSubjectFont] [varchar](50) NULL,
	[SSubjectSize] [smallint] NULL,
	[SSubjectBold] [tinyint] NULL,
	[SSubjectItalic] [tinyint] NULL,
	[SDescFont] [varchar](50) NULL,
	[SDescSize] [smallint] NULL,
	[SDescBold] [tinyint] NULL,
	[SDescItalic] [tinyint] NULL,
	[TSubjectFont] [varchar](50) NULL,
	[TSubjectSize] [smallint] NULL,
	[TSubjectBold] [tinyint] NULL,
	[TSubjectItalic] [tinyint] NULL,
	[TDescFont] [varchar](50) NULL,
	[TDescSize] [smallint] NULL,
	[TDescBold] [tinyint] NULL,
	[TDescItalic] [tinyint] NULL,
	[DHeaderFont] [varchar](50) NULL,
	[DHeaderSize] [smallint] NULL,
	[DHeaderBold] [tinyint] NULL,
	[DHeaderItalic] [tinyint] NULL,
	[DHeaderBorderStyle] [smallint] NULL,
	[DDetailFont] [varchar](50) NULL,
	[DDetailSize] [smallint] NULL,
	[DDetailBold] [tinyint] NULL,
	[DDetailItalic] [tinyint] NULL,
	[AddressFont] [varchar](50) NULL,
	[AddressSize] [smallint] NULL,
	[AddressBold] [tinyint] NULL,
	[AddressItalic] [tinyint] NULL,
	[HeaderFont] [varchar](50) NULL,
	[HeaderSize] [smallint] NULL,
	[HeaderBold] [tinyint] NULL,
	[HeaderItalic] [tinyint] NULL,
	[FooterFont] [varchar](50) NULL,
	[FooterSize] [smallint] NULL,
	[FooterBold] [tinyint] NULL,
	[FooterItalic] [tinyint] NULL,
	[FooterText] [text] NULL,
	[ContingencyText] [varchar](1000) NULL,
	[EstShowZeroTaxes] [tinyint] NULL,
	[RepeatHeader] [tinyint] NULL,
	[ShowApproverName] [tinyint] NULL,
	[LabelUserDefined1] [varchar](100) NULL,
	[LabelUserDefined2] [varchar](100) NULL,
	[LabelUserDefined3] [varchar](100) NULL,
	[LabelUserDefined4] [varchar](100) NULL,
	[LabelUserDefined5] [varchar](100) NULL,
	[LabelUserDefined6] [varchar](100) NULL,
	[LabelUserDefined7] [varchar](100) NULL,
	[LabelUserDefined8] [varchar](100) NULL,
	[LabelUserDefined9] [varchar](100) NULL,
	[LabelUserDefined10] [varchar](100) NULL,
	[HideCompanyName] [tinyint] NULL,
	[ShowEstimateNumber] [tinyint] NULL,
	[AddressKey] [int] NULL,
	[EstShowProduct] [tinyint] NULL,
	[EstShowDivision] [tinyint] NULL,
	[AddPhoneFaxToAddress] [tinyint] NULL,
	[KeepFooterTogether] [tinyint] NULL,
	[ShowLaborExpenseSubtotals] [tinyint] NULL,
	[HidePageNumbers] [tinyint] NULL,
	[HideClientName] [tinyint] NULL,
	[CompareToOriginal] [tinyint] NULL,
 CONSTRAINT [PK_tEstimateTemplate] PRIMARY KEY CLUSTERED 
(
	[EstimateTemplateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_GroupByBillingItem]  DEFAULT ((0)) FOR [GroupByBillingItem]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_ShowProjectDescription]  DEFAULT ((0)) FOR [ShowProjectDescription]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LogoTop]  DEFAULT ((0)) FOR [LogoTop]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LogoLeft]  DEFAULT ((0)) FOR [LogoLeft]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LogoHeight]  DEFAULT ((1)) FOR [LogoHeight]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LogoWidth]  DEFAULT ((4)) FOR [LogoWidth]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_CompanyAddressTop]  DEFAULT ((0.344)) FOR [CompanyAddressTop]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_CompanyAddressLeft]  DEFAULT ((4.938)) FOR [CompanyAddressLeft]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_CompanyAddressWidth]  DEFAULT ((2.5)) FOR [CompanyAddressWidth]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_ClientAddressTop]  DEFAULT ((1.281)) FOR [ClientAddressTop]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_ClientAddressLeft]  DEFAULT ((0)) FOR [ClientAddressLeft]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_ClientAddressWidth]  DEFAULT ((3.344)) FOR [ClientAddressWidth]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_CustomLogo]  DEFAULT ((0)) FOR [CustomLogo]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LabelTop]  DEFAULT ((0)) FOR [LabelTop]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LabelLeft]  DEFAULT ((6.406)) FOR [LabelLeft]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LabelWidth]  DEFAULT ((1.031)) FOR [LabelWidth]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LabelSize]  DEFAULT ((18)) FOR [LabelSize]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LabelFontName]  DEFAULT ('Arial') FOR [LabelFontName]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_LabelText]  DEFAULT ('Estimate') FOR [LabelText]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_EstHideZeroTaxes]  DEFAULT ((1)) FOR [EstShowZeroTaxes]
GO
ALTER TABLE [dbo].[tEstimateTemplate] ADD  CONSTRAINT [DF_tEstimateTemplate_RepeatHeader]  DEFAULT ((0)) FOR [RepeatHeader]
GO
