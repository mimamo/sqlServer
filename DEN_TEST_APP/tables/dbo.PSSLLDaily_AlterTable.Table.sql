USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSLLDaily_AlterTable]    Script Date: 12/21/2015 14:10:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSLLDaily_AlterTable](
	[CalcIntDate] [smalldatetime] NOT NULL,
	[CalcIsADueDate] [int] NOT NULL,
	[ChargesBeg] [float] NOT NULL,
	[ChargesEnd] [float] NOT NULL,
	[ChargesIntBeg] [float] NOT NULL,
	[ChargesIntEnd] [float] NOT NULL,
	[ChargesIntNew] [float] NOT NULL,
	[ChargesIntPaid] [float] NOT NULL,
	[ChargesIntTotNew] [float] NOT NULL,
	[ChargesIntTotPaid] [float] NOT NULL,
	[ChargesNew] [float] NOT NULL,
	[ChargesPaid] [float] NOT NULL,
	[ChargesTotNew] [float] NOT NULL,
	[ChargesTotPaid] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DailyIntAct] [float] NOT NULL,
	[DailyIntonIntLate] [float] NOT NULL,
	[DailyIntPen] [float] NOT NULL,
	[DailyIntPrinLate] [float] NOT NULL,
	[DailyIntSched] [float] NOT NULL,
	[DayCount] [char](1) NOT NULL,
	[DueIntBeg] [float] NOT NULL,
	[DueIntEnd] [float] NOT NULL,
	[DueIntNew] [float] NOT NULL,
	[DueIntTotNew] [float] NOT NULL,
	[DueIntTotPaid] [float] NOT NULL,
	[DuePrinBeg] [float] NOT NULL,
	[DuePrinEnd] [float] NOT NULL,
	[DuePrinNew] [float] NOT NULL,
	[DuePrinTotNew] [float] NOT NULL,
	[DuePrinTotPaid] [float] NOT NULL,
	[EscrowBeg] [float] NOT NULL,
	[EscrowEnd] [float] NOT NULL,
	[EscrowNew] [float] NOT NULL,
	[EscrowPaid] [float] NOT NULL,
	[EscrowTotNew] [float] NOT NULL,
	[EscrowTotPaid] [float] NOT NULL,
	[FeeBeg] [float] NOT NULL,
	[FeeEnd] [float] NOT NULL,
	[FeeNew] [float] NOT NULL,
	[FeePaid] [float] NOT NULL,
	[FeeTotNew] [float] NOT NULL,
	[FeeTotPaid] [float] NOT NULL,
	[IntBeg] [float] NOT NULL,
	[IntEnd] [float] NOT NULL,
	[IntNew] [float] NOT NULL,
	[IntPaid] [float] NOT NULL,
	[IntRate] [float] NOT NULL,
	[IntRateDaily] [float] NOT NULL,
	[IntRateDailyPen] [float] NOT NULL,
	[IntRatePen] [float] NOT NULL,
	[IntTotNew] [float] NOT NULL,
	[IntTotPaid] [float] NOT NULL,
	[LateFeeBeg] [float] NOT NULL,
	[LateFeeEnd] [float] NOT NULL,
	[LateFeeNew] [float] NOT NULL,
	[LateFeePaid] [float] NOT NULL,
	[LateFeeTotNew] [float] NOT NULL,
	[LateFeeTotPaid] [float] NOT NULL,
	[LateIntonIntBeg] [float] NOT NULL,
	[LateIntonIntEnd] [float] NOT NULL,
	[LateIntonIntNew] [float] NOT NULL,
	[LateIntonIntPaid] [float] NOT NULL,
	[LateIntonIntTotNew] [float] NOT NULL,
	[LateIntonIntTotPaid] [float] NOT NULL,
	[LateIntPrinBeg] [float] NOT NULL,
	[LateIntPrinEnd] [float] NOT NULL,
	[LateIntPrinNew] [float] NOT NULL,
	[LateIntPrinPaid] [float] NOT NULL,
	[LateIntPrinTotNew] [float] NOT NULL,
	[LateIntPrinTotPaid] [float] NOT NULL,
	[LoanNo] [char](20) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_user] [char](10) NOT NULL,
	[NoDaysInTerm] [int] NOT NULL,
	[PenIntBeg] [float] NOT NULL,
	[PenIntEnd] [float] NOT NULL,
	[PenIntNew] [float] NOT NULL,
	[PenIntPaid] [float] NOT NULL,
	[PenIntTotNew] [float] NOT NULL,
	[PenIntTotPaid] [float] NOT NULL,
	[PmtFreq] [char](1) NOT NULL,
	[PmtNbr] [int] NOT NULL,
	[PrinBeg] [float] NOT NULL,
	[PrinEnd] [float] NOT NULL,
	[PrinNew] [float] NOT NULL,
	[PrinPaidAdd] [float] NOT NULL,
	[PrinPaidReg] [float] NOT NULL,
	[PrinTotNew] [float] NOT NULL,
	[PrinTotPaidAdd] [float] NOT NULL,
	[PrinTotPaidReg] [float] NOT NULL,
	[TermType] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [CalcIntDate]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0)) FOR [CalcIsADueDate]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesIntBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesIntEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesIntNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesIntPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesIntTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesIntTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [ChargesTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DailyIntAct]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DailyIntonIntLate]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DailyIntPen]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DailyIntPrinLate]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DailyIntSched]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [DayCount]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueIntBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueIntEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueIntNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueIntTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DueIntTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DuePrinBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DuePrinEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DuePrinNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DuePrinTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [DuePrinTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [EscrowBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [EscrowEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [EscrowNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [EscrowPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [EscrowTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [EscrowTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [FeeBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [FeeEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [FeeNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [FeePaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [FeeTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [FeeTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntRate]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntRateDaily]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntRateDailyPen]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntRatePen]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [IntTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeeBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeeEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeeNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeePaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeeTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateFeeTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntonIntBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntonIntEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntonIntNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntonIntPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntonIntTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntonIntTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntPrinBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntPrinEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntPrinNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntPrinPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntPrinTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [LateIntPrinTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [LoanNo]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [Lupd_user]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0)) FOR [NoDaysInTerm]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PenIntBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PenIntEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PenIntNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PenIntPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PenIntTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PenIntTotPaid]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [PmtFreq]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0)) FOR [PmtNbr]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinBeg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinEnd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinPaidAdd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinPaidReg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinTotNew]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinTotPaidAdd]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrinTotPaidReg]
GO
ALTER TABLE [dbo].[PSSLLDaily_AlterTable] ADD  DEFAULT ('') FOR [TermType]
GO
