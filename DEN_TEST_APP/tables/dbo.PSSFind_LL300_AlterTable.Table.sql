USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSFind_LL300_AlterTable]    Script Date: 12/21/2015 14:10:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFind_LL300_AlterTable](
	[AccessNbr] [smallint] NOT NULL,
	[AcctNo] [char](20) NOT NULL,
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[City] [char](30) NOT NULL,
	[CpnyName] [char](60) NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CreditType] [char](1) NOT NULL,
	[CrSub] [char](24) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[Custom0] [char](20) NOT NULL,
	[Custom1] [char](20) NOT NULL,
	[Custom10] [float] NOT NULL,
	[Custom11] [smalldatetime] NOT NULL,
	[Custom12] [smalldatetime] NOT NULL,
	[Custom13] [smalldatetime] NOT NULL,
	[Custom14] [smalldatetime] NOT NULL,
	[Custom15] [char](100) NOT NULL,
	[Custom2] [char](20) NOT NULL,
	[Custom3] [char](60) NOT NULL,
	[Custom4] [char](60) NOT NULL,
	[Custom5] [char](10) NOT NULL,
	[Custom6] [char](10) NOT NULL,
	[Custom7] [float] NOT NULL,
	[Custom8] [float] NOT NULL,
	[Custom9] [float] NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSub] [char](24) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LoanTypeCode] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[Phone] [char](10) NOT NULL,
	[PmtNbr] [smallint] NOT NULL,
	[PmtTypeCode] [char](10) NOT NULL,
	[Region] [char](10) NOT NULL,
	[Relation] [char](6) NOT NULL,
	[Sector] [char](10) NOT NULL,
	[SSN] [char](9) NOT NULL,
	[State] [char](2) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxId] [char](9) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[ZipCode] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [AcctNo]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [CpnyName]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [CreditType]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [CrSub]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [CustID]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom0]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom1]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0.00)) FOR [Custom10]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Custom11]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Custom12]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Custom13]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Custom14]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom15]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom2]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom3]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom4]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom5]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Custom6]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0.00)) FOR [Custom7]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0.00)) FOR [Custom8]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0.00)) FOR [Custom9]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [DrSub]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [GLBatNbr]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [LoanTypeCode]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [PmtTypeCode]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Region]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Relation]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Sector]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [SSN]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [TaxId]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSFind_LL300_AlterTable] ADD  DEFAULT ('') FOR [ZipCode]
GO
