USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_siLL_PSSLLPmtSched_E_PMTNBR]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSS_siLL_PSSLLPmtSched_E_PMTNBR]
@pcLoanNo VarChar(20), 
@piPmtNbr SmallInt = 1, 
@pcWhatUser  varchar(15) = '',
@pcWhatProg   varchar(10) = '',
@pcWhatSystem varchar(2)

-- WITH ENCRYPTION 
	As

set nocount on

-- =========================================================================================	
-- CLJ 04/02/2012
-- Created.
-- This procedure populates PSSLLPmtSched and PSSLLDaily with all paymnet entries for a loan.
-- For ENd of Term
-- =========================================================================================	


-- =========================================================================================	
 -- From PSSLoanLedger
-- =========================================================================================	

Declare @lfAuthLoanAmt			Decimal(28,14)				-- The Authorized Amount of the loan
Declare @lfEscrowPmt			Decimal(28,14)				-- Amount of Escrow in Pmt	
Declare @lcStatus				varchar(1)					-- Loan Status


-- =========================================================================================	
 --From PSSLLFloatInt
-- =========================================================================================	

Declare @ldDateBeg				smalldatetime				-- Start of Interest date
Declare @ldDateEnd				smalldatetime				-- Endof Interest date
Declare @liTermToMat			SmallInt					-- Term To Maturity
Declare @liTermIntOnly			SmallInt					-- int Only/Grace Period
Declare @liTermNoPmt			SmallInt					-- Term with No Int/Prin just int Calc.
Declare @ldFirstPmtDUeDate		SmallDatetime				-- First Pmt Due Date
Declare @liPmtAMt				Decimal(28,14)				-- Amt of Pmt
Declare @liPmtDueDay			SmallInt	-- Day of month payment is due
Declare @lcPmtFreq				VarChar(1)					-- Pmt Terms (Monthly, Weekly etc)
Declare @lcDayCOunt				VarChar(1)					-- Term/365/360
Declare @liCalcLateIntonInt		smallint				-- Do we calcualte Late Int
Declare @lfPenIntAMtDaily		smallint				-- Amt of Daily Penalty Interst

-- =========================================================================================	
---- Other Variables 
-- =========================================================================================	

Declare @liCalcIsADueDate		int							-- Is this a Pmt Date
Declare @liNoDaysInTerm			Smallint					-- No Days in the Term
Declare @liPmtNbr				SmallInt	-- Payment number we generate

Declare @ldPmtDueDate			  SmallDateTime				-- Date the payment is due generated for each scheduled pmt
Declare @ldLastPmtDueDate smalldatetime		-- Beg Date of the Pmt
Declare @ldCalcIntDate smalldatetime		-- Date for loop of Calcuating INterest
Declare @liTermToStop		smallint				-- Term we stop at
Declare @ldPmtDueStart	smalldatetime		-- due date of payment we need to re-do schedule	
Declare @ldPmtDuePrev		smalldatetime		-- due date of prior payment to the one we need to re-do schedule	

Declare @lfDailyIntAmt					decimal(28,14)  -- Daily INterest Amount
Declare @lfDailyIntRate					Decimal(28,14)			-- Interest rate daily
Declare @lfIntRateAnnual				Decimal(28,14)			-- Interest rate annaul
Declare @lfPenIntRate 					Decimal(28,14)			-- Penalty Interest Rate
Declare @lfPenDailyIntRate			Decimal(28,14) 
Declare @lfPenDailyIntAmt				Decimal(28,14) 
Declare @lfLoanAmtPrev					Decimal(28,14)

Declare @liPmtNbrBeg		smallint			-- TO update the FLoat Int Table
Declare @liPmtNbrEnd		smallint			-- TO update the FLoat Int Table
--
Declare @lfPrinAmtInPmt					Decimal(28,14)			-- Principal amount in this payment if payments made on time
Declare @lfSchedLoanAmt					Decimal(28,14)			-- Scheduled Loan Amount	
Declare @lfIntAmtInPmt					Decimal(28,14)			-- Interest amount in this payment if payments made on time
Declare @lfSchedLoanAmtBeg			decimal(28,14)
Declare @lfSchedLoanAmtEnd			decimal(28,14)
Declare @lfLateIntAmt				Decimal(28,14)			-- Late in on Int

