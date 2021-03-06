USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSTmpLLPmtSched_AlterTable]    Script Date: 12/21/2015 13:44:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpLLPmtSched_AlterTable](
	[ARRefNbr] [char](10) NOT NULL,
	[CalcAccrual] [smallint] NOT NULL,
	[CalcOwed] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DatePmtMade] [smalldatetime] NOT NULL,
	[DueCharges] [float] NOT NULL,
	[DueEscrow] [float] NOT NULL,
	[DueInt] [float] NOT NULL,
	[DueIntCharges] [float] NOT NULL,
	[DueLateFee] [float] NOT NULL,
	[DueLateInt] [float] NOT NULL,
	[DueLateIntOnInt] [float] NOT NULL,
	[DueLIOLI] [float] NOT NULL,
	[DuePrin] [float] NOT NULL,
	[DueTotal] [float] NOT NULL,
	[IntRate] [float] NOT NULL,
	[IntRateCalc] [float] NOT NULL,
	[LastAccrueDate] [smalldatetime] NOT NULL,
	[LastOweDate] [smalldatetime] NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[OwedCharges] [float] NOT NULL,
	[OwedEscrow] [float] NOT NULL,
	[OwedInt] [float] NOT NULL,
	[OwedIntCharges] [float] NOT NULL,
	[OwedLateFee] [float] NOT NULL,
	[OwedLateInt] [float] NOT NULL,
	[OwedLateIntOnInt] [float] NOT NULL,
	[OwedLIOLI] [float] NOT NULL,
	[OwedPrin] [float] NOT NULL,
	[OwedTotal] [float] NOT NULL,
	[PaidCharges] [float] NOT NULL,
	[PaidCurLoanAmt] [float] NOT NULL,
	[PaidEscrow] [float] NOT NULL,
	[PaidInFull] [smallint] NOT NULL,
	[PaidInt] [float] NOT NULL,
	[PaidIntCharges] [float] NOT NULL,
	[PaidLateFee] [float] NOT NULL,
	[PaidLateInt] [float] NOT NULL,
	[PaidLateIntOnInt] [float] NOT NULL,
	[PaidLIOLI] [float] NOT NULL,
	[PaidPrin] [float] NOT NULL,
	[PaidTotal] [float] NOT NULL,
	[PmtDueDate] [smalldatetime] NOT NULL,
	[PmtNbr] [smallint] NOT NULL,
	[SchedCharges] [float] NOT NULL,
	[SchedEscrow] [float] NOT NULL,
	[SchedInt] [float] NOT NULL,
	[SchedIntCharges] [float] NOT NULL,
	[SchedLateFee] [float] NOT NULL,
	[SchedLateInt] [float] NOT NULL,
	[SchedLateIntOnInt] [float] NOT NULL,
	[SchedLoanAmt] [float] NOT NULL,
	[SchedPrin] [float] NOT NULL,
	[SchedTotal] [float] NOT NULL,
	[SchedType] [char](1) NOT NULL,
	[UnpaidCharges] [float] NOT NULL,
	[UnPaidEscrow] [float] NOT NULL,
	[UnPaidInt] [float] NOT NULL,
	[UnPaidIntCharges] [float] NOT NULL,
	[UnPaidLateFee] [float] NOT NULL,
	[UnPaidLateInt] [float] NOT NULL,
	[UnPaidLateIntOnInt] [float] NOT NULL,
	[UnpaidLIOLI] [float] NOT NULL,
	[UnPaidPrin] [float] NOT NULL,
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
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [ARRefNbr]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0)) FOR [CalcAccrual]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0)) FOR [CalcOwed]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [DatePmtMade]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueEscrow]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueIntCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueLateFee]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueLateInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueLateIntOnInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueLIOLI]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DuePrin]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueTotal]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntRate]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntRateCalc]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LastAccrueDate]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LastOweDate]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedEscrow]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedIntCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedLateFee]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedLateInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedLateIntOnInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedLIOLI]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedPrin]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [OwedTotal]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidCurLoanAmt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidEscrow]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0)) FOR [PaidInFull]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidIntCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidLateFee]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidLateInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidLateIntOnInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidLIOLI]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidPrin]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [PaidTotal]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [PmtDueDate]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedEscrow]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedIntCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedLateFee]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedLateInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedLateIntOnInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedLoanAmt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedPrin]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [SchedTotal]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [SchedType]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnpaidCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidEscrow]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidIntCharges]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidLateFee]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidLateInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidLateIntOnInt]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnpaidLIOLI]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [UnPaidPrin]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSTmpLLPmtSched_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
