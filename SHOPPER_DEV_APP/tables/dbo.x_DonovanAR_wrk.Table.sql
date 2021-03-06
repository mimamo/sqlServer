USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[x_DonovanAR_wrk]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[x_DonovanAR_wrk](
	[SolProjectNbr] [varchar](16) NOT NULL,
	[MediaType] [varchar](1) NOT NULL,
	[InvoiceNumber] [varchar](10) NOT NULL,
	[InvoiceDate] [smalldatetime] NOT NULL,
	[GrossAmount] [float] NOT NULL,
	[NetAmount] [float] NOT NULL,
	[ValidProject] [bit] NOT NULL,
	[ValidMedia] [bit] NOT NULL,
	[ValidCustomer] [bit] NOT NULL,
	[ValidTerms] [bit] NOT NULL,
	[SolBatNbr] [varchar](10) NOT NULL,
	[ValidInvNbr] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_SolProjectNbr]  DEFAULT ('') FOR [SolProjectNbr]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_MediaType]  DEFAULT ('') FOR [MediaType]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_InvoiceNumber]  DEFAULT ('') FOR [InvoiceNumber]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_InvoiceDate]  DEFAULT ('') FOR [InvoiceDate]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_GrossAmount]  DEFAULT ((0)) FOR [GrossAmount]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_NetAmount]  DEFAULT ((0)) FOR [NetAmount]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_ValidProject]  DEFAULT ((0)) FOR [ValidProject]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_ValidMedia]  DEFAULT ((0)) FOR [ValidMedia]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_ValidCustomer]  DEFAULT ((0)) FOR [ValidCustomer]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_ValidTerms]  DEFAULT ((0)) FOR [ValidTerms]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_SolBatNbr]  DEFAULT ('') FOR [SolBatNbr]
GO
ALTER TABLE [dbo].[x_DonovanAR_wrk] ADD  CONSTRAINT [DF_x_DonovanAR_wrk_ValidInvNbr]  DEFAULT ((0)) FOR [ValidInvNbr]
GO
