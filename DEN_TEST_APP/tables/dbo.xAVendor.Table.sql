USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xAVendor]    Script Date: 12/21/2015 14:10:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAVendor](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[Addr1] [varchar](60) NULL,
	[Addr2] [varchar](60) NULL,
	[APAcct] [varchar](10) NULL,
	[APSub] [varchar](24) NULL,
	[Attn] [varchar](30) NULL,
	[BkupWthld] [smallint] NULL,
	[City] [varchar](30) NULL,
	[ClassID] [varchar](10) NULL,
	[ContTwc1099] [smallint] NULL,
	[Country] [varchar](3) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[Curr1099Yr] [varchar](4) NULL,
	[CuryId] [varchar](4) NULL,
	[CuryRateType] [varchar](6) NULL,
	[DfltBox] [varchar](2) NULL,
	[DfltOrdFromId] [varchar](10) NULL,
	[DfltPurchaseType] [varchar](2) NULL,
	[DirectDeposit] [varchar](1) NULL,
	[DocPublishingFlag] [varchar](1) NULL,
	[EMailAddr] [varchar](80) NULL,
	[ExpAcct] [varchar](10) NULL,
	[ExpSub] [varchar](24) NULL,
	[Fax] [varchar](30) NULL,
	[LCCode] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[MultiChk] [smallint] NULL,
	[Name] [varchar](60) NULL,
	[Next1099Yr] [varchar](4) NULL,
	[NoteID] [int] NULL,
	[PayDateDflt] [varchar](1) NULL,
	[PerNbr] [varchar](6) NULL,
	[Phone] [varchar](30) NULL,
	[PmtMethod] [varchar](1) NULL,
	[PPayAcct] [varchar](10) NULL,
	[PPaySub] [varchar](24) NULL,
	[RcptPctAct] [varchar](1) NULL,
	[RcptPctMax] [float] NULL,
	[RcptPctMin] [float] NULL,
	[RemitAddr1] [varchar](60) NULL,
	[RemitAddr2] [varchar](60) NULL,
	[RemitAttn] [varchar](30) NULL,
	[RemitCity] [varchar](30) NULL,
	[RemitCountry] [varchar](3) NULL,
	[RemitFax] [varchar](30) NULL,
	[RemitName] [varchar](60) NULL,
	[RemitPhone] [varchar](30) NULL,
	[RemitSalut] [varchar](30) NULL,
	[RemitState] [varchar](3) NULL,
	[RemitZip] [varchar](10) NULL,
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
	[State] [varchar](3) NULL,
	[Status] [varchar](1) NULL,
	[TaxDflt] [varchar](1) NULL,
	[TaxId00] [varchar](10) NULL,
	[TaxId01] [varchar](10) NULL,
	[TaxId02] [varchar](10) NULL,
	[TaxId03] [varchar](10) NULL,
	[TaxLocId] [varchar](15) NULL,
	[TaxPost] [varchar](1) NULL,
	[TaxRegNbr] [varchar](15) NULL,
	[Terms] [varchar](2) NULL,
	[TIN] [varchar](11) NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [varchar](10) NULL,
	[User6] [varchar](10) NULL,
	[User7] [smalldatetime] NULL,
	[User8] [smalldatetime] NULL,
	[Vend1099] [smallint] NULL,
	[Vend1099AddrType] [varchar](1) NULL,
	[VendId] [varchar](15) NULL,
	[Zip] [varchar](10) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAVendor] ADD  CONSTRAINT [DF_xAVendor_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
