USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_spLL_CalcLoanAmtsPaid]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSS_spLL_CalcLoanAmtsPaid] @pcLoanNo VARCHAR(20) AS

 Set Nocount On

Declare @lcLoanDayCount varchar(1)
Declare @lcLoanPmtFreq  varchar(1)
  
Declare @UnpaidPrin    As Float	
Declare @UnpaidInt     As Float
Declare @UnpaidLateInt As Float	
Declare @UnpaidCharges As Float	
Declare @UnPaidEscrow  As Float
Declare @UnPaidTotal   As Float
Declare @PaidPrin      As Float
Declare @PaidInt       As Float
Declare @PaidLateInt   As Float
Declare @PaidCharges   As Float
Declare @PaidEscrow    As Float
Declare @PaidTotal     As Float
Declare @DuePrin       As Float
Declare @DueInt        As Float
Declare @DueLateInt    As Float
Declare @DueCharges    As Float
Declare @DueEscrow     As Float
Declare @DueTotal      As Float
Declare @CurBal        As Float
Declare @LoanAmt       as float
DECLARE @LoanDate      AS SMALLDATETIME
Declare @CurIss        As Float
Declare @CurPd         As Float
Declare @CreditType    as Char
Declare @lfAuthLoanAMt as float
declare @lfLoanOutStanding as decimal(28,14)
Declare @lfIntRate  Decimal(28,14)
Declare @lcDayCount varchar(1)
Declare @lcPmtFreq  varchar(1)
Declare @liTermToMat int
Declare @ldToday                  SmallDateTIme				-- Current Date
Declare @lfIntEnd decimal(28,14)
Declare @lfIntAccr Decimal(28,14)
Declare @ldAccrDate  smalldatetime
Declare @lcAccrPost  varchar(6)

Set @ldToday = CAST( CONVERT( CHAR(8), GetDate(), 112) AS SMALLDATETIME) 

--=========================================================================
-- Get the Defaults from the Loan Ledger file
--=========================================================================

Select top 1
	@Credittype = isnull(credittype, 'N'),
    @lfAuthLoanAmt  = AuthLoanAmt,
    @lcLoanPmtFreq = PmtFreq,
    @lcLoanDayCount = DayCount
 from pssloanledger WHERE LoanNo = @pcLoanNo
   
--=========================================================================
-- What is the last Pmt Nbr in the Schedule
--=========================================================================
   
set @liTermToMat = ISNULL((Select MAX(pmtNbr) from PSSLLPmtSched where LoanNo = @pcLoanNo),0)

--=========================================================================
-- Add on combines Int and Principal
--=========================================================================

--if rtrim(@CreditType) = 'A'  
--begin
--  Set @CurIss     = (Select IsNull(Sum(SchedPrin + SchedInt) ,0)   From PSSLLPmtSched WHERE LoanNo = @pcLoanNo)
--  Set @CurPd     = (Select IsNull(Sum(TranAmt) ,0)   From PSSLLTran WHERE LoanNo = @pcLoanNo and (PmtType like 'PP%'  or PmtTYpe like 'IP%') and pmttype <> 'IPC' and  Transtatus = 'P' )
--end

--=========================================================================
-- Standard Loan does not.
--=========================================================================

if rtrim(@creditType) <> 'A' 
begin

  Set @CurIss    = (Select Sum(TranAmt) From PSSLLTran WHERE LoanNo = @pcLoanNo and PmtType = 'PIR' AND Transtatus = 'P')
  Set @CurPd     = (Select Sum(TranAmt) From PSSLLTran WHERE LoanNo = @pcLoanNo and PmtType like 'PP%'  AND Transtatus = 'P' )
end
    
    
set @CurIss = ISNULL(@curiss,0)
set @CurPd  = ISNULL(@curPd,0)
    

--===============================================================================        
-- Get LTD Acccrual
--===============================================================================        

   
Set @lfIntAccr     = (Select Sum(TranAmt)    From PSSLLTran WHERE LoanNo = @pcLoanNo and PmtType like 'IA%'  AND Transtatus = 'P' )
set @lfIntAccr = ISNULL(@lfIntAccr,0)
  
  
    
--===============================================================================        
-- Get the Paid Amounts
-- Get Total Due from Daily Int
--===============================================================================    

select
@lcPmtFreq =isnull(PmtFreq,@lcLoanPmtFreq), 
@lcDayCount = isnull(DayCount, @lcLoanDayCount),
@lfintrate = isnull(IntRate,0),
@lfIntEnd = isnull(IntEnd,0),
@PaidCharges = isnull(ChargesTotPaid,0),
@PaidEscrow  = isnull(EscrowTOtPaid, 0.0),
@PaidInt  = isnull(IntTOtPaid + ChargesIntTOtPaid,0),
@PaidLateInt  = isnull(LateIntPrinTOtPaid,0),
@PaidPrin  = isnull(PrinTotPaidAdd + PrinTotPaidREg,0),
@DuePrin = isnull(DuePrinTotNew,0),
@DueInt = isnull(DueIntTotNew + ChargesIntTotNew,0),
@DueLateInt = isnull(LateIntPrinTotNew,0),
@DueCharges = isnull(ChargesTotNew,0),
@DueEscrow = isnull(EscrowTotNew,0)
from PSSLLDaily 
where LoanNo = @pcLoanNo and CalcIntdate = @ldtoday


