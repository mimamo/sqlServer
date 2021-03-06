USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_siLL_PSSTmpLLGenAPVO]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PSS_siLL_PSSTmpLLGenAPVO]
@pdStartDate SmallDateTime, 
@pdEndDate SmallDateTime, 
@pcLoanNo VarChar(20), 
@pcVendCustId VarChar(20),
@pcLoanType VarChar(1),
@pcSchedPay varchar(1), 
@pcCpnyID VarChar(10), 
@pcWhatSystem varChar(2),
@pcWhatProg   varchar(10),
@pcWhatUser		varchar(10) 


--WITH ENCRYPTION 
AS

Set nocount on


-- ======================================================================================
-- IAA - 04/13/10
-- Created.
-- Loads temp table for the grid on Generate AP Vouchers screen.
--
-- IAA - 05/01/2012
-- Adjusted to the new LMS	
-- 
-- Parameter:
-- @pdStartDate		- Start date from the screen (can be blank)
-- @pdEndDate			- End Date from the screen.
-- @pcLoanNo			- Loan Number from the screen (can be blank)
-- @@pcVendCustId	- Vendor/Customer Id from the screen  (can be blank)
-- @pcSchedPay		=  S;Scheduled Payments Only,I;Include Late Payment,A;Up to Pmt Amt
-- @pcCpnyID			- Company Id
-- Plus standard @pcWhat<...> parameters
-- ======================================================================================;

Declare @lcAcctNo			VarCHar(128)	-- account no
Declare @lcLoanName		VarChar(30)		-- loan name
Declare @lcProject		VarChar(20)		-- project
Declare @lcTask				VarChar(32)		-- task
Declare @lcLoanType		VarChar(10)		-- loan type
Declare @lcRelation		VarChar(10)		-- relation
Declare @lcVendCustId			VarChar(20)		-- vendor id
Declare @lcName		VarChar(65)		-- vendor name

Declare @lfInterest		Decimal(28,14) -- interest
Declare @lfOther			Decimal(28,14) -- other
Declare @lfDueAmt			Decimal(28,14) -- amount due

Declare @liLineId			SmallInt			-- line id

Declare @LoanNo							VarChar(20)
Declare @UnpaidInt					Decimal(28,14)
Declare @UnPaidIntCharges		Decimal(28,14)
Declare @UnPaidLateInt			Decimal(28,14)
Declare @UnPaidLateIntOnInt	Decimal(28,14)
Declare @UnpaidCharges			Decimal(28,14)
Declare @UnpaidEscrow				Decimal(28,14)
Declare @UnPaidLateFee			Decimal(28,14)
Declare @UnpaidPrin					Decimal(28,14)
Declare @PmtNbr							SmallInt
Declare @PmtDueDate					SmallDateTime
Declare @lfMaxAmt decimal(28,14)
Declare @VendId				VarChar(15)
Declare @CustId             VarChar(15)
Declare @lfReductAmt decimal(28,14)

Declare @lcHoldLoan  varchar(20)
-- From the Loan

Declare @lfMonthPmt		Decimal(28,14)				--- Amount of monthly Payment

-- ====================================================
-- Declare variables for accounts and subs
-- ====================================================

Declare @lcAcctPPRCr VarChar(128), @lcAcctIPPCr VarChar(128), @lcAcctWPRCr VarChar(128), @lcAcctPPRDr VarChar(128), @lcAcctIPPDr VarChar(128), @lcAcctWPRDr VarChar(128)
Declare @lcSubPPRCr VarChar(24), @lcSubIPPCr VarChar(24), @lcSubWPRCr VarChar(24), @lcSubPPRDr VarChar(24), @lcSubIPPDr VarChar(24), @lcSubWPRDr VarChar(24)

-- ==========================================
-- initialize
-- ==========================================

Set @lfInterest = 0.0000
Set @lfOther		= 0.0000
Set @lfDueAmt		= 0.0000
Set @liLineId		= -32768
Set @lcAcctNo		= ''
Set @lcRelation = ''
Set @lcProject	= ''
Set @lcTask			= ''
--Set @lcLoanType = ''

