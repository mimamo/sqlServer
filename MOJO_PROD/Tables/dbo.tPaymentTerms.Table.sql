USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPaymentTerms]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPaymentTerms](
	[PaymentTermsKey] [int] IDENTITY(1,1) NOT NULL,
	[TermsDescription] [varchar](100) NOT NULL,
	[CompanyKey] [int] NULL,
	[DueDays] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [tPaymentTerms_PK] PRIMARY KEY CLUSTERED 
(
	[PaymentTermsKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPaymentTerms] ADD  CONSTRAINT [DF_tPaymentTerms_DueDays]  DEFAULT ((0)) FOR [DueDays]
GO
ALTER TABLE [dbo].[tPaymentTerms] ADD  CONSTRAINT [DF_tPaymentTerms_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