Declare @ldToday                  SmallDateTIme				-- Current Date

Set @ldToday = CAST( CONVERT( CHAR(8), GetDate(), 112) AS SMALLDATETIME) 

-- =====================================================
-- Get some Extra fields from  Loan Ledger table
-- =====================================================


Select Top 1
	@lfAuthLoanAmt=	AuthLoanAmt, 
	@lfSchedLoanAmt = LoanAMt,
	@lfEscrowPmt =	EscrowPmt, 
	@lcStatus =	Status,
	@liCalcLateIntonInt = CalcLateIntInt
From PSSLoanLedger Where LoanNo = @pcLoanNo

-- =======================================================================================================================================
-- Get a Payment Due Date from schedule for the payment we need to do re-do schedule from.
-- Perhaps, if we cannot find this payment number in the schedule, we shoud either exit or do schedueld from the beginnig...
-- We also need a due date of prior term for removing records from Daily table.
-- =======================================================================================================================================

Select  @ldPmtDueStart = '', @ldPmtDuePrev = '', @lfLoanAmtPrev = 0.00

If @piPmtNbr > 1 and  Exists (Select * From PSSLLPmtSched Where LoanNo = @pcLoanNo and PmtNbr = @piPmtNbr)
	Begin
		Select @ldPmtDueStart = PmtDueDate From PSSLLPmtSched Where LoanNo = @pcLoanNo and PmtNbr = @piPmtNbr
		Select @ldPmtDuePrev = PmtDueDate, @lfLoanAmtPrev = SchedLoanAmtEnd From PSSLLPmtSched Where LoanNo = @pcLoanNo and PmtNbr = (@piPmtNbr - 1)
	End
Else 
	RETURN -- ??????	

-- ==================================================================================
-- Delete from the pmt Schedule 
-- ==================================================================================

delete from pssllpmtsched where loanno = @pcLoanNo and PmtNbr >= @piPmtNbr

-- ===============================================================================================
-- Delete from the Daily File
-- Delete records with Clac Date > due date of the term preceding the one we do schedule 
-- ===============================================================================================

delete from pssllDaily where loanno = @pcLoanNo	 and CalcIntDate > @ldPmtDuePrev

-- ==================================================================================
-- Go through the Floating Interst Table and create the Schedule
-- ==================================================================================

Declare csrFloat Cursor For
	Select DateBeg, DateEnd, TermToMat, TermIntOnly, TermNoPmt, FirstPmtDueDate, PmtAmt, PmtDueDay, PmtFreq, DayCount, intRate, IntRatePen from PSSLLFloatInt Where LoanNo = @pcLoanNo and PmtNbrBeg <= @piPmtNbr and PmtNbrEnd >= @piPmtNbr order by DateBeg


Open csrFloat

Fetch Next From csrFloat Into @ldDateBeg, @ldDateEnd, @liTermToMat, @liTermIntOnly, @liTermNoPmt, @ldFirstPmtDUeDate,  @liPmtAmt, @liPmtDueDay, @lcPmtFreq, @lcDayCount, @lfintRateAnnual, @lfPenIntRate

-- ==================================================================================
-- If nothing in the interest table then we stop
-- ==================================================================================

Set @lcPmtFreq = isnull(@lcPmtFreq, '')

if @lcPmtFreq = '' REturn

-- ==================================================================================
-- Set the initial Term info
-- ==================================================================================
		
Set @liPmtNbr = @piPmtNbr - 1
Set @ldLastPmtDueDate = @ldDateBeg
Set @ldPmtDueDate = @ldFirstPmtDueDate
Set @ldCalcIntDate = @ldDateBeg
set @liTermToStop = @liTermToMat + @liTermNoPmt + @liTermIntOnly

-- ====================================================================================================================
-- If we are recalculating from any midterm, set starting loan amount to sched end amount from the prior term.
-- ====================================================================================================================

if @piPmtNbr > 1
	Set @lfSchedLoanAmt = @lfLoanAmtPrev

Set @liPmtNbrBeg = @liPmtNbr + 1

