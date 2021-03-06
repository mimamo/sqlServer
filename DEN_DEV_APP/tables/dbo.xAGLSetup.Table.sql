USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xAGLSetup]    Script Date: 12/21/2015 14:05:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAGLSetup](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[Addr1] [varchar](30) NULL,
	[Addr2] [varchar](30) NULL,
	[AllowPostOpt] [varchar](1) NULL,
	[AutoBatRpt] [smallint] NULL,
	[AutoPost] [varchar](1) NULL,
	[AutoRef] [varchar](1) NULL,
	[AutoRevOpt] [varchar](1) NULL,
	[BaseCuryId] [varchar](4) NULL,
	[BegFiscalYr] [smallint] NULL,
	[BudgetLedgerID] [varchar](10) NULL,
	[BudgetSpreadDir] [varchar](50) NULL,
	[BudgetSpreadType] [varchar](1) NULL,
	[BudgetSubSeg00] [varchar](1) NULL,
	[BudgetSubSeg01] [varchar](1) NULL,
	[BudgetSubSeg02] [varchar](1) NULL,
	[BudgetSubSeg03] [varchar](1) NULL,
	[BudgetSubSeg04] [varchar](1) NULL,
	[BudgetSubSeg05] [varchar](1) NULL,
	[BudgetSubSeg06] [varchar](1) NULL,
	[BudgetSubSeg07] [varchar](1) NULL,
	[BudgetYear] [varchar](4) NULL,
	[Central_Cash_Cntl] [smallint] NULL,
	[ChngNbrPer] [smallint] NULL,
	[City] [varchar](30) NULL,
	[COAOrder] [varchar](1) NULL,
	[Country] [varchar](3) NULL,
	[CpnyId] [varchar](10) NULL,
	[CpnyName] [varchar](30) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[EditInit] [smallint] NULL,
	[EmplId] [varchar](12) NULL,
	[Fax] [varchar](30) NULL,
	[FiscalPerEnd00] [varchar](4) NULL,
	[FiscalPerEnd01] [varchar](4) NULL,
	[FiscalPerEnd02] [varchar](4) NULL,
	[FiscalPerEnd03] [varchar](4) NULL,
	[FiscalPerEnd04] [varchar](4) NULL,
	[FiscalPerEnd05] [varchar](4) NULL,
	[FiscalPerEnd06] [varchar](4) NULL,
	[FiscalPerEnd07] [varchar](4) NULL,
	[FiscalPerEnd08] [varchar](4) NULL,
	[FiscalPerEnd09] [varchar](4) NULL,
	[FiscalPerEnd10] [varchar](4) NULL,
	[FiscalPerEnd11] [varchar](4) NULL,
	[FiscalPerEnd12] [varchar](4) NULL,
	[Init] [smallint] NULL,
	[LastBatNbr] [varchar](10) NULL,
	[LastClosePerNbr] [varchar](6) NULL,
	[LedgerID] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[Master_Fed_ID] [int] NULL,
	[MCActive] [smallint] NULL,
	[MCuryBatRpt] [smallint] NULL,
	[Mult_Cpny_Db] [smallint] NULL,
	[NbrPer] [smallint] NULL,
	[NoteID] [int] NULL,
	[PerNbr] [varchar](6) NULL,
	[PerRetHist] [smallint] NULL,
	[PerRetModTran] [smallint] NULL,
	[PerRetTran] [smallint] NULL,
	[Phone] [varchar](30) NULL,
	[PriorYearPost] [smallint] NULL,
	[PSC] [varchar](4) NULL,
	[RetEarnAcct] [varchar](10) NULL,
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
	[SetupId] [varchar](2) NULL,
	[State] [varchar](3) NULL,
	[SubAcctSeg] [varchar](2) NULL,
	[SummPostYCntr] [int] NULL,
	[UpdateCA] [smallint] NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[ValidateAcctSub] [smallint] NULL,
	[ValidateAtPosting] [smallint] NULL,
	[YtdNetIncAcct] [varchar](10) NULL,
	[ZCount] [smallint] NULL,
	[Zip] [varchar](10) NULL,
	[Zp] [varchar](30) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAGLSetup] ADD  CONSTRAINT [DF_xAGLSetup_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
