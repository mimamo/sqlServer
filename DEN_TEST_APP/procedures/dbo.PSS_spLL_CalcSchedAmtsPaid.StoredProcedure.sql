USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_spLL_CalcSchedAmtsPaid]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSS_spLL_CalcSchedAmtsPaid]
@pcLoanNo VARCHAR(20), 
@piPmtNbr SMALLINT
as

Set Nocount On

-- Declare Due Variables
  Declare @DueCharges      As Float
  Declare @DueEscrow       As Float
  Declare @DueInt          As Float
  Declare @DueIntCharges   As float
  Declare @DueLateInt      As Float
  Declare @DueLateIntOnInt as Float
  Declare @DueLIOLI        as Float
  Declare @DuePrin         As Float
  declare @SchedPrin  as float
  declare @PaidLateFee            as float
  declare @DueLateFee as float
  Declare @OwedInt              As Float
  Declare @OwedLateInt          As Float
  Declare @OwedLateIntOnInt     as Float
  Declare @OwedLIOLI            as Float
  Declare @PaidCharges      As Float
  Declare @PaidEscrow       As Float
  Declare @PaidInt          As Float
  Declare @PaidIntCharges   As Float
  Declare @PaidLateInt      As Float
  Declare @PaidLateIntOnInt as Float
  Declare @PaidLIOLI        as Float
  Declare @PaidPrin         As Float
  
  Declare @UnpaidPrin as float
  Declare @OwedPrin as Float
  Declare @PaidAddPrin  as float
  Declare @EndPmtBal as float
  Declare @BegPmtBal as float
Declare @lcTermType  as varchar(1)
   
--PaidCurLoanAmt

  Declare @IntOwedRev as float
  Declare @SchedInt as float
  DECLARE @LastPaidDate  AS SMALLDATETIME
Declare @ldPmtDueDate  as smalldatetime
Declare @ldPmtDueDateBefore  as smalldatetime
Declare @ldToday                  SmallDateTIme				-- Current Date
Declare @SchedBegLoan decimal(28,14)
Declare @SchedEndLoan decimal(28,14)
Declare @SchedEscrow decimal(28,14)
Declare @lfPmtAmt decimal(28,14)
Declare @CreditType varchar(1)
Declare @lcStatus varchar(1)
Declare @liLastPmtNbr  int
Declare @prinIssued  decimal(28,14)
Declare @lfLoanAMt Decimal(28,14)

Set @ldToday = CAST( CONVERT( CHAR(8), GetDate(), 112) AS SMALLDATETIME) 
Declare @liTermToMat smallint

--==========================================================
-- Get Info from the Loan
--==========================================================

select top 1
@CreditType = CreditType,
@lcStatus = Status,
@lfLoanAmt = LoanAMt,
@liTermtoMat = Termtomat,
@liLastPmtNbr = TermToMat
from PSSLoanLedger 
where LoanNo = @pcLoanNo



--==========================================================
-- Get the Pmt Due Date and Sched Prin
-- From the Pmt we are working on
--==========================================================
	
Select top 1
@ldPmtDueDate = PmtDUeDate,
@ldPmtDueDateBefore  = PmtDUeDateBefore, 
@Schedprin = IsNull(SchedPrin, 0.0),
@SchedInt = ISNULL(SchedInt, 0.0),
@SchedEscrow = ISNULL(SchedEscrow,0.00),
@SchedBegLoan = SchedLoanAmtBeg,
@SchedEndLoan = SchedLoanAmtEnd
from PSSLLPmtSched with (nolock)
where LoanNo = @pcLoanNo and PmtNbr = @piPmtNbr

set @lfPmtAmt = @SchedPrin + @SchedInt + @SchedEscrow



Select
  @prinIssued = SUM(PrinNew),
  @SchedInt   = SUM(DailyIntSched),
  @DueCharges  = SUM(ChargesNew),
  @DueIntCharges  = SUM(ChargesIntNew),
  @DueEscrow  = sum(EscrowNew),
  @DueInt  = SUM(dueintnew),
  @DueLateInt  = SUM(Lateintprinnew),
  @DueLateIntOnInt  = SUM(LateintOnintNew),
  @DuePrin = sum(Dueprinnew),
  @DueLateFee = SUM(LateFeenew),
  @OwedInt   = SUM(Intnew)
 From PSSLLDaily with (nolock)
 WHERE LoanNo = @pcLoanNo 
 and PmtNbr = @piPmtNbr
 
  Set @SchedInt = ISNULL(@Schedint,0)
  set @DueCharges  = isnull(@DueCharges  ,0)
  set @DueIntCharges  = isnull(@DueIntCharges  ,0)
  set @DueEscrow  = isnull(@DueEscrow  ,0)
  set @DueInt  = isnull(@DueInt  ,0)
  set @DueLateInt  = isnull(@DueLateInt  ,0)
  set @DueLateIntOnInt  = isnull(@DueLateIntOnInt ,0)
  set @DuePrin = isnull(@DuePrin ,0)
  set @DueLateFee = isnull(@DueLateFee ,0)
  set @OwedInt   = isnull(@OwedInt  ,0)
  set @OwedLateInt  = isnull(@DueLateInt  ,0)
  set @OwedLateIntOnInt  = isnull(@DueLateIntOnInt ,0)
 
	


