USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectTitleRollup]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectTitleRollup](
	[ProjectKey] [int] NOT NULL,
	[TitleKey] [int] NOT NULL,
	[Hours] [decimal](24, 4) NOT NULL,
	[HoursApproved] [decimal](24, 4) NOT NULL,
	[HoursBilled] [decimal](24, 4) NOT NULL,
	[HoursInvoiced] [decimal](24, 4) NOT NULL,
	[LaborNet] [money] NOT NULL,
	[LaborNetApproved] [money] NOT NULL,
	[LaborGross] [money] NOT NULL,
	[LaborGrossApproved] [money] NOT NULL,
	[LaborUnbilled] [money] NOT NULL,
	[LaborWriteOff] [money] NOT NULL,
	[LaborBilled] [money] NOT NULL,
	[LaborInvoiced] [money] NOT NULL,
	[BilledAmount] [money] NOT NULL,
	[BilledAmountApproved] [money] NOT NULL,
	[AdvanceBilled] [money] NOT NULL,
	[AdvanceBilledOpen] [money] NOT NULL,
	[UpdateStarted] [datetime] NULL,
	[UpdateEnded] [datetime] NULL,
	[UpdateString] [varchar](250) NULL,
	[BilledAmountNoTax] [money] NOT NULL,
	[EstQty] [decimal](24, 4) NOT NULL,
	[EstNet] [money] NOT NULL,
	[EstGross] [money] NOT NULL,
	[EstCOQty] [decimal](24, 4) NOT NULL,
	[EstCONet] [money] NOT NULL,
	[EstCOGross] [money] NOT NULL,
 CONSTRAINT [PK_tProjectTitleRollup] PRIMARY KEY CLUSTERED 
(
	[ProjectKey] ASC,
	[TitleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_Hours]  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_HoursApproved]  DEFAULT ((0)) FOR [HoursApproved]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_HoursBilled]  DEFAULT ((0)) FOR [HoursBilled]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_HoursInvoiced]  DEFAULT ((0)) FOR [HoursInvoiced]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborNet]  DEFAULT ((0)) FOR [LaborNet]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborNetApproved]  DEFAULT ((0)) FOR [LaborNetApproved]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborGross]  DEFAULT ((0)) FOR [LaborGross]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborGrossApproved]  DEFAULT ((0)) FOR [LaborGrossApproved]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborUnbilled]  DEFAULT ((0)) FOR [LaborUnbilled]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborWriteOff]  DEFAULT ((0)) FOR [LaborWriteOff]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborBilled]  DEFAULT ((0)) FOR [LaborBilled]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_LaborInvoiced]  DEFAULT ((0)) FOR [LaborInvoiced]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_BilledAmount]  DEFAULT ((0)) FOR [BilledAmount]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_BilledAmountApproved]  DEFAULT ((0)) FOR [BilledAmountApproved]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_AdvanceBilled]  DEFAULT ((0)) FOR [AdvanceBilled]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_AdvanceBilledOpen]  DEFAULT ((0)) FOR [AdvanceBilledOpen]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_BilledAmountNoTax]  DEFAULT ((0)) FOR [BilledAmountNoTax]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_EstQty]  DEFAULT ((0)) FOR [EstQty]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_EstNet]  DEFAULT ((0)) FOR [EstNet]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_EstGross]  DEFAULT ((0)) FOR [EstGross]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_EstCOQty]  DEFAULT ((0)) FOR [EstCOQty]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_EstCONet]  DEFAULT ((0)) FOR [EstCONet]
GO
ALTER TABLE [dbo].[tProjectTitleRollup] ADD  CONSTRAINT [DF_tProjectTitleRollup_EstCOGross]  DEFAULT ((0)) FOR [EstCOGross]
GO
