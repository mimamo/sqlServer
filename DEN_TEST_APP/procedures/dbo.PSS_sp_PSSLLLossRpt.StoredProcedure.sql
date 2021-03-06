USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSS_sp_PSSLLLossRpt]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSS_sp_PSSLLLossRpt] @RI_ID INTEGER, @PerPost VARCHAR(6) AS

  SET NOCOUNT ON
  SET ANSI_WARNINGS OFF

  DELETE FROM PSSLLLossTmp WHERE RI_ID = @RI_ID

  -- DECLARE variables used FROM the setup table
  DECLARE @SuspendIntDays INTEGER
  SET @SuspendIntDays = (SELECT TOP 1 SuspendIntDays FROM PSSLLSetup)

  -- DECLARE variable used to determine the last day of the period
  DECLARE @PerPostDate SMALLDATETIME
  SET @PerPostDate = CONVERT(SMALLDATETIME, 
                          CASE RIGHT(@PerPost, 2)
                            WHEN '01' THEN (SELECT LEFT(FiscalPerEnd00, 2) + '/' + RIGHT(FiscalPerEnd00, 2) FROM GLSetup)
                            WHEN '02' THEN (SELECT LEFT(FiscalPerEnd01, 2) + '/' + RIGHT(FiscalPerEnd01, 2) FROM GLSetup)
                            WHEN '03' THEN (SELECT LEFT(FiscalPerEnd02, 2) + '/' + RIGHT(FiscalPerEnd02, 2) FROM GLSetup)
                            WHEN '04' THEN (SELECT LEFT(FiscalPerEnd03, 2) + '/' + RIGHT(FiscalPerEnd03, 2) FROM GLSetup)
                            WHEN '05' THEN (SELECT LEFT(FiscalPerEnd04, 2) + '/' + RIGHT(FiscalPerEnd04, 2) FROM GLSetup)
                            WHEN '06' THEN (SELECT LEFT(FiscalPerEnd05, 2) + '/' + RIGHT(FiscalPerEnd05, 2) FROM GLSetup)
                            WHEN '07' THEN (SELECT LEFT(FiscalPerEnd06, 2) + '/' + RIGHT(FiscalPerEnd06, 2) FROM GLSetup)
                            WHEN '08' THEN (SELECT LEFT(FiscalPerEnd07, 2) + '/' + RIGHT(FiscalPerEnd07, 2) FROM GLSetup)
                            WHEN '09' THEN (SELECT LEFT(FiscalPerEnd08, 2) + '/' + RIGHT(FiscalPerEnd08, 2) FROM GLSetup)
                            WHEN '10' THEN (SELECT LEFT(FiscalPerEnd09, 2) + '/' + RIGHT(FiscalPerEnd09, 2) FROM GLSetup)
                            WHEN '11' THEN (SELECT LEFT(FiscalPerEnd10, 2) + '/' + RIGHT(FiscalPerEnd10, 2) FROM GLSetup)
                            WHEN '12' THEN (SELECT LEFT(FiscalPerEnd11, 2) + '/' + RIGHT(FiscalPerEnd11, 2) FROM GLSetup)
                            WHEN '13' THEN (SELECT LEFT(FiscalPerEnd12, 2) + '/' + RIGHT(FiscalPerEnd12, 2) FROM GLSetup)
                          END + '/' + LEFT(@PerPost, 4))

  -- DECLARE variables used by the loan cursor
  DECLARE @LoanNo             VARCHAR(20)
  DECLARE @LoanTypeCode       VARCHAR(10)
  DECLARE @LoanDate           SMALLDATETIME
  DECLARE @TranTypeS          FLOAT
  DECLARE @TranTypeP          FLOAT
  DECLARE @TranTypeO          FLOAT
  DECLARE @TranTypeI          FLOAT
  DECLARE @TranTypeR          FLOAT
  DECLARE @TranTypeSCury      FLOAT
  DECLARE @TranTypePCury      FLOAT
  DECLARE @TranTypeOCury      FLOAT
  DECLARE @TranTypeICury      FLOAT
  DECLARE @TranTypeRCury      FLOAT

  -- DECLARE variables used to perform calculations
  DECLARE @FirstMissedPmtDte  SMALLDATETIME

  -- DECLARE variables used to populate the temporary table
  DECLARE @PrinBalClose       FLOAT
  DECLARE @PrinBalCloseCury   FLOAT
  DECLARE @IntBalClose        FLOAT
  DECLARE @IntBalCloseCury    FLOAT
  DECLARE @NbrLateDays        SMALLINT
  DECLARE @NbrLateMo          SMALLINT
  DECLARE @SuspendIntAmt      FLOAT
  DECLARE @SuspendIntAmtCury  FLOAT
  DECLARE @LoanLossPercent    FLOAT

  -- Initialize the temporary table
  DELETE FROM PSSLLLossTmp WHERE RI_ID = @RI_ID

  -- DECLARE the cursor used to pull the basic loan transactions
  --  INNER JOIN PSSLLPmtSched SCH  ON (LL.LoanNo = SCH.LoanNo)
  DECLARE LOAN_CURSOR CURSOR FAST_FORWARD FOR
  SELECT
    ISNULL(LL.LoanNo, '')           [LoanNo],
    ISNULL(LL.LoanTypeCode, '')     [LoanTypeCode],
    ISNULL(LL.LoanDate, '')         [LoanDate]
    FROM PSSLoanLedger LL
    WHERE LL.LoanDate <= @PerPostDate
    ORDER BY LL.LoanDate, LL.LoanNo

  OPEN LOAN_CURSOR

  FETCH NEXT FROM LOAN_CURSOR 
  INTO @LoanNo, @LoanTypeCode, @LoanDate

  WHILE @@FETCH_STATUS = 0
  BEGIN -- @@FETCH_STATUS = 0

    SET @TranTypeSCury = (SELECT ISNULL(SUM(CuryTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND PmtType = 'PIR')
    SET @TranTypeS     = (SELECT ISNULL(SUM(BaseTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND PmtType = 'PIR')
    SET @TranTypePCury = (SELECT ISNULL(SUM(CuryTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND left(PmtType,2) = 'PP')
    SET @TranTypeP     = (SELECT ISNULL(SUM(BaseTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND left(PmtType,2) = 'PP')
    SET @TranTypeOCury = (SELECT ISNULL(SUM(CuryTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND (left(PmtType,2) = 'IO' OR PmtTypeCode = 'LINTDUE' OR PmtTypeCode = 'IINTDUE' OR PmtTypeCode = 'CINTDUE'))
    SET @TranTypeO     = (SELECT ISNULL(SUM(BaseTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND (left(PmtType,2) = 'IO' OR PmtTypeCode = 'LINTDUE' OR PmtTypeCode = 'IINTDUE' OR PmtTypeCode = 'CINTDUE'))
    SET @TranTypeICury = (SELECT ISNULL(SUM(CuryTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND left(PmtType,2) = 'IP' and pmttype <> 'IPC')
    SET @TranTypeI     = (SELECT ISNULL(SUM(BaseTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND left(PmtType,2) = 'IP'and pmttype <> 'IPC')
    SET @TranTypeRCury = (SELECT ISNULL(SUM(CuryTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND PmtType = 'IPC')
    SET @TranTypeR     = (SELECT ISNULL(SUM(BaseTranAmt), 0.00) FROM PSSLLTran WHERE LoanNo = @LoanNo AND PerPost <= @PerPost AND PmtType = 'IPC')

    SET @PrinBalClose     = ISNULL(@TranTypeS, 0.00)     - ISNULL(@TranTypeP, 0.00)
    SET @PrinBalCloseCury = ISNULL(@TranTypeSCury, 0.00) - ISNULL(@TranTypePCury, 0.00)
    SET @IntBalClose      = ISNULL(@TranTypeO, 0.00)     - ISNULL(@TranTypeI, 0.00)     - ISNULL(@TranTypeR, 0.00)
    SET @IntBalCloseCury  = ISNULL(@TranTypeOCury, 0.00) - ISNULL(@TranTypeICury, 0.00) - ISNULL(@TranTypeRCury, 0.00)

    -- Get the first missed payment date
    SET @FirstMissedPmtDte = (SELECT MIN(SCH.PmtDueDate) FROM PSSLLPmtSched SCH WHERE SCH.LoanNo = @LoanNo AND (SCH.UnpaidPrin + Sch.UnpaidCharges + Sch.UnpaidInt) > 0)

    -- Calculate the number of late days
    SET @NbrLateDays = DATEDIFF(dd, @FirstMissedPmtDte, @PerPostDate)
    IF @NbrLateDays < 0 SET @NbrLateDays = 0
      SET @NbrLateDays = ISNULL(@NbrLateDays, 0)

    -- Calculate the number of late months
    SET @NbrLateMo = DATEDIFF(mm, @FirstMissedPmtDte, @PerPostDate)
    IF @NbrLateMo < 0 SET @NbrLateMo = 0
      SET @NbrLateMo = ISNULL(@NbrLateMo, 0)

    -- Calculate the suspended interest amount
    IF @NbrLateDays >= @SuspendIntDays
      SET @SuspendIntAmt = @IntBalClose
    ELSE
      SET @SuspendIntAmt = 0.00
    SET @SuspendIntAmt = ISNULL(@SuspendIntAmt, 0)

    -- Calculate the suspended interest amount
    IF @NbrLateDays >= @SuspendIntDays
      SET @SuspendIntAmtCury = @IntBalCloseCury
    ELSE
      SET @SuspendIntAmtCury = 0.00
    SET @SuspendIntAmtCury = ISNULL(@SuspendIntAmtCury, 0)

    -- Get the loan loss percent FROM the PSSLoanLossPerc table based on the number of days late
    SET @LoanLossPercent = ISNULL((SELECT LossPerc FROM PSSLoanLossPerc WHERE @NbrLateMo >= StartMonth AND @NbrLateMo < EndMonth), 0.00)

    -- Insert the values into the temporary table
    INSERT INTO PSSLLLossTmp
      (RI_ID,  LoanNo,  LoanTypeCode,  NbrLateDays,  NbrLateMo,  PrinBalClose,   PrinBalCloseCury,  IntBalClose,  IntBalCloseCury,  SuspendIntAmt,  SuspendIntAmtCury,  LoanLossPercent)
      VALUES
      (@RI_ID, @LoanNo, @LoanTypeCode, @NbrLateDays, @NbrLateMo, @PrinBalClose,  @PrinBalCloseCury ,@IntBalClose, @IntBalCloseCury, @SuspendIntAmt, @SuspendIntAmtCury, @LoanLossPercent)

    -- Get the next loan
    FETCH NEXT FROM LOAN_CURSOR 
    INTO @LoanNo, @LoanTypeCode, @LoanDate

  END -- @@FETCH_STATUS = 0

  CLOSE LOAN_CURSOR
  DEALLOCATE LOAN_CURSOR
GO