Select 
  @PaidCharges  = isnull(sum(case pmttype when 'CPR' then Tranamt else 0 End),0.0),
  @PaidIntCharges  = isnull(sum(case pmttype when 'IPC' then Tranamt else 0 End),0.0),
  @PaidEscrow  = isnull(sum(case pmttype when 'WPR' then Tranamt else 0 End),0.0),
  @PaidInt  = isnull(sum(case pmttype when 'IPP' then Tranamt else 0 End),0.0),
  @PaidLateInt  = isnull(sum(case pmttype when 'IPL' then Tranamt else 0 End),0.0),
  @PaidLateIntOnInt  = isnull(sum(case pmttype when 'IPI' then Tranamt else 0 End),0.0),
  @PaidLIOLI  = isnull(sum(case pmttype when 'IPO' then Tranamt else 0 End),0.0),
  @PaidPrin  = isnull(sum(case pmttype when 'PPR' then Tranamt else 0 End),0.0),
  @PaidLateFee  = isnull(sum(case pmttype when 'LPR' then Tranamt else 0 End),0.0),
  @LastPaidDate = isnull(max(case substring(pmttype,2,1) when 'P' then TranDate else '01/01/1900' END),'01/01/1900'),
  @PaidAddPrin = isnull(sum(case pmttype when 'PPA' then TranAmt else 0 End),0.0)
 From PSSLLAppPmt
 WHERE LoanNo = @pcLoanNo 
	AND PmtNbr = @piPmtNbr




--==========================================================
-- For Actual and End of Term
-- If Loan is Active
--
-- Get Last Pmt Ending Amt
-- Calculate New Prin Pmt
-- Update Schedule
--==========================================================

if (@credittype = 'P' or @CreditTYpe = 'E') and @lcStatus = 'A'  
Begin

		--===========================================================================
		-- Get the ending Balance in pmt before
		--===========================================================================

	if @piPmtNbr <> 1
		Select top 1
		@SchedBegLoan = SchedLoanAmtEnd
		from PSSLLPmtSched with (nolock)
		where LoanNo = @pcLoanNo and PmtNbr = @piPmtNbr-1
	else
		set @SchedBegLoan = isnull((select SUM(Tranamt) from PSSLLTran where LoanNo = @pcLoanNo and TranDate <= @ldPmtDueDate and pmttype = 'PIR'),0)
		
		
	Set @SchedBegLoan = ISNULL(@SchedBegLoan,0)
	
	-- ===============================================================================
	-- Get the Term Type
	-- ===============================================================================
		
		
	select top 1 
	@lcTermType = TermType 
	 from PSSLLDaily
	 where LoanNo = @pcLoanNo
	 and PmtNbr = @piPmtNbr
	 
	set @lcTErmType = ISNULL(@lcTermType, 'R')
		
	
	set @SchedInt = ROUND(@Schedint,2)
	
	-- ===============================================================================
	-- FIxed has it set at beginning of loan term  All others are Pmt Amt less
	-- Interest to get to Prin AMt
	-- ===============================================================================
							
	if @lcTermType = 'R'
		set @SchedPrin = round(@lfPmtAMt,2) - @SchedEscrow - @SchedInt 
	else
		Set @SchedPrin  = 0
			

	if @lcTermType = 'N'
		Set @SchedInt = 0
		
	if @Credittype = 'E' and @piPmtNbr <> @liTermToMat	
		Set @SchedPrin = 0
	
	
	if @SchedPrin < 0 set @SchedPrin = 0
	
	
	if @piPmtNbr = @liLastPmtNbr
		Begin
			Set @SchedPrin = @SchedBegLoan +@prinIssued
			Set @SchedEndLoan = 0
		end
	
	set @SchedEndLoan = @SchedBegLoan  + @prinIssued- @SchedPrin - @PaidAddPrin
	
	-- ================================================================
	-- Cannot have negative ending balance
	-- ================================================================
	
--	if @SchedEndLoan < 0 
		--begin
		  --Set @SchedPrin = @SchedBegLoan - @SchedEndLoan - @PaidAddPrin
		--  Set @SchedEndLoan = 0
		 --end
	

	
	
End

if @piPmtNbr = 1 and @lcstatus <> 'P'
	set @SchedBegLoan = 0
	
	

