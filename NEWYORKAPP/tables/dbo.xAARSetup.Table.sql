USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xAARSetup]    Script Date: 12/21/2015 16:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAARSetup](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[AnnFinChrg] [float] NULL,
	[ArAcct] [varchar](10) NULL,
	[ArSub] [varchar](24) NULL,
	[AutoApplyWO] [smallint] NULL,
	[AutoBatRpt] [smallint] NULL,
	[AutoNSF] [smallint] NULL,
	[AutoRef] [smallint] NULL,
	[ChkAcct] [varchar](10) NULL,
	[ChkSub] [varchar](24) NULL,
	[ChrgMin] [smallint] NULL,
	[CompdFinChrg] [smallint] NULL,
	[CreditHoldType] [varchar](1) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[CurrPerNbr] [varchar](6) NULL,
	[CustViewDflt] [varchar](1) NULL,
	[DaysPastDue] [smallint] NULL,
	[DecPlPrcCst] [smallint] NULL,
	[DecPlQty] [smallint] NULL,
	[DfltAutoApply] [smallint] NULL,
	[DfltClass] [varchar](6) NULL,
	[DfltNSFAcct] [varchar](10) NULL,
	[DfltNSFSub] [varchar](24) NULL,
	[DfltSBWOAcct] [varchar](10) NULL,
	[DfltSBWOSub] [varchar](24) NULL,
	[DfltSCWOAcct] [varchar](10) NULL,
	[DfltSCWOSub] [varchar](24) NULL,
	[DfltStmtCycle] [varchar](2) NULL,
	[DfltStmtType] [varchar](1) NULL,
	[DiscAcct] [varchar](10) NULL,
	[DiscSub] [varchar](24) NULL,
	[DiscCpnyFromInvc] [smallint] NULL,
	[FinChrgAcct] [varchar](10) NULL,
	[FinChrgFirst] [varchar](1) NULL,
	[FinChrgSub] [varchar](24) NULL,
	[GLPostOpt] [varchar](1) NULL,
	[IncAcct] [varchar](10) NULL,
	[IncSub] [varchar](24) NULL,
	[Init] [smallint] NULL,
	[LastBatNbr] [varchar](10) NULL,
	[LastCrMemoNbr] [varchar](10) NULL,
	[LastDrMemoNbr] [varchar](10) NULL,
	[LastFinChrgRefNbr] [varchar](10) NULL,
	[LastRefNbr] [varchar](10) NULL,
	[LastWORefNbr] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[MCuryBatRpt] [smallint] NULL,
	[MinFinChrg] [float] NULL,
	[Nbr0803Docs] [smallint] NULL,
	[NoteId] [int] NULL,
	[NSFChrg] [float] NULL,
	[OverLimitAmt] [float] NULL,
	[OverLimitType] [varchar](1) NULL,
	[PASortDflt] [varchar](1) NULL,
	[PerNbr] [varchar](6) NULL,
	[PerRetHist] [smallint] NULL,
	[PerRetStmtDtl] [smallint] NULL,
	[PerRetTran] [smallint] NULL,
	[PrePayAcct] [varchar](10) NULL,
	[PrePaySub] [varchar](24) NULL,
	[RetAllowAcct] [varchar](10) NULL,
	[RetAllowSub] [varchar](24) NULL,
	[RetAvgDay] [smallint] NULL,
	[RfndAcct] [varchar](10) NULL,
	[RfndSub] [varchar](24) NULL,
	[S4Future01] [varchar](30) NULL,
	[S4Future02] [varchar](30) NULL,
	[S4Future03] [float] NULL,
	[S4Future04] [float] NULL,
	[S4Future05] [float] NULL,
	[S4Future06] [float] NULL,
	[S4Future07] [smalldatetime] NULL,
	[S4Future08] [smalldatetime] NULL,
	[S4Future09] [int] NULL,
	[S4Future10] [int] NULL,
	[S4Future11] [varchar](10) NULL,
	[S4Future12] [varchar](10) NULL,
	[S4Future13] [varchar](10) NULL,
	[SBLimit] [float] NULL,
	[SetupId] [varchar](2) NULL,
	[SlsTax] [smallint] NULL,
	[SlsTaxDflt] [varchar](1) NULL,
	[TranDescDflt] [varchar](1) NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[WarningLvlLimit] [smallint] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAARSetup] ADD  CONSTRAINT [DF_xAARSetup_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