If RTrim(@pcLoanNo) = '' Set @pcLoanNo = '%'
If RTrim(@pcVendCustId) = '' Set @pcVendCustId = '%'
If RTrim(@pdStartDate) = '' Set @pdStartDate = '01/01/1900'

-- ==================================================================================================================================================================
-- pull out pmt schedule records per pmtduedate <= entered enddate
-- Only include ACTIVE Loans
--
-- IAA - 05/01/2012
--
-- Pull records according to passed into @pcSchedPay
-- For Scheduled "S" – Go to the pmt schedule and find the SCHED amts for that pmt and put them in the grid.
-- For Inlcude Late Pmt "I" – Go to the Pmt Schedule and find the Sched amts and then go to daily interest and pull in the Late Int numbers as of the end date.
-- For up to pmt amt.  "A" Go to the daily  and pull like we do in auto apply - !!! PULS FOR END DATE !!!
-- ==================================================================================================================================================================

--IF @pcSchedPay = 'S' or @pcSchedPay = 'I'  -- For "I" - Late Interest numbers will be pulled from Daily table inside the While loop and ovrrride amounts from this Select
	
	Declare csr_Sched Cursor Static For
		Select pssllpmtsched.LoanNo, 
			round(pssllpmtsched.UnpaidInt,2), 
			round(pssllpmtsched.UnPaidIntCharges,2), 
			round(pssllpmtsched.UnPaidLateInt,2), 
			round(pssllpmtsched.UnPaidLateIntOnInt,2),  
			round(pssllpmtsched.UnpaidCharges,2), 
			round(pssllpmtsched.UnpaidEscrow,2),  
			round(pssllpmtsched.UnPaidLateFee,2), 
			round(pssllpmtsched.UnpaidPrin,2), 
			pssllpmtsched.PmtNbr, 
			pssllpmtsched.PmtDueDate 
		From PSSLLPmtSched (NoLock) , PSSLoanLedger (nolock)
		Where PSSLLPmtSched.LoanNo like @pcLoanNo 
		and PSSLLPmtSched.loanno = PSSLoanLedger.loanno
		and PmtDueDate <= @pdEndDate 
		and ((@pcSchedPay = 'S' and  PmtDueDate >= @pdStartDate)  or @pcSchedPay <> 'S')
		and ((@pcLoanType = 'P' and VendId Like @pcVendCustId) or (@pcLoanType = 'R' and CustId Like @pcVendCustId ))
		And Status = 'A'
		Order By pssllpmtsched.LoanNo, pssllpmtsched.PmtNbr		
	

	-- ==========================================================================================================================
	-- IAA
	-- It seems we still need to pull terms from schedule but pull amounts from Daily table for A type -  Up to pmt amt
	-- Threfore, below in the loop we do it, pulling amounts from daily table
	-- ==========================================================================================================================

--IF @pcSchedPay = 'A'
--	Declare csr_Sched Cursor Static For
--	select Top 1
--		PSSLLDaily.LoanNo,
--		round(IntEnd,2),
--		round(ChargesIntEnd,2), 
--		round(LateIntPrinEnd,2), 
--		round(LateIntonIntEnd,2), 
--		round(ChargesEnd,2) , 
--		round(EscrowEnd,2),
--		round(LateFeeEnd,2), 
--		round(DuePrinEnd,2), 
--		0,
--		CalcIntDate
--		from PSSLLDaily with (nolock) , PSSLoanLedger (nolock)
--		Where PSSLLDaily.LoanNo like @pcLoanNo 
--		and PSSLLDaily.loanno = PSSLoanLedger.loanno
--		and CalcIntDate = @pdEndDate 
--		and ((@pcLoanType = 'R' and VendId Like @pcVendCustId) or (@pcLoanType = 'P' and CustId Like @pcVendCustId ))
--		And Status = 'A'
--		Order By PSSLLDaily.LoanNo
	
-- ===================================================================
-- delete records from temp file
-- ===================================================================

Delete PSSTmpLLGenAPVO Where Crtd_User = @pcWhatUser And Crtd_Prog = @pcWhatProg

-- ===================================================================
-- go thru pmt schedule records
-- ===================================================================

