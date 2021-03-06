USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_spLL_PSSLLPmtRev]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PSS_spLL_PSSLLPmtRev] 
@pcBatNbr VarChar(10), 
@piCpnyIdGP SmallInt, 
@pcCpnyIdSL varchar(10), 
@pcPerPost VarChar(6) = '', 
@pcWhatUser VarChar(50), 
@pcWhatProg varchar(10) ='', 
@pcWhatSystem varchar(2)= 'SL', 
@pcNewBatNbr VarChar(10) = '' output, 
@pcErrMsg VarChar(1) = '0' output,
@piSelect SmallInt = 0

 --WITH ENCRYPTION 
AS

Set Nocount On

-- ===============================================================================================================================
-- 
-- IAA - 04/18/2012
-- Created.
-- Reveses LMS Payment batch.
-- 
-- ===============================================================================================================================

Declare @BatDescr			VarChar(60)
Declare @lfReverseAmt	Decimal(28,14)
Declare @TranAmt			Decimal(28,14)
Declare @BaseTranAmt	Decimal(28,14)
Declare @CuryTranAmt	Decimal(28,14)
Declare @lfRevBaseAmt	Decimal(28,14)
Declare @lfRevCuryAmt	Decimal(28,14)
Declare @ReceiptNo		VarChar(10)
Declare @Count				SmallInt
Declare @ldToday      SmallDateTIme				-- Current Date
Declare @lcRefNbr			VarChar(10)
Declare @lcReceiptNo	VarChar(10)
Declare @lcLoanNo			VarChar(20)

-- ===================================================
-- Declare variables for original batch
-- ===================================================

Declare @lcCuryID varchar(4) 	
Declare @lcCuryRateType varchar(10) 
Declare @ldCuryEffDate smalldatetime

Set @ldToday = CAST( CONVERT( CHAR(8), GetDate(), 112) AS SMALLDATETIME)
Set @Count = 0

-- ====================================================================
-- Make sure the batch has not been reversed yet
-- ====================================================================

Set @Count = (Select Count(*) From PSSLLTran Where  RetroApply = 1 and BatNbr = @pcBatNbr )

If @Count <> 0 
	Begin
		Set @pcErrMsg = '1' -- Batch already reversed
		Return
	end

-- ============================
-- Get receipt number
-- ============================

Set @lcReceiptNo = ''
Select @lcReceiptNo = ReceiptNo, @lcLoanNo = LoanNo From PSSLLPmtHdr Where RefNbr = @pcBatNbr

-- ======================================================
-- Pull some fields from the original batch
-- ======================================================

Select @lcCuryID = '', @lcCuryRateType = '', @ldCuryEffDate = ''
Select @lcCuryID = CuryID, @lcCuryRateType = CuryRateType, @ldCuryEffDate = CuryEffDate From PSSLLTranHdr Where BatNbr = @pcBatNbr

-- ====================================================================
-- Begin Transaction
-- ====================================================================

