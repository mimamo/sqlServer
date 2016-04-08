USE [StageDM]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table StageDM.dbo.Customer
*
*   Creator:	Michelle Morales     
*   Date:       03/21/2016  
*   
*
*   Notes:      select top 100 * from StageDM.dbo.Customer    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
if (select 1
	from information_schema.tables
	where table_name = 'Customer') < 1
	
CREATE TABLE [dbo].[Customer](
	[AccrRevAcct] [char](10) NOT NULL,
	[AccrRevSub] [char](24) NOT NULL,
	[AcctNbr] [char](30) NOT NULL,
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[AgentID] [char](10) NOT NULL,
	[ApplFinChrg] [smallint] NOT NULL,
	[ArAcct] [char](10) NOT NULL,
	[ArSub] [char](24) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[AutoApply] [smallint] NOT NULL,
	[BankID] [char](10) NOT NULL,
	[BillAddr1] [char](60) NOT NULL,
	[BillAddr2] [char](60) NOT NULL,
	[BillAttn] [char](30) NOT NULL,
	[BillCity] [char](30) NOT NULL,
	[BillCountry] [char](3) NOT NULL,
	[BillFax] [char](30) NOT NULL,
	[BillName] [char](60) NOT NULL,
	[BillPhone] [char](30) NOT NULL,
	[BillSalut] [char](30) NOT NULL,
	[BillState] [char](3) NOT NULL,
	[BillThruProject] [smallint] NOT NULL,
	[BillZip] [char](10) NOT NULL,
	[CardExpDate] [smalldatetime] NOT NULL,
	[CardHldrName] [char](60) NOT NULL,
	[CardNbr] [char](20) NOT NULL,
	[CardType] [char](1) NOT NULL,
	[City] [char](30) NOT NULL,
	[ClassId] [char](6) NOT NULL,
	[ConsolInv] [smallint] NOT NULL,
	[Country] [char](3) NOT NULL,
	[CrLmt] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryPrcLvlRtTp] [char](6) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CustFillPriority] [smallint] NOT NULL,
	[CustId] [char](15) NOT NULL,
	[DfltShipToId] [char](10) NOT NULL,
	[DocPublishingFlag] [char](1) NOT NULL,
	[DunMsg] [smallint] NOT NULL,
	[EMailAddr] [char](80) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[InvtSubst] [smallint] NOT NULL,
	[LanguageID] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteId] [int] NOT NULL,
	[OneDraft] [smallint] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[Phone] [char](30) NOT NULL,
	[PmtMethod] [char](1) NOT NULL,
	[PrcLvlId] [char](10) NOT NULL,
	[PrePayAcct] [char](10) NOT NULL,
	[PrePaySub] [char](24) NOT NULL,
	[PriceClassID] [char](6) NOT NULL,
	[PrtMCStmt] [smallint] NOT NULL,
	[PrtStmt] [smallint] NOT NULL,
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
	[SetupDate] [smalldatetime] NOT NULL,
	[ShipCmplt] [smallint] NOT NULL,
	[ShipPctAct] [char](1) NOT NULL,
	[ShipPctMax] [float] NOT NULL,
	[SICCode1] [char](4) NOT NULL,
	[SICCode2] [char](4) NOT NULL,
	[SingleInvoice] [smallint] NOT NULL,
	[SlsAcct] [char](10) NOT NULL,
	[SlsperId] [char](10) NOT NULL,
	[SlsSub] [char](24) NOT NULL,
	[State] [char](3) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StmtCycleId] [char](2) NOT NULL,
	[StmtType] [char](1) NOT NULL,
	[TaxDflt] [char](1) NOT NULL,
	[TaxExemptNbr] [char](15) NOT NULL,
	[TaxID00] [char](10) NOT NULL,
	[TaxID01] [char](10) NOT NULL,
	[TaxID02] [char](10) NOT NULL,
	[TaxID03] [char](10) NOT NULL,
	[TaxLocId] [char](15) NOT NULL,
	[TaxRegNbr] [char](15) NOT NULL,
	[Terms] [char](2) NOT NULL,
	[Territory] [char](10) NOT NULL,
	[TradeDisc] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
	[Company] varchar(40),
 CONSTRAINT [Customer0] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	company
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

---------------------------------------------
-- modifications
---------------------------------------------
/*
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [AccrRevAcct]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [AccrRevSub]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [AcctNbr]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Addr1]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Addr2]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [AgentID]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [ApplFinChrg]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [ArAcct]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [ArSub]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Attn]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [AutoApply]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BankID]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillAddr1]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillAddr2]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillAttn]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillCity]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillCountry]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillFax]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillName]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillPhone]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillSalut]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillState]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [BillThruProject]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [BillZip]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [CardExpDate]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CardHldrName]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CardNbr]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CardType]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [City]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [ClassId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [ConsolInv]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Country]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [CrLmt]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CuryId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CuryPrcLvlRtTp]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [CustFillPriority]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [CustId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [DfltShipToId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('Y') FOR [DocPublishingFlag]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [DunMsg]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [EMailAddr]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [InvtSubst]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [LanguageID]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Name]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [OneDraft]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [PmtMethod]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [PrcLvlId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [PrePayAcct]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [PrePaySub]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [PriceClassID]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [PrtMCStmt]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [PrtStmt]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Salut]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [SetupDate]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [ShipCmplt]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [ShipPctAct]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [ShipPctMax]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [SICCode1]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [SICCode2]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [SingleInvoice]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [SlsAcct]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [SlsperId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [SlsSub]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [State]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [StmtCycleId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [StmtType]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxDflt]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxExemptNbr]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxID00]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxID01]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxID02]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxID03]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxLocId]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [TaxRegNbr]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Terms]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Territory]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [TradeDisc]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (' ') FOR [Zip]
GO
*/
--------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customer TO BFGROUP
GRANT SELECT on dbo.Customer TO public
