USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSLoanCharges_AlterTable]    Script Date: 12/21/2015 14:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLoanCharges_AlterTable](
	[ChargeAmt] [float] NOT NULL,
	[ChargeDueDate] [smalldatetime] NOT NULL,
	[ChargePerc] [float] NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CrSub] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSub] [char](24) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LLBatNbr] [char](10) NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[PmtNbr] [smallint] NOT NULL,
	[PmtTypeCode] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargeAmt]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [ChargeDueDate]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargePerc]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [CrSub]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [DrSub]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [LLBatNbr]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [PmtTypeCode]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLoanCharges_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