While @@Fetch_Status = 0
  Begin
	
	-- ==================================================================================
	-- Keep processing until we reach the maximum number of payments (terms to maturity)
	-- ==================================================================================

	While @liPmtNbr < (@liTermToStop) and @ldCalcIntDate <= @ldDateEnd

		Begin

			-- =============================================
			-- Increment to process the next payment number
			-- =============================================

			Set @liPmtNbr = @liPmtNbr + 1

			-- =============================================
			-- How many Days in my Term
			-- =============================================

			set @liNoDaysInTerm  = Datediff(dd, @ldLastPmtDueDate, @ldPmtDueDate) --+ 1

			if @liPmtNbr = 1 set @liNoDaysInTerm = @liNoDaysInTerm + 1


			-- ===============================================================================
			-- We calculate Interest each day from the Last Pmt Due Date to this Date
			-- ===============================================================================
			
			Set @lfIntAmtinPmt = 0
			while @ldCalcIntDate <= @ldPmtDueDate

				Begin
				
					-- ===============================================================================
					-- Get the Interest Rate and Amount for this date
					-- ===============================================================================

					exec dbo.PSS_spLL_CalcInt @ldCalcIntDate, @lfSchedLoanAmt output, @lfAuthLoanAmt, @liNoDaysInTerm, @pcWhatSystem, @pcLoanNo, @lfintRateAnnual, @lfDailyIntRate output, @lfDailyIntAmt output, @lfPenIntRate, @lfPenDailyIntRate output, @lfPenDailyIntAmt output, @lcStatus, @lcDayCOunt, @lcPmtFreq								   

					-- ===============================================================================
					-- Update the Interest Total for this Pmt
					-- ===============================================================================


					Set @lfIntAmtinPmt = @lfIntAmtinPmt   + @lfDailyIntAmt

					-- ===============================================================================
					-- If this is the pmt due date set it so
					-- ===============================================================================


					if @ldCalcIntDate = @ldPmtDueDate set @liCalcIsADueDate = 1 else set @liCalcIsADueDate = 0

					-- ===============================================================================
					-- If this is a due date
					-- ===============================================================================

					if @liCalcIsADueDate = 1
					Begin


						set @lfIntAmtInPmt = ROUND(@lfIntAMtinPmt,2)
				
						-- ================================================================
						-- At End of Term we pay the principal
						-- ================================================================

						set @lfSchedLoanAMtBeg = @lfSchedLoanAmt
						if @liPmtNbr = @liTermToStop
							Set @lfPrinAmtInPmt = @lfSchedLoanAmt
						else
							Set @lfPrinAmtInPmt = 0
									
						set @lfSchedLoanAmtEnd = @lfSchedLoanAmtBeg - @lfPrinAmtInPmt
						
						Set @pcLoanNo = isnull(@pcLoanNo, '')
						Set @liPmtNbr = isnull(@liPmtNbr, 0)
						Set @ldPmtDueDate =isnull(@ldPmtDuedate, '01/01/1900')

						set @lfPrinAmtInPmt =isnull (@lfPrinAmtInPmt, 0.00)
						Set @lfIntAmtInPmt = ROUND(@lfIntAMtInPmt,2)
						Set @lfEscrowPmt =isnull(@lfEscrowPmt, 0.00)

						Set @lfSchedLoanAmtBeg= isnull(@lfSchedLoanAmtBeg , 0.00)
						Set @lfSchedLoanAmtEnd= isnull(@lfSchedLoanAmtEnd , 0.00)
						Set @pcWhatprog = isnull(@pcWhatProg, '')
						Set @pcWhatUser = isnull (@pcWhatUser, '')
					
						-- ================================================================
						-- We need to see what the beg of the term was
						-- ================================================================
						
						if @liPmtNbr <> 1 set @ldLastPmtDueDate = DATEADD(dd, 1, @ldLastPmtDueDate)
			    	
						-- ================================
						-- Add the Pmt Schedule REcord
						-- ================================
							
	    
						Begin Transaction tx_Insert

							Insert Into PSSLLPmtSched (LoanNo, PmtNbr, PmtDueDate,   SchedPrin,       SchedInt,       SchedEscrow,  SchedLoanAmtBeg,  SchedLoanAmtEnd,  UnpaidEscrow, UnpaidInt,      UnpaidPrin,      Crtd_DateTime, Crtd_Prog,   Crtd_User,   LUpd_DateTime, LUpd_Prog,   LUpd_User, PmtDueDateBefore )    
									Values (@pcLoanNo, @liPmtNbr, @ldPmtDueDate , @lfPrinAmtInPmt, @lfIntAmtInPmt, @lfEscrowPmt, @lfSchedLoanAmtBeg, @lfSchedLoanAmtEnd, @lfEscrowPmt, @lfIntAmtInPmt, @lfPrinAmtInPmt, @ldTOday,      @pcWhatProg, @pcWhatUser, @ldTOday,      @pcWhatProg, @pcWhatUser, @ldLastPmtDueDate)	

						Commit Transaction tx_Insert
		
					End				

					-- ===============================================================================
					-- Add the Daily Info
					-- ===============================================================================
					

					Exec dbo.PSS_siLL_PSSLLDaily @pcLoanNo, @liCalcIsADueDate, @ldCalcIntDate,  @lfintRateAnnual, @lfDailyIntRate, @lfPenIntRate, @lfPenDailyIntRate, @liPmtNbr, @lfDailyIntAMt , @pcWhatSystem, @pcWhatProg, @pcWhatUser
					

					-- ===============================================================================
					-- See if this interest is late and update Pmt schedule if it is
					-- ===============================================================================
					
					
					Exec PSS_spLL_CalcLateIntonInt @pcLoanNo, @ldCalcIntDate, @liCalcLateIntonInt, @lfLateIntAmt output, @lfIntRateAnnual, @lcPmtFreq, @lcDayCOunt, @liNoDaysInTerm, @lfDailyIntRate, @lfPenIntAmtDaily					
					

					-- ===============================================================================
					-- Update TOtals in case anything transaction on that date
					-- Have to deal with Charges @lfNewChgsInt  The zero below
					-- ===============================================================================

					Exec dbo.PSS_spLL_UpdatePSSLLDaily @pcLoanNo,  @ldCalcIntDate, 0, @lfLateIntAmt, @lfPenIntAMtDaily, @lfDailyIntAMt,   @pcWhatSystem, @pcWhatProg, @pcWhatUser