Begin Tran tx_Tran

	-- ===================================================================
	-- Add a New Batch
	-- ====================================================================

	Set @BatDescr = 'Reversal of Batch ' + @pcBatNbr
	Exec pss_sill_PSSLLTranHdr @pcNewBatNbr Output, 'P', 'C', @pcPerPost, @BatDescr, @pcCpnyIDSL, @piCpnyIDGP,  @lcCuryID,	@lcCuryRateType ,'N', @pcWhatProg  ,@pcWhatUser, @ldCuryEffDate, @pcWhatSystem

	-- ==========================================================
	-- Update transaction in Payment Header record
	-- ==========================================================
	
	Update PSSLLPmtHdr Set TranDesc = 'Reversed by Batch # ' + @pcNewBatNbr  Where RefNbr = @pcBatNbr
	
	-- ==================================================================================
	-- Create a new Payment RefNbr that will match the reversed batct number
	-- ==================================================================================
	
	Set @BatDescr = 'Reversing Batch # ' + @pcBatNbr

	Insert Into PSSLLPmtHdr ([BaseCuryId],[BaseMultDiv],[BaseRate],[BaseRateType],[BaseTranAmt],[BaseTranFees]
		,[CheckNo],[CpnyId],[Crtd_DateTime],[Crtd_Prog],[Crtd_User],[CuryEffDate],[CuryId],[CuryMultDiv],[CuryRate],[CuryRateType]
		,[CuryTranAmt],[CuryTranFees],[DepBatNbr],[DepLineNbr],[EffDate],[EntCuryId],[EntRateType],[LoanNo]
		,[LUpd_DateTime],[LUpd_Prog],[LUpd_User],[PerPost],[PmtNbr],[PmtType],[ReceiptNo],[RefNbr],[TranAmt],[TranDate],[TranDesc]
		,[TranFees],[TranStatus])
	Select [BaseCuryId],[BaseMultDiv],[BaseRate],[BaseRateType],([BaseTranAmt] * -1),[BaseTranFees]
		,[CheckNo],[CpnyId],@ldToday, @pcWhatProg, Left(@pcWhatUser,10),[CuryEffDate],[CuryId],[CuryMultDiv],[CuryRate],[CuryRateType]
		,([CuryTranAmt] * -1),[CuryTranFees],[DepBatNbr],[DepLineNbr],[EffDate],[EntCuryId],[EntRateType],[LoanNo]
		,@ldToday, @pcWhatProg, Left(@pcWhatUser,10),[PerPost],[PmtNbr],[PmtType],[ReceiptNo],@pcNewBatNbr,([TranAmt] * -1),[TranDate],@BatDescr
		,[TranFees],'P'	
	From PSSLLPmthdr Where LoanNo = @lcLoanNo and RefNbr = @pcBatNbr

	-- ====================================================================
	-- Go thru the batch
	-- ====================================================================

	Declare csr_Tran Cursor Static For
		Select ReceiptNo, TranAmt, RefNbr, BaseTranAmt, CuryTranAmt From PSSLLTran Where Batnbr = @pcBatNbr Order By RefNbr

	Open csr_Tran
	Fetch Next From csr_Tran Into @ReceiptNo, @TranAmt, @lcRefNbr, @BaseTranAmt, @CuryTranAmt


	While @@Fetch_Status = 0

		Begin

		-- ====================================================================
		-- Add a new line matching that line with negative amount
		-- ====================================================================

		Set @lfReverseAmt = Round(@TranAmt * Cast(-1 as Decimal(28,14)), 2)
		Set @lfRevBaseAmt = Round(@BaseTranAmt * Cast(-1 as Decimal(28,14)), 2)
		Set @lfRevCuryAmt = Round(@CuryTranAmt * Cast(-1 as Decimal(28,14)), 2)
		
			If RTrim(@ReceiptNo) <> ''
				Set @BatDescr = 'Reverse of Receipt: ' + RTrim(@ReceiptNo)
			Else
				Set @BatDescr = 'Reverse of Batch: ' + RTrim(@pcBatNbr)

		
			Insert Into PSSLLTran (TranAmt, BaseTranAmt, CuryTranAmt,  TranDescr, TranStatus, PerPost, PostBatNbr, PostModule, PostRefNbr, BatNbr, RetroApply,
				BaseCuryId, BaseMultDiv, BaseRate, BaseRateType, CheckNo, CpnyId, CrAcct, CrSub, CuryEffDate, CuryId, CuryMultDiv, CuryRate, CuryRateType, 
				DrAcct, DrSub, EffDate, EntCuryID, EntRateType, LoanNo, PmtType, PmtTypeCode, ReceiptNo, RefNbr, TranDate, crtd_datetime, crtd_prog, crtd_user, Lupd_DateTime, Lupd_Prog, Lupd_User)
			Select  @lfReverseAmt, @lfRevBaseAmt, @lfRevCuryAmt, @BatDescr, 'P', PerPost, '', '', '', @pcNewBatNbr, 1,
				BaseCuryId, BaseMultDiv, BaseRate, BaseRateType, CheckNo, CpnyId, CrAcct, CrSub, CuryEffDate, CuryId, CuryMultDiv, CuryRate, CuryRateType, 
				DrAcct, DrSub, EffDate, EntCuryID, EntRateType, LoanNo, PmtType, PmtTypeCode, ReceiptNo, RefNbr, TranDate, @ldToday, @pcWhatProg, Left(@pcWhatUser,10), @ldToday, @pcWhatProg, Left(@pcWhatUser,10)
			  From PSSLLTran Where Batnbr = @pcBatNbr and RefNbr = @lcRefNbr

			Fetch Next From csr_Tran Into @ReceiptNo, @TranAmt, @lcRefNbr, @BaseTranAmt, @CuryTranAmt

		End -- While

	Close csr_Tran
	Deallocate csr_Tran
	
	-- ==============================================================
	-- Add reversal (negative) amounts into PSSAppPmt table
	-- ==============================================================
	
	Insert Into PSSLLAppPmt (BatNbr, Crtd_DateTime, Crtd_Prog, Crtd_User, LoanNo, Lupd_DateTime, Lupd_Prog, Lupd_User, PmtNbr, PmtType, PmtTypeCode,
		RefNbr, TranAmt, TranDate)
	Select @pcNewBatNbr, @ldToday, @pcWhatProg, @pcWhatUser, @lcLoanNo, @ldToday, @pcWhatProg, @pcWhatUser, PmtNbr, PmtType, PmtTypeCode,
		RefNbr, (TranAmt * -1), @ldToday
		From PSSLLAppPmt Where BatNbr = @pcBatNbr and LoanNo = @lcLoanNo

Commit Tran tx_Tran

	-- ====================================================================
	-- Complete and post transactions
	-- ====================================================================

	--Exec FinishTran 'O', @pcNewBatNbr, @liPerPost, 'Reverse of the Receipt', 'R', 'LL03000', @pcWhatUser, @piCpnyId
	Exec pss_spLL_FinishLLTran 'O', @pcNewBatNbr, 'Reverse of Batch', 'R',@piCpnyIdGP, @pcWhatUser,  @pcWhatProg, @pcWhatSystem 

Begin Tran tx_Upd

-- ======================================================================
-- Mark the old transactions as reversed
-- ======================================================================

Update PSSLLTran Set RetroApply = 1 Where BatNbr = @pcBatNbr

-- ======================================================================
-- Add word Reversed into beginning of descr of original batch.
-- ======================================================================

Update PSSLLTranHdr Set TranDescr = Left('Reversed ' + RTrim(TranDescr),60) Where BatNbr = @pcBatNbr

Commit Tran tx_Upd

If @piSelect = 1 Select @pcNewBatNbr
GO
