USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tInvoiceTemplate]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tInvoiceTemplate](
	[InvoiceTemplateKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[TemplateName] [varchar](200) NOT NULL,
	[ShowAmountsAtSummary] [tinyint] NOT NULL,
	[ShowDetailLines] [tinyint] NOT NULL,
	[ShowTime] [tinyint] NOT NULL,
	[TimeSummaryLevel] [smallint] NOT NULL,
	[ShowComments] [tinyint] NOT NULL,
	[ShowExpenses] [tinyint] NOT NULL,
	[ShowProjectCustFields] [tinyint] NOT NULL,
	[ShowProjectNumber] [tinyint] NULL,
	[ShowClientProjectNumber] [tinyint] NULL,
	[ClientProjectNumberLabel] [varchar](100) NULL,
	[ShowProjectDescription] [tinyint] NULL,
	[HidePageNumbers] [tinyint] NULL,
	[HideZeroReceipts] [tinyint] NULL,
	[QtyDescription] [tinyint] NULL,
	[ShowLaborHrs] [tinyint] NULL,
	[ShowLaborRate] [tinyint] NULL,
	[ShowTitle] [tinyint] NULL,
	[ShowExpDate] [tinyint] NULL,
	[ShowExpDescription] [tinyint] NULL,
	[ShowExpItemDesc] [tinyint] NULL,
	[ShowExpQty] [tinyint] NULL,
	[ShowExpRate] [tinyint] NULL,
	[ShowExpNet] [tinyint] NULL,
	[ShowExpMarkup] [tinyint] NULL,
	[ShowExpGross] [tinyint] NULL,
	[SortExpBy] [smallint] NULL,
	[GroupExpByItem] [tinyint] NULL,
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
	[FooterMessage] [varchar](2000) NULL,
	[LogoTop] [decimal](9, 3) NULL,
	[LogoLeft] [decimal](9, 3) NULL,
	[LogoHeight] [decimal](9, 3) NULL,
	[LogoWidth] [decimal](9, 3) NULL,
	[CompanyAddressTop] [decimal](9, 3) NULL,
	[CompanyAddressLeft] [decimal](9, 3) NULL,
	[CompanyAddressWidth] [decimal](9, 3) NULL,
	[ClientAddressTop] [decimal](9, 3) NULL,
	[ClientAddressLeft] [decimal](9, 3) NULL,
	[ClientAddressWidth] [decimal](9, 3) NULL,
	[Address1] [varchar](200) NULL,
	[Address2] [varchar](200) NULL,
	[Address3] [varchar](200) NULL,
	[Address4] [varchar](200) NULL,
	[Address5] [varchar](200) NULL,
	[CustomLogo] [tinyint] NULL,
	[NumberTop] [decimal](9, 3) NULL,
	[NumberLeft] [decimal](9, 3) NULL,
	[ShowInvoiceNum] [tinyint] NULL,
	[ShowInvoiceDate] [tinyint] NULL,
	[ShowTerms] [tinyint] NULL,
	[ShowDueDate] [tinyint] NULL,
	[ShowAE] [tinyint] NULL,
	[RepeatHeader] [tinyint] NULL,
	[LabelTop] [decimal](9, 3) NULL,
	[LabelLeft] [decimal](9, 3) NULL,
	[LabelWidth] [decimal](9, 3) NULL,
	[InvoiceLabel] [varchar](100) NULL,
	[InvoiceLabelSize] [int] NULL,
	[FontName] [varchar](50) NULL,
	[HeaderFontSize] [int] NULL,
	[DetailFontSize] [int] NULL,
	[ShowClientUserDefined] [tinyint] NULL,
	[AddressFont] [varchar](50) NULL,
	[AddressSize] [smallint] NULL,
	[AddressBold] [tinyint] NULL,
	[AddressItalic] [tinyint] NULL,
	[HeaderFont] [varchar](50) NULL,
	[HeaderSize] [smallint] NULL,
	[HeaderBold] [tinyint] NULL,
	[HeaderItalic] [tinyint] NULL,
	[SummaryLineFont] [varchar](50) NULL,
	[SummaryLineSize] [smallint] NULL,
	[SummaryLineBold] [tinyint] NULL,
	[SummaryLineItalic] [tinyint] NULL,
	[SummaryDescFont] [varchar](50) NULL,
	[SummaryDescSize] [smallint] NULL,
	[SummaryDescBold] [tinyint] NULL,
	[SummaryDescItalic] [tinyint] NULL,
	[DetailLineFont] [varchar](50) NULL,
	[DetailLineSize] [smallint] NULL,
	[DetailLineBold] [tinyint] NULL,
	[DetailLineItalic] [tinyint] NULL,
	[DetailDescFont] [varchar](50) NULL,
	[DetailDescSize] [smallint] NULL,
	[DetailDescBold] [tinyint] NULL,
	[DetailDescItalic] [tinyint] NULL,
	[DetailsHeaderFont] [varchar](50) NULL,
	[DetailsHeaderSize] [smallint] NULL,
	[DetailsHeaderBold] [tinyint] NULL,
	[DetailsHeaderItalic] [tinyint] NULL,
	[DetailsHeaderBorder] [smallint] NULL,
	[DetailsFont] [varchar](50) NULL,
	[DetailsSize] [smallint] NULL,
	[DetailsBold] [tinyint] NULL,
	[DetailsItalic] [tinyint] NULL,
	[FooterFont] [varchar](50) NULL,
	[FooterSize] [smallint] NULL,
	[FooterBold] [tinyint] NULL,
	[FooterItalic] [tinyint] NULL,
	[GroupLaborDetailBy] [smallint] NULL,
	[ShowZeroTaxes] [tinyint] NULL,
	[BCGroup1] [int] NULL,
	[BCTotal1] [tinyint] NULL,
	[BCGroup2] [int] NULL,
	[BCTotal2] [tinyint] NULL,
	[BCGroup3] [int] NULL,
	[BCTotal3] [tinyint] NULL,
	[BCGroup4] [int] NULL,
	[BCTotal4] [tinyint] NULL,
	[BCGroup5] [int] NULL,
	[BCTotal5] [tinyint] NULL,
	[BCCol1] [varchar](60) NULL,
	[BCColWidth1] [decimal](24, 4) NULL,
	[BCCol2] [varchar](60) NULL,
	[BCColWidth2] [decimal](24, 4) NULL,
	[BCCol3] [varchar](60) NULL,
	[BCColWidth3] [decimal](24, 4) NULL,
	[BCCol4] [varchar](60) NULL,
	[BCColWidth4] [decimal](24, 4) NULL,
	[BCCol5] [varchar](60) NULL,
	[BCColWidth5] [decimal](24, 4) NULL,
	[BCCol6] [varchar](60) NULL,
	[BCColWidth6] [decimal](24, 4) NULL,
	[BCCol7] [varchar](60) NULL,
	[BCColWidth7] [decimal](24, 4) NULL,
	[BCCol8] [varchar](60) NULL,
	[BCColWidth8] [decimal](24, 4) NULL,
	[IOGroup1] [int] NULL,
	[IOTotal1] [tinyint] NULL,
	[IOGroup2] [int] NULL,
	[IOTotal2] [tinyint] NULL,
	[IOGroup3] [int] NULL,
	[IOTotal3] [tinyint] NULL,
	[IOGroup4] [int] NULL,
	[IOTotal4] [tinyint] NULL,
	[IOGroup5] [int] NULL,
	[IOTotal5] [tinyint] NULL,
	[IOCol1] [varchar](60) NULL,
	[IOColWidth1] [decimal](24, 4) NULL,
	[IOCol2] [varchar](60) NULL,
	[IOColWidth2] [decimal](24, 4) NULL,
	[IOCol3] [varchar](60) NULL,
	[IOColWidth3] [decimal](24, 4) NULL,
	[IOCol4] [varchar](60) NULL,
	[IOColWidth4] [decimal](24, 4) NULL,
	[IOCol5] [varchar](60) NULL,
	[IOColWidth5] [decimal](24, 4) NULL,
	[IOCol6] [varchar](60) NULL,
	[IOColWidth6] [decimal](24, 4) NULL,
	[IOCol7] [varchar](60) NULL,
	[IOColWidth7] [decimal](24, 4) NULL,
	[InvoiceLabelForAll] [tinyint] NULL,
	[ShowLineQuantityRate] [tinyint] NULL,
	[HideCompanyName] [tinyint] NULL,
	[BCHideDetails] [tinyint] NULL,
	[AddressKey] [int] NULL,
	[IOHideDetails] [tinyint] NULL,
	[ShowProduct] [tinyint] NULL,
	[ShowDivision] [tinyint] NULL,
	[AddPhoneFaxToAddress] [tinyint] NULL,
	[KeepFooterTogether] [tinyint] NULL,
	[ShowBillingSummary] [tinyint] NULL,
	[BCGroupByOrder] [tinyint] NULL,
	[IOGroupByOrder] [tinyint] NULL,
	[HideClientName] [tinyint] NULL,
	[ShowExpComments] [tinyint] NULL,
	[ShowCampaign] [tinyint] NULL,
 CONSTRAINT [PK_tInvoiceTemplate] PRIMARY KEY NONCLUSTERED 
(
	[InvoiceTemplateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowAmountsAtSummary]  DEFAULT ((0)) FOR [ShowAmountsAtSummary]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowDetailLines]  DEFAULT ((1)) FOR [ShowDetailLines]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_QtyDescription]  DEFAULT ((0)) FOR [QtyDescription]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowLaborHrs]  DEFAULT ((1)) FOR [ShowLaborHrs]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowLaborRate]  DEFAULT ((1)) FOR [ShowLaborRate]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowTitle]  DEFAULT ((0)) FOR [ShowTitle]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpDate]  DEFAULT ((1)) FOR [ShowExpDate]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpDescription]  DEFAULT ((1)) FOR [ShowExpDescription]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpItemDesc]  DEFAULT ((0)) FOR [ShowExpItemDesc]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpQty]  DEFAULT ((1)) FOR [ShowExpQty]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpRate]  DEFAULT ((1)) FOR [ShowExpRate]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpNet]  DEFAULT ((0)) FOR [ShowExpNet]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpMarkup]  DEFAULT ((0)) FOR [ShowExpMarkup]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowExpGross]  DEFAULT ((1)) FOR [ShowExpGross]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_SortExpBy]  DEFAULT ((1)) FOR [SortExpBy]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_GroupExpByItem]  DEFAULT ((0)) FOR [GroupExpByItem]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LogoTop]  DEFAULT ((0)) FOR [LogoTop]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LogoLeft]  DEFAULT ((0)) FOR [LogoLeft]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LogoHeight]  DEFAULT ((1)) FOR [LogoHeight]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LogoWidth]  DEFAULT ((4)) FOR [LogoWidth]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_CompanyAddressTop]  DEFAULT ((0.344)) FOR [CompanyAddressTop]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_CompanyAddressLeft]  DEFAULT ((4.938)) FOR [CompanyAddressLeft]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_CompanyAddressWidth]  DEFAULT ((2.5)) FOR [CompanyAddressWidth]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ClientAddressTop]  DEFAULT ((1.281)) FOR [ClientAddressTop]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ClientAddressLeft]  DEFAULT ((0)) FOR [ClientAddressLeft]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ClientAddressWidth]  DEFAULT ((3.344)) FOR [ClientAddressWidth]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_CustomLogo]  DEFAULT ((0)) FOR [CustomLogo]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_NumberTop]  DEFAULT ((1.344)) FOR [NumberTop]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_NumberLeft]  DEFAULT ((4.906)) FOR [NumberLeft]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowInvoiceNum]  DEFAULT ((1)) FOR [ShowInvoiceNum]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowInvoiceDate]  DEFAULT ((1)) FOR [ShowInvoiceDate]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowTerms]  DEFAULT ((1)) FOR [ShowTerms]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowDueDate]  DEFAULT ((1)) FOR [ShowDueDate]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LabelTop]  DEFAULT ((0)) FOR [LabelTop]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LabelLeft]  DEFAULT ((6.406)) FOR [LabelLeft]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_LabelWidth]  DEFAULT ((1.031)) FOR [LabelWidth]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_InvoiceLabel]  DEFAULT ('Invoice') FOR [InvoiceLabel]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_InvoiceLabelSize]  DEFAULT ((18)) FOR [InvoiceLabelSize]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_FontName]  DEFAULT ('Arial') FOR [FontName]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_HeaderFontSize]  DEFAULT ((8)) FOR [HeaderFontSize]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_DetailFontSize]  DEFAULT ((8)) FOR [DetailFontSize]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowSubDetails]  DEFAULT ((0)) FOR [GroupLaborDetailBy]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowZeroTaxes]  DEFAULT ((1)) FOR [ShowZeroTaxes]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowLineQuantityRate]  DEFAULT ((0)) FOR [ShowLineQuantityRate]
GO
ALTER TABLE [dbo].[tInvoiceTemplate] ADD  CONSTRAINT [DF_tInvoiceTemplate_ShowBillingSummary]  DEFAULT ((0)) FOR [ShowBillingSummary]
GO
