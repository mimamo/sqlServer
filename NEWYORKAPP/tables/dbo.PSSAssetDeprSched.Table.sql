USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PSSAssetDeprSched]    Script Date: 12/21/2015 16:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSAssetDeprSched](
	[AccumDeprBonus] [float] NOT NULL,
	[AccumDeprReg] [float] NOT NULL,
	[AccumDeprTax179] [float] NOT NULL,
	[AccumDeprTot] [float] NOT NULL,
	[AccumDeprYTD] [float] NOT NULL,
	[AssetID] [char](10) NOT NULL,
	[AssetSubID] [char](10) NOT NULL,
	[AvgConv] [char](1) NOT NULL,
	[Basis] [float] NOT NULL,
	[BookCode] [char](10) NOT NULL,
	[BookDeprFrom] [char](6) NOT NULL,
	[BookSeq] [char](10) NOT NULL,
	[Cost] [float] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeprBonus] [float] NOT NULL,
	[DeprFromPerNbr] [char](6) NOT NULL,
	[DeprReg] [float] NOT NULL,
	[DeprTax179] [float] NOT NULL,
	[DeprToPerNbr] [char](6) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[ForecastDeprBonus] [float] NOT NULL,
	[ForecastDeprReg] [float] NOT NULL,
	[ForecastDeprTax179] [float] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lock] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MethodBonus] [char](20) NOT NULL,
	[MethodBonusAmt] [float] NOT NULL,
	[MethodReg] [char](20) NOT NULL,
	[MethodTax179] [char](20) NOT NULL,
	[MethodTax179Amt] [float] NOT NULL,
	[MMDays] [smallint] NOT NULL,
	[MMType] [char](1) NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[SalvageValue] [float] NOT NULL,
	[SchedSeq] [char](10) NOT NULL,
	[TknDeprBonus] [float] NOT NULL,
	[TknDeprReg] [float] NOT NULL,
	[TknDeprTax179] [float] NOT NULL,
	[UsefulLife] [float] NOT NULL,
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
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [AccumDeprBonus]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [AccumDeprReg]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [AccumDeprTax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [AccumDeprTot]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [AccumDeprYTD]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [AssetID]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [AssetSubID]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [AvgConv]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [Basis]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [BookCode]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [BookDeprFrom]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [BookSeq]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [Cost]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [DeprBonus]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [DeprFromPerNbr]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [DeprReg]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [DeprTax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [DeprToPerNbr]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [FiscYr]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [ForecastDeprBonus]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [ForecastDeprReg]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [ForecastDeprTax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [Lock]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [MethodBonus]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [MethodBonusAmt]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [MethodReg]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [MethodTax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [MethodTax179Amt]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0)) FOR [MMDays]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [MMType]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [PerPost]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [SalvageValue]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [SchedSeq]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [TknDeprBonus]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [TknDeprReg]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [TknDeprTax179]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [UsefulLife]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSAssetDeprSched] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