set @SchedEndLoan = @SchedBegLoan - @SchedPrin - @PaidAddPrin  + @prinIssued


	
	--==========================================================
	-- Owed Prin as of the Begining of this Pmt
	-- We take the ending balance as of the last pmt date
	-- and then edning balance after this PmtNbr  
	-- This gives us the correct starting and ending balance. 
	--==========================================================
	
	select top 1
		@BegPmtBal = isnull(PrinEnd,0.00)
	From PSSLLDaily 
	where Loanno = @pcLoanNo
	and CalcIntDate = @ldPmtDueDateBefore
	
	select top 1
		@EndPmtBal = isnull(PrinEnd,0.00) 
	From PSSLLDaily 
	where Loanno = @pcLoanNo
	and CalcIntDate = @ldPmtDueDate
	
	
	Set @BegPmtBal = ISNULL(@BegPmtBal,0.00) 
	Set @EndPmtBal = ISNULL(@endPmtBal,0.00)
	set @OwedPrin  = @BegPmtBal 


	
	
	if @piPmtNbr = 1
		Begin
			 set @OwedPrin = @SchedBegLoan
			 
		end
	--==========================================================
	  -- Get total Interest accrued for interest (A)or charges (L)
	--==========================================================

    Set @IntOwedRev   =  @OwedInt + @OwedLateINt + @OwedLateIntOnInt + @OwedLIOLI
	set @UnpaidPrin = round(@SchedPrin,2) - round(@PaidPrin,2)

	-- If Paid more than scheduled Unpaid is not negative this is Additional Principal Pmt

	if @UnpaidPrin < 0 set @unpaidPrin  = 0

     Update PSSLLPmtSched
		Set DueEscrow          = round(@DueEscrow,2),
			DueCharges = round(@DueCharges      ,2),
			DueIntCharges  = round(@DueIntCharges   ,2),
			OwedCharges    = round(@DueCharges      ,2),
			OwedIntCharges = round(@DueIntCharges   ,2),
			PaidCharges = round(@PaidCharges,2),
			PaidIntCharges = round(@PaidIntCharges,2),
			UnPaidCharges = round(@DueCharges,2) - round(@PaidCharges,2),
			UnpaidIntCharges = round(@DueIntCharges,2) - round(@PaidIntCharges,2),
			DueInt             = round(@DueInt,2),
			DueLateInt         = round(@DueLateInt,2),
			DueLateIntOnInt    = round(@DueLateIntOnInt,2),
			DuePrin            = round(@DuePrin,2),
			DueLateFee         = round(@DueLateFee,2),
			OwedEscrow         = round(@DueEscrow,2),
			OwedInt            = round(@OwedInt  ,2), 
			OwedLateInt        = round(@OwedLateInt  ,2), 
			OwedLateIntOnInt   = round(@OwedLateIntOnInt  ,2), 
			OwedPrin           = round(@OwedPrin,2),
			OwedLateFee        = round(@DueLateFee,2),
			PaidEscrow         = round(@PaidEscrow,2), 
			PaidInt            = round(@PaidInt,2), 
			PaidLateInt        = round(@PaidLateInt,2), 
			PaidLateIntOnInt   = round(@PaidLateIntOnInt,2),
			PaidPrin           = round(@PaidPrin,2), 
			PaidLateFee        = round(@PaidLateFee,2),
			PrinIssued         = ROUND(@PrinIssued,2),
			SchedLoanAmtBeg	  =  ROUND(@SchedBegloan,2),
			SchedLoanAmtEnd   = ROUND(@SchedEndloan,2),
			SchedPrin         = round(@SchedPrin,2),
			SchedInt			 = ROUND(@SchedInt,2),
			UnPaidEscrow       = round(SchedEscrow,2)- round(@PaidEscrow,2), 
			UnPaidInt          = round(@SchedInt,2) - round(@PaidInt,2), 
			UnPaidLateInt      = round(@OwedLateInt,2) - round(@PaidLateInt,2), 
			UnPaidLateIntOnInt = round(@OwedLateIntOnInt,2) - round(@PaidLateIntOnInt,2), 
			UnpaidLateFee      = round(@DueLateFee,2) - round(@PaidLateFee,2), 
			UnPaidPrin         = @UnpaidPrin,
			DatePmtMade        = @LastPaidDate,
            PaidPrinAdd         = @PaidAddPrin,
			PaidLoanAMtBeg	   = @BegPmtBal,
			PaidLoanAmtEnd     = @EndPmtBal ,
			PaidTotal         = IsNull(round(@PaidPrin,2) + round(@PaidLateIntOnInt,2) + round(@PaidLateInt,2)+ round(@PaidInt,2)+ round(@PaidEscrow,2) + round(@PaidLateFee,2) + round(@PaidCharges,2) + round(@PaidIntCharges   ,2),0),
	  		DueTotal          = IsNull(round(@DuePrin,2) + round(@DueLateIntOnInt,2) + round(@DueLateInt,2)+ round(@DueInt,2)+ round(@DueEscrow,2) + round(@DueCharges      ,2) + round(@DueLateFee,2)+ round(@DueIntCharges   ,2),0),
			OwedTotal         = IsNull(round(@OwedPrin,2) + round(@OwedLateIntOnInt,2) + round(@OwedLateInt,2)+ round(@OwedInt,2)+ round(@DueEscrow,2)+ round(@DueCharges      ,2) + round(@DueLateFee,2)+ round(@DueIntCharges   ,2),0)
		WHERE LoanNo = @pcLoanNo AND PmtNbr = @piPmtNbr
GO
