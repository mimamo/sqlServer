USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFADeprPeriods]    Script Date: 12/21/2015 13:35:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFADeprPeriods](
	[BegDate] [smalldatetime] NOT NULL,
	[BegFiscalYr] [smallint] NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[FiscalPerEnd00] [char](4) NOT NULL,
	[FiscalPerEnd01] [char](4) NOT NULL,
	[FiscalPerEnd02] [char](4) NOT NULL,
	[FiscalPerEnd03] [char](4) NOT NULL,
	[FiscalPerEnd04] [char](4) NOT NULL,
	[FiscalPerEnd05] [char](4) NOT NULL,
	[FiscalPerEnd06] [char](4) NOT NULL,
	[FiscalPerEnd07] [char](4) NOT NULL,
	[FiscalPerEnd08] [char](4) NOT NULL,
	[FiscalPerEnd09] [char](4) NOT NULL,
	[FiscalPerEnd10] [char](4) NOT NULL,
	[FiscalPerEnd11] [char](4) NOT NULL,
	[FiscalPerEnd12] [char](4) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NbrPer] [smallint] NOT NULL,
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
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('01/01/1900') FOR [BegDate]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ((0)) FOR [BegFiscalYr]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd00]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd01]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd02]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd03]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd04]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd05]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd06]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd07]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd08]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd09]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd10]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd11]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscalPerEnd12]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [FiscYr]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ((0)) FOR [NbrPer]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFADeprPeriods] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