Open csr_Sched
Fetch From csr_Sched Into @LoanNo, @UnpaidInt, @UnPaidIntCharges, @UnPaidLateInt, @UnPaidLateIntOnInt, @UnpaidCharges, @UnpaidEscrow, @UnPaidLateFee, @UnpaidPrin, @PmtNbr, @PmtDueDate

set @lcHoldLoan   = ''

While @@Fetch_Status = 0
	Begin
			
		-- ========================================================================
		-- Make sure we only pull Payable or Receivable Loans
		-- ========================================================================
			
		If Exists (Select * From PSSLoanLedger Where LoanNo = @LoanNo And TypeOfLoan = @pcLoanType)
	
			Begin
			
				-- ==========================================================
				-- IAA - 05/01/20212
				-- Pull Late Interest amounts from Daily table
				-- For "A" - Up to date, pull ALL amounts from daily table.
				-- ==========================================================
				
				IF @pcSchedPay = 'I' or @pcSchedPay = 'A'
					Begin
						Select @UnPaidLateInt = 0.00, @UnPaidLateIntOnInt = 0.00, @UnPaidLateFee = 0.00 -- reset late amounts 
						Select @UnPaidLateInt = round(LateIntPrinEnd,2), @UnPaidLateIntOnInt = round(LateIntonIntEnd,2), @UnPaidLateFee = round(LateFeeEnd,2) From PSSLLDaily Where LoanNo = @LoanNo and CalcIntDate = @PmtDueDate	
					End

				IF  @pcSchedPay = 'A'
					Begin
						Select @UnpaidInt = 0.00, @UnPaidIntCharges = 0.00, @UnpaidCharges = 0.00, @UnpaidEscrow = 0.00, @UnpaidPrin = 0.00 -- reset amounts 
						Select @UnpaidInt = round(IntEnd,2), @UnPaidIntCharges = round(ChargesIntEnd,2), @UnpaidCharges = round(ChargesEnd,2), @UnpaidEscrow = ROUND(EscrowEnd,2), @UnpaidPrin = ROUND(DuePrinEnd,2) From PSSLLDaily Where LoanNo = @LoanNo and CalcIntDate = @PmtDueDate	
					End

				-- ==================================================================================================================		
				-- IAA 
				-- Logic below has not been altered but only adjusted to the current table structures and field names.
				-- ==================================================================================================================		
				
				-- ===============================================
				-- Get payment number from the schedule
				-- ===============================================				

				If @PmtNbr = 0
					Select Top 1 @PmtNbr = PmtNbr From PSSLLPmtSched Where LoanNo = @LoanNo and PmtDueDate <= @PmtDueDate Order By PmtDueDate Desc

				-- ====================================
				-- Restart the Max for the A types
				-- ====================================

				if @lcHoldLoan   <>  @LoanNo
					begin
						Set @lfMaxAmt = 0
						Set @lcHoldLoan = @LoanNo
					end  --if @lcHoldLoan   <>  @LoanNo

				-- ====================================
				-- Get values from Loan Ledger
				-- ====================================

				Select @lcLoanName = Name, @lfMonthPmt = MonthPmt, @VendId = VendId, @CustID = CustID, @lcAcctNo = AcctNo, @lcRelation = Relation, @lcProject = Project, @lcTask = Pjt_Entity, @lcLoanType = LoanTypeCode From PSSLoanLedger (NoLock) Where LoanNo = @LoanNo 
				
				Set @lfInterest = 0.0000
				Set @lfOther		= 0.0000
				Set @lfDueAmt		= 0.0000
				
				-- ====================================================================
				-- store loan name, vendor id, vendor name and account per loan no
				-- GP Vendor Master Table - PM00200
				-- ====================================================================
				
				If Rtrim(@pcVendCustId) <> '' and RTrim(@pcVendCustId) <> '%'
					Set @lcVendCustId = @pcVendCustId
				Else
					If @pcLoanType = 'P'
					  Set @lcVendCustId = @VendId
					Else
					  Set @lcVendCustId = @CustId

				If @pcLoanType = 'P'
					Begin
						If RTrim(@lcVendCustID) <> '' and Exists (Select * from Vendor where VendID = @lcVendCustID)
							Select @lcName = Name from Vendor where VendId = @lcVendCustID
						Else
							SET @lcName = 'MISSING'
					End  --If @pcLoanType = 'P'
				Else				
					Begin
						If RTrim(@lcVendCustID) <> '' and Exists (Select * from Customer where CustID = @lcVendCustID)
							Select @lcName = Name from Customer where CustId = @lcVendCustID
						Else
							SET @lcName = 'MISSING'							
					End --If @pcLoanType = 'P'

	
				-- ==============================================================
				-- summarize all interest due fields (NOT LATE)
				-- ==============================================================
				
				Set @lfInterest = @lfInterest + @UnpaidInt + @UnPaidIntCharges 

				-- ==============================================================
				-- This says to include the late amounts not just the scheduled int
				-- ==============================================================
				
				
				If @pcSchedPay  <> 'S' 
					Set @lfInterest = @lfInterest + @UnPaidLateInt + @UnpaidLateIntOnInt 
				else
					begin
						Set @UnPaidLateInt = 0
						set @UnpaidLateIntOnInt = 0
					end  --If @pcSchedPay  <> 'S' 
					
				-- ==============================================================
				-- Charges Unpaid + Escrow Unpaid + Fee Unpaid
				-- ==============================================================
				
				Set @lfOther = @lfOther + @UnpaidCharges + @UnpaidEscrow 
				
				If @pcSchedPay  <> 'S'
					Set @lfOther  = @lfOther + @UnPaidLateFee
				else
					set @unpaidLateFee  = 0

				-- ==============================================================
				-- Principal + Interest + Other
				-- ==============================================================
				
				Set @lfDueAmt = @lfDueAmt + @UnpaidPrin + @lfInterest + @lfOther

				if @pcSchedPay = 'A' and @lfDueAmt > 0
					Begin
						set @lfMaxAmt = @lfMaxAmt + @lfDueAmt
					
						
						
						if @lfMaxAmt > @lfMonthPmt and @lfMonthPmt <> 0
							Begin
								Set @lfReductAmt = (@lfMaxAmt - @lfMonthPmt)
								Set @lfDueAmt = @lfDueAmt - @lfReductAmt
								if @lfReductAmt  > @lfOther
									Begin
										Set @lfOther = 0
										Set @lfReductAmt = @lfReductAmt - @lfOther
									end  --if @lfReductAmt  > @lfOther
								else
									Begin
										Set @lfOther = @lfOther - @lfReductAmt
										Set @lfReductAmt = 0
									end  --if @lfReductAmt  > @lfOther
								if @lfReductAmt  > @UnpaidPrin
									Begin
										Set @UnpaidPrin = 0
										Set @lfReductAmt = @lfReductAmt  - @UnpaidPrin
									end  --if @lfReductAmt  > @UnpaidPrin
								else
									Begin
										Set @UnpaidPrin = @UnpaidPrin - @lfReductAmt
										Set @lfReductAmt = 0
									end  --if @lfReductAmt  > @UnpaidPrin

								if @lfReductAmt  > @lfInterest
									Begin
										Set @lfInterest = 0
										Set @lfReductAmt = @lfReductAmt - @lfInterest
									end  --if @lfReductAmt  > @lfInterest
								else
									Begin
										Set @lfInterest = @lfInterest - @lfReductAmt
										Set @lfReductAmt = 0
									end  --if @lfReductAmt  > @lfInterest
						end  --if @lfMaxAmt > @lfMonthPmt and @lfMonthPmt <> 0
				End		--if @pcSchedPay = 'A'

			End
			
		Else

			Begin
				Set @lfInterest = 0.0000
				Set @lfOther		= 0.0000
				Set @lfDueAmt		= 0.0000
				Set @lcLoanName = ''
				Set @lcVendCustId		= ''
				Set @lcName = ''
				Set @lcAcctNo		= ''
				Set @lcRelation = ''
				Set @lcProject	= ''
				Set @lcTask			= ''
				Set @lcLoanType = ''
			End 
	
			
		
			
		If Round(@lfDueAmt,2) > 0.00

			Begin	
			
			
				-- ======================================================================================================
				-- Get accounts and sub for possible PPR, IPP and WPR amounts that could be posted on AP-AR screen.
				-- ======================================================================================================
				
				Select @lcAcctIPPCr = '', @lcAcctPPRCr = '', @lcAcctWPRCr = '', @lcSubIPPCr = '', @lcSubPPRCr = '', @lcSubWPRCr = '', @lcAcctIPPDr = '', @lcAcctPPRDr = '', @lcAcctWPRDr = '', @lcSubIPPDr = '', @lcSubPPRDr = '', @lcSubWPRDr = ''
				
				Exec dbo.PSS_spLL_GetTranAcct 'PRINCIPAL', @LoanNo, @lcAcctPPRDr  Output, @lcSubPPRDr  Output, @lcAcctPPRCr  Output, @lcSubPPRCr  Output
				Exec dbo.PSS_spLL_GetTranAcct 'INTEREST', @LoanNo, @lcAcctIPPDr  Output, @lcSubIPPDr  Output, @lcAcctIPPCr  Output, @lcSubIPPCr  Output
				Exec dbo.PSS_spLL_GetTranAcct 'ESCROW', @LoanNo, @lcAcctWPRDr  Output, @lcSubWPRDr  Output, @lcAcctWPRCr  Output, @lcSubWPRCr  Output
				
				-- ==============================================================
				-- insert records to temp table
				-- ==============================================================

				Insert Into PSSTmpLLGenAPVO 
					(AcctNo, CpnyID, LoanNo, LoanName, VendId, VendName, Relation, Project, DueDate, Principal, Interest, Other, DueAmt, LineId, Process, PmtNbr, 
						Pjt_Entity, LoanTypeCode,Crtd_DateTime, Crtd_Prog, Crtd_User, LUpd_DateTime, LUpd_Prog, LUpd_User,UnPaidLateInt,UnpaidLateIntOnInt,
						UnPaidLIOLI,UnpaidEscrow,UnpaidCharges,UnpaidIntCharges,UnpaidLateFee,
						AcctPPRCr,SubPPRCr,AcctPPRDr,SubPPRDr,AcctIPPCr,SubIPPCr,AcctIPPDr,SubIPPDr,AcctWPRCr,SubWPRCr,AcctWPRDr,SubWPRDr )
				Values (@lcAcctNo, @pcCpnyID, @LoanNo, @lcLoanName, @lcVendCustId, @lcName, @lcRelation, @lcProject, @PmtDueDate, @UnpaidPrin, @lfInterest, @lfOther, @lfDueAmt, @liLineId, 0, @PmtNbr, @lcTask, @lcLoanType,
					CAST(CONVERT(CHAR(8),GetDate(),112) as SmallDateTime), @pcWhatProg, @pcWhatUser, CAST(CONVERT(CHAR(8),GetDate(),112) as SmallDateTime), @pcWhatProg, @pcWhatUser,  @UnPaidLateInt, @UnpaidLateIntOnInt,  0,
					@UnpaidEscrow, @UnpaidCharges, @UnpaidIntCharges, @UnpaidLateFee,
					@lcAcctPPRCr,@lcSubPPRCr,@lcAcctPPRDr,@lcSubPPRDr,@lcAcctIPPCr,@lcSubIPPCr,@lcAcctIPPDr,@lcSubIPPDr,@lcAcctWPRCr,@lcSubWPRCr,@lcAcctWPRDr,@lcSubWPRDr	)
	
			End -- lfDueAmt > 0
			
		Fetch Next From csr_Sched Into @LoanNo, @UnpaidInt, @UnPaidIntCharges, @UnPaidLateInt, @UnPaidLateIntOnInt,  @UnpaidCharges, @UnpaidEscrow, @UnPaidLateFee, @UnpaidPrin, @PmtNbr,  @PmtDueDate
			
		Set @liLineId = @liLineId + 1
			
	End -- While		--While @@Fetch_Status = 0
		
Close csr_Sched
Deallocate csr_Sched
GO
