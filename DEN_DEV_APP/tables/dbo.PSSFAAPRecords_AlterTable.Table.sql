USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFAAPRecords_AlterTable]    Script Date: 12/21/2015 14:05:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAAPRecords_AlterTable](
	[Acct] [char](10) NOT NULL,
	[ActionCode] [char](1) NOT NULL,
	[APLineId] [int] NOT NULL,
	[APLineNbr] [smallint] NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[POLineRef] [char](10) NOT NULL,
	[PONbr] [char](10) NOT NULL,
	[PORcptBatNbr] [char](10) NOT NULL,
	[PORcptNbr] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[RecordID] [int] NOT NULL,
	[RefNbr] [char](20) NOT NULL,
	[Sub] [char](24) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranAmt] [float] NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDesc] [char](60) NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [Acct]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [ActionCode]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0)) FOR [APLineId]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0)) FOR [APLineNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0.00)) FOR [CuryTranAmt]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [Module]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [POLineRef]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [PONbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [PORcptBatNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [PORcptNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [ProjectID]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0.00)) FOR [Qty]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0)) FOR [RecordID]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [RefNbr]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [Sub]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [TaskID]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0.00)) FOR [TranAmt]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [TranDesc]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFAAPRecords_AlterTable] ADD  DEFAULT ('') FOR [VendId]
GO
