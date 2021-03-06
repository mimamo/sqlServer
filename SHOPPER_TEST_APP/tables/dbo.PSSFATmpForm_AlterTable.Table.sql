USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSFATmpForm_AlterTable]    Script Date: 12/21/2015 16:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFATmpForm_AlterTable](
	[AccessNbr] [char](4) NOT NULL,
	[AcquireDate] [smalldatetime] NOT NULL,
	[AssetDescr] [char](50) NOT NULL,
	[AssetID] [char](10) NOT NULL,
	[AssetSubID] [char](10) NOT NULL,
	[Bonus] [float] NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Depr] [float] NOT NULL,
	[Depr69thru75] [float] NOT NULL,
	[DeprAfter75] [float] NOT NULL,
	[DeprClass] [char](2) NOT NULL,
	[DeprFromPerNbr] [char](6) NOT NULL,
	[DeprMethod] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[Gain] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MidCOnv] [char](10) NOT NULL,
	[Part] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[SalesPrice] [float] NOT NULL,
	[Sect] [char](6) NOT NULL,
	[Sect179Amt] [float] NOT NULL,
	[SoldDate] [smalldatetime] NOT NULL,
	[UsefulLife] [int] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UserId] [char](47) NOT NULL,
	[Year] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [AcquireDate]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [AssetDescr]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [AssetID]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [AssetSubID]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Bonus]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Depr]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Depr69thru75]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [DeprAfter75]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [DeprClass]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [DeprFromPerNbr]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Gain]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [MidCOnv]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Part]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [SalesPrice]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [Sect]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [Sect179Amt]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [SoldDate]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0)) FOR [UsefulLife]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [UserId]
GO
ALTER TABLE [dbo].[PSSFATmpForm_AlterTable] ADD  DEFAULT ('') FOR [Year]
GO
