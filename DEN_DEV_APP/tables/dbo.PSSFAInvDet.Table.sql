USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFAInvDet]    Script Date: 12/21/2015 14:05:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFAInvDet](
	[Amt] [float] NOT NULL,
	[ARBatNbr] [char](10) NOT NULL,
	[ARLineId] [int] NOT NULL,
	[ARLineNbr] [smallint] NOT NULL,
	[ARLineRef] [char](5) NOT NULL,
	[ARRefNbr] [char](10) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[BaseCuryID] [char](4) NOT NULL,
	[BatNbr] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CrAcct] [char](10) NOT NULL,
	[CrSubAcct] [char](24) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryAmt] [float] NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[DiscDate] [smalldatetime] NOT NULL,
	[DrAcct] [char](10) NOT NULL,
	[DrSubAcct] [char](24) NOT NULL,
	[DueDate] [smalldatetime] NOT NULL,
	[LineID] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectId] [char](30) NOT NULL,
	[RentDays] [float] NOT NULL,
	[TaskId] [char](32) NOT NULL,
	[Terms] [char](2) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[TranDescr] [char](60) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0.00)) FOR [Amt]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [ARBatNbr]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0)) FOR [ARLineId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0)) FOR [ARLineNbr]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [ARLineRef]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [ARRefNbr]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [BaseCuryID]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [BatNbr]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CrAcct]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CrSubAcct]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0.00)) FOR [CuryAmt]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('01/01/1900') FOR [CuryEffDate]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CuryID]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CuryMultDiv]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0.00)) FOR [CuryRate]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [CustId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('01/01/1900') FOR [DiscDate]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [DrAcct]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [DrSubAcct]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('01/01/1900') FOR [DueDate]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0)) FOR [LineID]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [ProjectId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ((0.00)) FOR [RentDays]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [TaskId]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [Terms]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('01/01/1900') FOR [TranDate]
GO
ALTER TABLE [dbo].[PSSFAInvDet] ADD  DEFAULT ('') FOR [TranDescr]
GO
