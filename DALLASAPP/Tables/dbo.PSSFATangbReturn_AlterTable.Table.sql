USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSFATangbReturn_AlterTable]    Script Date: 12/21/2015 13:44:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATangbReturn_AlterTable](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[SetupId] [char](2) NOT NULL,
	[TangbAddr1] [char](100) NOT NULL,
	[TangbAddr2] [char](100) NOT NULL,
	[TangbAgricult] [smallint] NOT NULL,
	[TangbAppraiser] [char](100) NOT NULL,
	[TangbBusType] [char](30) NOT NULL,
	[TangbCity] [char](30) NOT NULL,
	[TangbCorpName] [char](100) NOT NULL,
	[TangbFiscYrFr] [smallint] NOT NULL,
	[TangbFiscYrTo] [smallint] NOT NULL,
	[TangbLease] [smallint] NOT NULL,
	[TangbManEmail] [char](100) NOT NULL,
	[TangbManFax] [char](10) NOT NULL,
	[TangbManName] [char](100) NOT NULL,
	[TangbManPhone] [char](10) NOT NULL,
	[TangbManufact] [smallint] NOT NULL,
	[TangbOther] [smallint] NOT NULL,
	[TangbPAAddr1] [char](100) NOT NULL,
	[TangbPAAddr2] [char](100) NOT NULL,
	[TangbPACity] [char](30) NOT NULL,
	[TangbPACounty] [char](30) NOT NULL,
	[TangbPADept] [char](100) NOT NULL,
	[TangbPAName] [char](100) NOT NULL,
	[TangbPAState] [char](2) NOT NULL,
	[TangbPAZip] [char](10) NOT NULL,
	[TangbProfes] [smallint] NOT NULL,
	[TangbRetail] [smallint] NOT NULL,
	[TangbService] [smallint] NOT NULL,
	[TangbSqFt] [char](60) NOT NULL,
	[TangbStartDate] [smalldatetime] NOT NULL,
	[TangbState] [char](2) NOT NULL,
	[TangbSvcType] [char](30) NOT NULL,
	[TangbWholesale] [smallint] NOT NULL,
	[TangbZip] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [SetupId]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbAddr1]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbAddr2]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbAgricult]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbAppraiser]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbBusType]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbCity]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbCorpName]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbFiscYrFr]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbFiscYrTo]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbLease]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbManEmail]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbManFax]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbManName]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbManPhone]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbManufact]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbOther]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPAAddr1]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPAAddr2]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPACity]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPACounty]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPADept]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPAName]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPAState]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbPAZip]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbProfes]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbRetail]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbService]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbSqFt]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [TangbStartDate]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbState]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbSvcType]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0)) FOR [TangbWholesale]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [TangbZip]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFATangbReturn_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
