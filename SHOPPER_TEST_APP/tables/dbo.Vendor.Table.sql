USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 12/21/2015 16:06:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Vendor](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[APAcct] [char](10) NOT NULL,
	[APSub] [char](24) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[BkupWthld] [smallint] NOT NULL,
	[City] [char](30) NOT NULL,
	[ClassID] [char](10) NOT NULL,
	[ContTwc1099] [smallint] NOT NULL,
	[Country] [char](3) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Curr1099Yr] [char](4) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[DfltBox] [char](2) NOT NULL,
	[DfltOrdFromId] [char](10) NOT NULL,
	[DfltPurchaseType] [char](2) NOT NULL,
	[DirectDeposit] [char](1) NOT NULL,
	[DocPublishingFlag] [char](1) NOT NULL,
	[EMailAddr] [char](80) NOT NULL,
	[ExpAcct] [char](10) NOT NULL,
	[ExpSub] [char](24) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[LCCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MultiChk] [smallint] NOT NULL,
	[Name] [char](60) NOT NULL,
	[Next1099Yr] [char](4) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PayDateDflt] [char](1) NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[Phone] [char](30) NOT NULL,
	[PmtMethod] [char](1) NOT NULL,
	[PPayAcct] [char](10) NOT NULL,
	[PPaySub] [char](24) NOT NULL,
	[RcptPctAct] [char](1) NOT NULL,
	[RcptPctMax] [float] NOT NULL,
	[RcptPctMin] [float] NOT NULL,
	[RemitAddr1] [char](60) NOT NULL,
	[RemitAddr2] [char](60) NOT NULL,
	[RemitAttn] [char](30) NOT NULL,
	[RemitCity] [char](30) NOT NULL,
	[RemitCountry] [char](3) NOT NULL,
	[RemitFax] [char](30) NOT NULL,
	[RemitName] [char](60) NOT NULL,
	[RemitPhone] [char](30) NOT NULL,
	[RemitSalut] [char](30) NOT NULL,
	[RemitState] [char](3) NOT NULL,
	[RemitZip] [char](10) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[Salut] [char](30) NOT NULL,
	[State] [char](3) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaxDflt] [char](1) NOT NULL,
	[TaxId00] [char](10) NOT NULL,
	[TaxId01] [char](10) NOT NULL,
	[TaxId02] [char](10) NOT NULL,
	[TaxId03] [char](10) NOT NULL,
	[TaxLocId] [char](15) NOT NULL,
	[TaxPost] [char](1) NOT NULL,
	[TaxRegNbr] [char](15) NOT NULL,
	[Terms] [char](2) NOT NULL,
	[TIN] [char](11) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Vend1099] [smallint] NOT NULL,
	[Vend1099AddrType] [char](1) NOT NULL,
	[VendId] [char](15) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Vendor0] PRIMARY KEY CLUSTERED 
(
	[VendId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Vendor] ADD  DEFAULT ('Y') FOR [DocPublishingFlag]
GO
ALTER TABLE [dbo].[Vendor] ADD  DEFAULT (' ') FOR [LCCode]
GO