set @lcPmtFreq =isnull(@lcPmtFreq,@lcLoanPmtFreq)
set @lcDayCount = isnull(@lcDayCount, @lcLoanDayCount)
set @lfintrate = isnull(@lfIntRate,0)
set @lfIntEnd = isnull(@lfIntEnd,0)
set @PaidCharges = isnull(@PaidCharges,0)
set @PaidEscrow  = isnull(@PaidEscrow  , 0.0)
set @PaidInt  = isnull(@PaidInt  ,0)
set @PaidLateInt  = isnull(@PaidLateInt  ,0)
set @PaidPrin  = isnull(@PaidPrin  ,0)
set @DuePrin = isnull(@DuePrin ,0)
set @DueInt = isnull(@DueInt ,0)
set @DueLateInt = isnull(@DueLateInt ,0)
set @DueCharges = isnull(@DueCharges ,0)
set @DueEscrow = isnull(@DueEscrow ,0)

--===============================================================================    
-- Total of all
--===============================================================================    

Set @PaidTotal   = IsNull(@PaidCharges, 0.00)+ IsNull(@PaidEscrow, 0.00) + IsNull(@PaidInt, 0.00) + IsNull(@PaidPrin, 0.00)+ IsNull(@PaidLateInt, 0.00)
Set @DueTotal   = IsNull(@DueCharges, 0.00)+ IsNull(@DueEscrow, 0.00) + IsNull(@DueInt, 0.00) + IsNull(@DuePrin, 0.00)+ IsNull(@DueLateInt, 0.00)
Set @UnpaidPrin    = @CurIss - @CurPd


--===============================================================================    
-- Schedule Type is different
--===============================================================================    

  if rtrim(@CreditType) = 'S'  
  Begin
	Set @UnpaidInt     = (Select IsNull(Sum((SchedInt+owedIntCharges)-(PaidInt+PaidIntCharges)),0)       From PSSLLPmtsched WHERE LoanNo = @pcLoanNo)
  End

set @UnpaidInt = ISNULL(@unpaidint,0)

  if rtrim(@CreditType) <> 'S'  
  Begin
	Set @UnpaidLateInt = @DueLateInt - @PaidLateInt
	Set @UnpaidInt = @DueInt -@paidint
  
  End
  else
  begin
	Set @UnpaidLateInt = 0
	Set @UnpaidInt = @DueInt - @PaidInt
  
  end

  Set @UnpaidCharges = @DueCharges - @PaidCharges
  Set @UnpaidEscrow  = @DueEscrow  - @PaidEscrow
  Set @UnPaidTotal   = IsNull(@UnPaidCharges, 0.00)+ IsNull(@UnPaidEscrow, 0.00) + IsNull(@lfIntENd , 0.00) + IsNull(@UnPaidPrin, 0.00)+ IsNull(@UnPaidLateInt, 0.00)
  
-- Why this is in cury when other is not not sure...
  Set @LoanAmt =  @CurISS  --(Select IsNull(Sum(curytranamt),0) From PSSLLTran WHERE LoanNo = @LoanNo and PmtType = 'PIR')
  SET @LoanDate = isnull((SELECT Min(TranDate) FROM PSSLLTran WHERE PmtType = 'PIR' and LoanNo = @pcLoanNo and tranamt <> 0), '01/01/1900')
  select 
	@ldAccrDate = MAX(TranDate),
	@lcAccrPost = MAX(perPost)
from PSSLLTran
where SUBSTRING(pmttype,1,2) = 'IA'
and LoanNo = @pcLoanNo
and TranStatus = 'P'


set @ldAccrDate = ISNULL(@ldAccrdate, '01/01/1900')
set @lcAccrpost = ISNULL(@lcAccrpost, '')
  
  

  IF @LoanDate <> '01/01/1900'
    UPDATE PSSLoanLedger SET LoanDate = @LoanDate, LoanAmt = @LoanAmt WHERE LoanNo = @pcLoanNo AND Status <> 'P'

  if @lfAuthLoanAMt <> 0
	set @lfLoanOutstanding = (@UnpaidPrin/@lfAuthLoanAmt) * 100
	else
		set @lfLoanoutstanding = 100

  
  --if @UnPaidPrin < 0 set @UnPaidPrin  = 0
 
  Update PSSLoanLedger
    Set PaidPrin = @PaidPrin, 
    PaidInt = @PaidInt, 
    PaidLateInt = @PaidLateInt,
    PaidCharges = @PaidCharges,
    PaidEscrow = @PaidEscrow,
    PaidTotal = @PaidTotal,
    DuePrin = @DuePrin, 
    DueInt = @DueInt, 
    DueLateInt = @DueLateInt,
    DueCharges = @DueCharges,
    DueEscrow = @DueEscrow,
    DueTotal = @DueTotal,
    UnPaidPrin = @UnPaidPrin, 
    UnPaidInt = @lfIntend,
    UnPaidLateInt = @UnPaidLateInt,
    UnpaidCharges = @UnpaidCharges,
    UnPaidEscrow = @UnPaidEscrow,
    UnPaidTotal = @UnpaidTotal,
    CurBal = @CurIss - @CurPd ,
    LoanOutstanding = @lfLoanOutStanding,
    --IntRate  = @lfIntRate,
	DayCount = @lcDayCount,
	PmtFreq = @lcPmtFreq,
	--TermToMat = @liTermToMat,
	IntLastAccrDate= @ldAccrDate,
	IntLastAccr = @lcAccrpost,
	IntAccrued = @lfIntAccr
    WHERE LoanNo = @pcLoanNo
GO
