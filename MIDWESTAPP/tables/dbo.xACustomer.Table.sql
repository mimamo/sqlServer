USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xACustomer]    Script Date: 12/21/2015 15:54:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xACustomer](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[AccrRevAcct] [varchar](10) NULL,
	[AccrRevSub] [varchar](24) NULL,
	[AcctNbr] [varchar](30) NULL,
	[Addr1] [varchar](60) NULL,
	[Addr2] [varchar](60) NULL,
	[AgentID] [varchar](10) NULL,
	[ApplFinChrg] [smallint] NULL,
	[ArAcct] [varchar](10) NULL,
	[ArSub] [varchar](24) NULL,
	[Attn] [varchar](30) NULL,
	[AutoApply] [smallint] NULL,
	[BankID] [varchar](10) NULL,
	[BillAddr1] [varchar](60) NULL,
	[BillAddr2] [varchar](60) NULL,
	[BillAttn] [varchar](30) NULL,
	[BillCity] [varchar](30) NULL,
	[BillCountry] [varchar](3) NULL,
	[BillFax] [varchar](30) NULL,
	[BillName] [varchar](60) NULL,
	[BillPhone] [varchar](30) NULL,
	[BillSalut] [varchar](30) NULL,
	[BillState] [varchar](3) NULL,
	[BillThruProject] [smallint] NULL,
	[BillZip] [varchar](10) NULL,
	[CardExpDate] [smalldatetime] NULL,
	[CardHldrName] [varchar](60) NULL,
	[CardNbr] [varchar](20) NULL,
	[CardType] [varchar](1) NULL,
	[City] [varchar](30) NULL,
	[ClassId] [varchar](6) NULL,
	[ConsolInv] [smallint] NULL,
	[Country] [varchar](3) NULL,
	[CrLmt] [float] NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[CuryId] [varchar](4) NULL,
	[CuryPrcLvlRtTp] [varchar](6) NULL,
	[CuryRateType] [varchar](6) NULL,
	[CustFillPriority] [smallint] NULL,
	[CustId] [varchar](15) NULL,
	[DfltShipToId] [varchar](10) NULL,
	[DocPublishingFlag] [varchar](1) NULL,
	[DunMsg] [smallint] NULL,
	[EMailAddr] [varchar](80) NULL,
	[Fax] [varchar](30) NULL,
	[InvtSubst] [smallint] NULL,
	[LanguageID] [varchar](4) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[Name] [varchar](60) NULL,
	[NoteId] [int] NULL,
	[OneDraft] [smallint] NULL,
	[PerNbr] [varchar](6) NULL,
	[Phone] [varchar](30) NULL,
	[PmtMethod] [varchar](1) NULL,
	[PrcLvlId] [varchar](10) NULL,
	[PrePayAcct] [varchar](10) NULL,
	[PrePaySub] [varchar](24) NULL,
	[PriceClassID] [varchar](6) NULL,
	[PrtMCStmt] [smallint] NULL,
	[PrtStmt] [smallint] NULL,
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
	[Salut] [varchar](30) NULL,
	[SetupDate] [smalldatetime] NULL,
	[ShipCmplt] [smallint] NULL,
	[ShipPctAct] [varchar](1) NULL,
	[ShipPctMax] [float] NULL,
	[SICCode1] [varchar](4) NULL,
	[SICCode2] [varchar](4) NULL,
	[SingleInvoice] [smallint] NULL,
	[SlsAcct] [varchar](10) NULL,
	[SlsperId] [varchar](10) NULL,
	[SlsSub] [varchar](24) NULL,
	[State] [varchar](3) NULL,
	[Status] [varchar](1) NULL,
	[StmtCycleId] [varchar](2) NULL,
	[StmtType] [varchar](1) NULL,
	[TaxDflt] [varchar](1) NULL,
	[TaxExemptNbr] [varchar](15) NULL,
	[TaxID00] [varchar](10) NULL,
	[TaxID01] [varchar](10) NULL,
	[TaxID02] [varchar](10) NULL,
	[TaxID03] [varchar](10) NULL,
	[TaxLocId] [varchar](15) NULL,
	[TaxRegNbr] [varchar](15) NULL,
	[Terms] [varchar](2) NULL,
	[Territory] [varchar](10) NULL,
	[TradeDisc] [float] NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[Zip] [varchar](10) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xACustomer] ADD  CONSTRAINT [DF_xACustomer_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
