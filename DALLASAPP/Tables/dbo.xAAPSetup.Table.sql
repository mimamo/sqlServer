USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xAAPSetup]    Script Date: 12/21/2015 13:44:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAAPSetup](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[A1099byCpnyID] [smallint] NULL,
	[APAcct] [varchar](10) NULL,
	[APSub] [varchar](24) NULL,
	[AutoBatRpt] [smallint] NULL,
	[AutoRef] [smallint] NULL,
	[BkupWthldPct] [float] NULL,
	[ChkAcct] [varchar](10) NULL,
	[ChkSub] [varchar](24) NULL,
	[ClassID] [varchar](10) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[Curr1099Yr] [varchar](4) NULL,
	[CurrPerNbr] [varchar](6) NULL,
	[CY1099Stat] [varchar](1) NULL,
	[DecPlPrcCst] [smallint] NULL,
	[DecPlQty] [smallint] NULL,
	[DfltPPVAccount] [varchar](10) NULL,
	[DfltPPVSub] [varchar](24) NULL,
	[DirectDeposit] [varchar](1) NULL,
	[DiscTknAcct] [varchar](10) NULL,
	[DiscTknSub] [varchar](24) NULL,
	[DupInvcChk] [smallint] NULL,
	[ExpAcct] [varchar](10) NULL,
	[ExpSub] [varchar](24) NULL,
	[GLPostOpt] [varchar](1) NULL,
	[Init] [smallint] NULL,
	[LastBatNbr] [varchar](10) NULL,
	[LastECheckNum] [varchar](10) NULL,
	[LastRefNbr] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[MCuryBatRpt] [smallint] NULL,
	[Next1099Yr] [varchar](4) NULL,
	[NoteID] [int] NULL,
	[NY1099Stat] [varchar](1) NULL,
	[PastDue00] [smallint] NULL,
	[PastDue01] [smallint] NULL,
	[PastDue02] [smallint] NULL,
	[PerDupChk] [smallint] NULL,
	[PerNbr] [varchar](6) NULL,
	[PerRetHist] [smallint] NULL,
	[PerRetTran] [smallint] NULL,
	[PMAvail] [smallint] NULL,
	[PPayAcct] [varchar](10) NULL,
	[PPaySub] [varchar](24) NULL,
	[PPVAcct] [varchar](10) NULL,
	[PPVSub] [varchar](24) NULL,
	[Req_PO_for_PP] [smallint] NULL,
	[RetChkRcncl] [smallint] NULL,
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
	[SlsTax] [smallint] NULL,
	[SlsTaxDflt] [varchar](1) NULL,
	[Terms] [varchar](2) NULL,
	[TranDescDflt] [varchar](1) NULL,
	[UntlDue00] [smallint] NULL,
	[UntlDue01] [smallint] NULL,
	[UntlDue02] [smallint] NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[Vend1099Lmt] [float] NULL,
	[VendViewDflt] [varchar](1) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAAPSetup] ADD  CONSTRAINT [DF_xAAPSetup_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
