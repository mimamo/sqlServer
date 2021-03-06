USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFABonusDet_AlterTable]    Script Date: 12/21/2015 13:35:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFABonusDet_AlterTable](
	[BonusDeprCd] [char](10) NOT NULL,
	[BonusPercent] [float] NOT NULL,
	[Crtd_Datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[LineId] [smallint] NOT NULL,
	[Lupd_Datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MaxAmt] [float] NOT NULL,
	[NoteId] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('') FOR [BonusDeprCd]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ((0.00)) FOR [BonusPercent]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_Datetime]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [EndDate]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_Datetime]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ((0.00)) FOR [MaxAmt]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSFABonusDet_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [StartDate]
GO
