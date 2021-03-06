USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[GLSetup]    Script Date: 12/21/2015 16:06:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GLSetup](
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[AllowPostOpt] [char](1) NOT NULL,
	[AutoBatRpt] [smallint] NOT NULL,
	[AutoPost] [char](1) NOT NULL,
	[AutoRef] [char](1) NOT NULL,
	[AutoRevOpt] [char](1) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[BegFiscalYr] [smallint] NOT NULL,
	[BudgetLedgerID] [char](10) NOT NULL,
	[BudgetSpreadDir] [char](50) NOT NULL,
	[BudgetSpreadType] [char](1) NOT NULL,
	[BudgetSubSeg00] [char](1) NOT NULL,
	[BudgetSubSeg01] [char](1) NOT NULL,
	[BudgetSubSeg02] [char](1) NOT NULL,
	[BudgetSubSeg03] [char](1) NOT NULL,
	[BudgetSubSeg04] [char](1) NOT NULL,
	[BudgetSubSeg05] [char](1) NOT NULL,
	[BudgetSubSeg06] [char](1) NOT NULL,
	[BudgetSubSeg07] [char](1) NOT NULL,
	[BudgetYear] [char](4) NOT NULL,
	[Central_Cash_Cntl] [smallint] NOT NULL,
	[ChngNbrPer] [smallint] NOT NULL,
	[City] [char](30) NOT NULL,
	[COAOrder] [char](1) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CpnyName] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EditInit] [smallint] NOT NULL,
	[EmplId] [char](12) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[FiscalPerEnd00] [char](4) NOT NULL,
	[FiscalPerEnd01] [char](4) NOT NULL,
	[FiscalPerEnd02] [char](4) NOT NULL,
	[FiscalPerEnd03] [char](4) NOT NULL,
	[FiscalPerEnd04] [char](4) NOT NULL,
	[FiscalPerEnd05] [char](4) NOT NULL,
	[FiscalPerEnd06] [char](4) NOT NULL,
	[FiscalPerEnd07] [char](4) NOT NULL,
	[FiscalPerEnd08] [char](4) NOT NULL,
	[FiscalPerEnd09] [char](4) NOT NULL,
	[FiscalPerEnd10] [char](4) NOT NULL,
	[FiscalPerEnd11] [char](4) NOT NULL,
	[FiscalPerEnd12] [char](4) NOT NULL,
	[Init] [smallint] NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LastClosePerNbr] [char](6) NOT NULL,
	[LedgerID] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Master_Fed_ID] [int] NOT NULL,
	[MCActive] [smallint] NOT NULL,
	[MCuryBatRpt] [smallint] NOT NULL,
	[Mult_Cpny_Db] [smallint] NOT NULL,
	[NbrPer] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PerRetHist] [smallint] NOT NULL,
	[PerRetModTran] [smallint] NOT NULL,
	[PerRetTran] [smallint] NOT NULL,
	[Phone] [char](30) NOT NULL,
	[PriorYearPost] [smallint] NOT NULL,
	[PSC] [char](4) NOT NULL,
	[RetEarnAcct] [char](10) NOT NULL,
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
	[SetupId] [char](2) NOT NULL,
	[State] [char](3) NOT NULL,
	[SubAcctSeg] [char](2) NOT NULL,
	[SummPostYCntr] [int] NOT NULL,
	[UpdateCA] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[ValidateAcctSub] [smallint] NOT NULL,
	[ValidateAtPosting] [smallint] NOT NULL,
	[YtdNetIncAcct] [char](10) NOT NULL,
	[ZCount] [smallint] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[Zp] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [GLSetup0] PRIMARY KEY CLUSTERED 
(
	[SetupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[GLSetup]  WITH CHECK ADD  CONSTRAINT [CK_GLSetup_AllowPostOpt] CHECK  (([AllowPostOpt]='A' OR [AllowPostOpt]='P'))
GO
ALTER TABLE [dbo].[GLSetup] CHECK CONSTRAINT [CK_GLSetup_AllowPostOpt]
GO
ALTER TABLE [dbo].[GLSetup]  WITH CHECK ADD  CONSTRAINT [CK_GLSetup_PriorYearPost] CHECK  (([PriorYearPost]=(0) OR [PriorYearPost]=(1)))
GO
ALTER TABLE [dbo].[GLSetup] CHECK CONSTRAINT [CK_GLSetup_PriorYearPost]
GO
ALTER TABLE [dbo].[GLSetup] ADD  DEFAULT ('A') FOR [AllowPostOpt]
GO
ALTER TABLE [dbo].[GLSetup] ADD  DEFAULT ((0)) FOR [PriorYearPost]
GO
