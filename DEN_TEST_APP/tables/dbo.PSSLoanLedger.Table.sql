USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLoanLedger]    Script Date: 12/21/2015 14:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLoanLedger](
	[AcctNo] [char](20) NOT NULL,
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[ApplicantNbr] [char](10) NOT NULL,
	[AssetId] [char](10) NOT NULL,
	[AssetSubId] [char](10) NOT NULL,
	[AuthLoanAmt] [float] NOT NULL,
	[AutoPmtApp] [char](1) NOT NULL,
	[BlackListDate] [smalldatetime] NOT NULL,
	[CalcLateIntInt] [smallint] NOT NULL,
	[CalcLateIntPrin] [smallint] NOT NULL,
	[CheckedBy] [char](47) NOT NULL,
	[City] [char](30) NOT NULL,
	[ClientCode] [char](10) NOT NULL,
	[CloseDate] [smalldatetime] NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[CpnyName] [char](60) NOT NULL,
	[CreditInfo] [char](100) NOT NULL,
	[CreditType] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurBal] [float] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[Custom0] [char](20) NOT NULL,
	[Custom1] [char](20) NOT NULL,
	[Custom10] [float] NOT NULL,
	[Custom11] [smalldatetime] NOT NULL,
	[Custom12] [smalldatetime] NOT NULL,
	[Custom13] [smalldatetime] NOT NULL,
	[Custom14] [smalldatetime] NOT NULL,
	[Custom15] [char](100) NOT NULL,
	[Custom2] [char](20) NOT NULL,
	[Custom3] [char](60) NOT NULL,
	[Custom4] [char](60) NOT NULL,
	[Custom5] [char](10) NOT NULL,
	[Custom6] [char](10) NOT NULL,
	[Custom7] [float] NOT NULL,
	[Custom8] [float] NOT NULL,
	[Custom9] [float] NOT NULL,
	[DayCount] [char](1) NOT NULL,
	[DepositRec] [float] NOT NULL,
	[DepositReq] [float] NOT NULL,
	[DueCharges] [float] NOT NULL,
	[DueEscrow] [float] NOT NULL,
	[DueInt] [float] NOT NULL,
	[DueLateInt] [float] NOT NULL,
	[DuePrin] [float] NOT NULL,
	[DueTotal] [float] NOT NULL,
	[EscrowAcctID] [char](10) NOT NULL,
	[EscrowBal] [float] NOT NULL,
	[EscrowPmt] [float] NOT NULL,
	[FinalPayment] [float] NOT NULL,
	[FirstPayDate] [smalldatetime] NOT NULL,
	[FundDate] [smalldatetime] NOT NULL,
	[GraceDays] [smallint] NOT NULL,
	[Guarantors] [char](100) NOT NULL,
	[ILID] [char](10) NOT NULL,
	[InsPolExpDate] [smalldatetime] NOT NULL,
	[IntAccrued] [float] NOT NULL,
	[IntFreezeDate] [smalldatetime] NOT NULL,
	[IntLastAccr] [char](6) NOT NULL,
	[IntLastAccrDate] [smalldatetime] NOT NULL,
	[IntRate] [float] NOT NULL,
	[KeyedBy] [char](47) NOT NULL,
	[LastAuditDate] [smalldatetime] NOT NULL,
	[LastPayDate] [smalldatetime] NOT NULL,
	[LastRefNbr] [char](10) NOT NULL,
	[LateFeeAmt] [float] NOT NULL,
	[LateFeeWhen] [char](1) NOT NULL,
	[LegalJurisd] [char](3) NOT NULL,
	[LienNo] [char](1) NOT NULL,
	[LoanAmt] [float] NOT NULL,
	[LoanDate] [smalldatetime] NOT NULL,
	[LoanMatDate] [smalldatetime] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LoanNoMergeTo] [char](20) NOT NULL,
	[LoanOfficer] [char](10) NOT NULL,
	[LoanOutstanding] [float] NOT NULL,
	[LoanStartDate] [smalldatetime] NOT NULL,
	[LoanTypeCode] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MonthPmt] [float] NOT NULL,
	[Name] [char](60) NOT NULL,
	[NextAuditDate] [smalldatetime] NOT NULL,
	[NextPayDate] [smalldatetime] NOT NULL,
	[NoteId] [int] NOT NULL,
	[Originator] [char](47) NOT NULL,
	[OriginatorPos] [char](40) NOT NULL,
	[OwnCode] [char](10) NOT NULL,
	[PaidCharges] [float] NOT NULL,
	[PaidEscrow] [float] NOT NULL,
	[PaidInt] [float] NOT NULL,
	[PaidLateInt] [float] NOT NULL,
	[PaidPrin] [float] NOT NULL,
	[PaidTotal] [float] NOT NULL,
	[Phone] [char](10) NOT NULL,
	[Pjt_Entity] [char](32) NOT NULL,
	[PledgeCode] [char](20) NOT NULL,
	[PmtDueDay] [int] NOT NULL,
	[PmtFreq] [char](1) NOT NULL,
	[PortDivAuth] [char](47) NOT NULL,
	[PortDivAuthPos] [char](40) NOT NULL,
	[PostingApprBy] [char](47) NOT NULL,
	[PostingBy] [char](47) NOT NULL,
	[Project] [char](16) NOT NULL,
	[ProjectIntAccr] [char](16) NOT NULL,
	[ReasonAcctClose] [char](1) NOT NULL,
	[ReCalc] [smallint] NOT NULL,
	[Region] [char](10) NOT NULL,
	[Relation] [char](6) NOT NULL,
	[RevCRExpDate] [smalldatetime] NOT NULL,
	[RevCRInitDate] [smalldatetime] NOT NULL,
	[RevCRReqToPay] [float] NOT NULL,
	[SecondAddr1] [char](30) NOT NULL,
	[SecondAddr2] [char](30) NOT NULL,
	[SecondCity] [char](30) NOT NULL,
	[SecondState] [char](2) NOT NULL,
	[SecondZipCode] [char](10) NOT NULL,
	[Sector] [char](10) NOT NULL,
	[SSN] [char](9) NOT NULL,
	[State] [char](2) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StatusCode] [char](10) NOT NULL,
	[TaskIntAccr] [char](32) NOT NULL,
	[TaxId] [char](9) NOT NULL,
	[TermToMat] [int] NOT NULL,
	[TotCharges] [float] NOT NULL,
	[TypeofLoan] [char](1) NOT NULL,
	[UnpaidCharges] [float] NOT NULL,
	[UnpaidEscrow] [float] NOT NULL,
	[UnpaidInt] [float] NOT NULL,
	[UnpaidLateInt] [float] NOT NULL,
	[UnpaidPrin] [float] NOT NULL,
	[UnpaidTotal] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[Year] [char](4) NOT NULL,
	[ZipCode] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [AcctNo]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [ApplicantNbr]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [AssetId]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [AssetSubId]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [AuthLoanAmt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [AutoPmtApp]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [BlackListDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [CalcLateIntInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [CalcLateIntPrin]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CheckedBy]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [ClientCode]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [CloseDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Country]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CpnyName]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CreditInfo]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CreditType]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [CurBal]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CuryId]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CuryRateType]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [CustID]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom0]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom1]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [Custom10]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [Custom11]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [Custom12]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [Custom13]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [Custom14]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom15]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom2]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom3]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom4]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom5]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Custom6]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [Custom7]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [Custom8]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [Custom9]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [DayCount]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DepositRec]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DepositReq]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DueCharges]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DueEscrow]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DueInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DueLateInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DuePrin]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [DueTotal]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [EscrowAcctID]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [EscrowBal]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [EscrowPmt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [FinalPayment]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [FirstPayDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [FundDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [GraceDays]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Guarantors]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [ILID]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [InsPolExpDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [IntAccrued]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [IntFreezeDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [IntLastAccr]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [IntLastAccrDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [IntRate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [KeyedBy]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [LastAuditDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [LastPayDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LastRefNbr]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [LateFeeAmt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LateFeeWhen]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LegalJurisd]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LienNo]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [LoanAmt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [LoanDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [LoanMatDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LoanNoMergeTo]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LoanOfficer]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [LoanOutstanding]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [LoanStartDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LoanTypeCode]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [MonthPmt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [NextAuditDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [NextPayDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Originator]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [OriginatorPos]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [OwnCode]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [PaidCharges]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [PaidEscrow]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [PaidInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [PaidLateInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [PaidPrin]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [PaidTotal]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Pjt_Entity]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [PledgeCode]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [PmtDueDay]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [PmtFreq]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [PortDivAuth]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [PortDivAuthPos]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [PostingApprBy]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [PostingBy]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Project]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [ProjectIntAccr]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [ReasonAcctClose]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [ReCalc]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Region]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Relation]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [RevCRExpDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [RevCRInitDate]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [RevCRReqToPay]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [SecondAddr1]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [SecondAddr2]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [SecondCity]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [SecondState]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [SecondZipCode]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Sector]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [SSN]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [StatusCode]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [TaskIntAccr]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [TaxId]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0)) FOR [TermToMat]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [TotCharges]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [TypeofLoan]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [UnpaidCharges]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [UnpaidEscrow]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [UnpaidInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [UnpaidLateInt]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [UnpaidPrin]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [UnpaidTotal]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [VendID]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [Year]
GO
ALTER TABLE [dbo].[PSSLoanLedger] ADD  DEFAULT ('') FOR [ZipCode]
GO