--** For the N loans to get the amts you ahve to take the Sched Pmt + addPrin Pmt for the loan amt.

				
					-- ===============================================================================
					-- Add One Day
					-- ===============================================================================
				
					Set @ldCalcIntDate = dateadd(dd, 1, @ldCalcIntDate)

				end --while @ldCalcIntDate <= @ldPmtDueDate
	
				-- ================================
				-- Get dates for Next Pmt
				-- ================================
					
					   
				Set @ldLastPmtDueDate = @ldPmtDueDate
				set @ldPmtDueDate = dbo.PSS_fnLL_CalculateNextPaymentDate(@ldPmtDueDate, @liPmtDueDay, @lcPmtFreq, @lcDayCount)
				if @ldPmtDueDate > @ldDateEnd set @ldPmtDueDate = @ldDateEnd
				Set @liPmtNbrEnd = @liPmtnbr
			End  -- While @liPmtNbr < (@liTermToStop) and @ldCalcIntDate <= @DateEnd


		-- ======================================================================================================================================
		-- If this is a midterm re-calculation, we do nto need to update periods in floating rates table since they are already computed
		-- ======================================================================================================================================
		
		If @piPmtNbr = 1
		 Update PSSLLFloatInt set PmtNbrBeg = @liPmtNbrBeg, PmtNbrEnd = @liPmtNbrEnd where Loanno = @pcLoanNo and DateBeg = @ldDateBeg

		Fetch Next From csrFloat Into @ldDateBeg, @ldDateEnd, @liTermToMat, @liTermIntOnly, @liTermNoPmt, @ldFirstPmtDUeDate,  @liPmtAmt, @liPmtDueDay, @lcPmtFreq, @lcDayCount, @lfintRateAnnual, @lfPenIntRate
		
		Set @ldPmtDueDate = @ldFirstPmtDueDate
		Set @liTermToStop  = @liTermToStop + @liTermToMat + @liTermIntOnly + @liTermNoPmt
		

  End

Close csrFloat
Deallocate csrFloat
GO
