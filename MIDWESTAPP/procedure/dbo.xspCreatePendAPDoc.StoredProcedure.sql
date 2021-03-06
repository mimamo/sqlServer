USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xspCreatePendAPDoc]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xspCreatePendAPDoc] 
(
  @psBatNbr               char(10),
  @psDocType              char(2),
  @psVendID               char(15),
  @ptDocDate              smalldatetime,
  @psInvcNbr              char(15),
  @ptInvcDate             smalldatetime,
  @psTerms                char(2),
  @pfOrigDocAmt           float,
  @pfDiscBal              float,
  @ptDiscDate             smalldatetime,
  @ptDueDate              smalldatetime,
  @ptPayDate              smalldatetime,
  @psUser1                char(30),
  @psUser2                char(30),
  @pfUser3                float,
  @pfUser4                float,
  @psUser5                char(10),
  @psUser6                char(10),
  @ptUser7                smalldatetime,
  @ptUser8                smalldatetime,
  @osRefNbr               char(10)       OUTPUT,    
  @oiRetVal               int            OUTPUT,
  @osRetMsg               varchar(255)   OUTPUT
)

AS

  SET NOCOUNT ON
  
  DECLARE @sCurrDate      varchar(10),                  -- Created Date (string format)
          @tCurrDate      smalldatetime,                -- Created Date (date format)
          @sNullDate      varchar(10),                  -- Null Date
          @iDiscIntrv     smallint,                     -- Used in calculating Discount
          @fDiscPct       float,                        -- Used in calculating Discount
          @sDiscType      char(1),                      -- Used in calculating Discount
          @iDueIntrv      smallint,                     -- Used in calculating Due Date                 
          @sDueType       char(1),                      -- Used in calculating Due Date                 
          @sAPAcct        char(10),                     -- Default AP Acct for Vendor
          @sAPSub         char(24),                     -- Default AP Sub for Vendor
          @sCashAcct      char(10),                     -- Default Cash Acct
          @sCashSub       char(24),                     -- Default Cash Sub
          @sCpnyID        char(10),                     -- Company ID (retrieved from Batch)
          @sCuryID        char(4),                      -- Multi-currency ID
          @sCuryMultDiv   char(1),                      -- Currency Info
          @fCuryRate      float,                        -- Currency Info
          @sCuryRateType  char(6),                      -- Currency Info
          @sPerPost       char(6)                       -- Period Post (retrieved from Batch)
          
  -- ********************************************************************** --
  -- Validate the data
  -- ********************************************************************** --
  
  -- Validate the Batch Nbr
  IF @psBatNbr IS NULL OR @psBatNbr = '' BEGIN     
    SELECT
      @oiRetVal = -1,
      @osRetMsg = 'Missing Batch Number'
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM #Batch WHERE BatNbr = @psBatNbr AND Module = 'AP') BEGIN
      SELECT
        @oiRetVal = -1,
        @osRetMsg = 'Invalid Batch Number'
       
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      
  
  -- Validate the Vendor ID
  IF @psVendID IS NULL OR @psVendID = '' BEGIN     
    SELECT
      @oiRetVal = -2,
      @osRetMsg = 'Missing Vendor ID'
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM Vendor WHERE VendID = @psVendID AND Status = 'A') BEGIN
      SELECT
        @oiRetVal = -2,
        @osRetMsg = 'Vendor Missing or Inactive'
       
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      
  
  -- Validate the Terms ID
  IF @psTerms IS NULL OR @psTerms = '' BEGIN    
    -- Load the default
    SELECT
      @psTerms = Terms
    FROM
      Vendor
    WHERE
      VendID = @psVendID
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM Terms WHERE TermsID = @psTerms) BEGIN
      SELECT
        @oiRetVal = -3,
        @osRetMsg = 'Invalid Terms ID'
       
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      

  -- Validate Document Amount
  IF @pfOrigDocAmt <= 0 BEGIN
    SELECT
      @oiRetVal = -4,
      @osRetMsg = 'Document amount must be greater than 0'
    
      RETURN
  END

  -- Validate Document Amount
  IF @pfDiscBal < 0 BEGIN
    SELECT
      @oiRetVal = -5,
      @osRetMsg = 'Discount cannot be less than 0'
    
      RETURN
  END
  
    
  -- ********************************************************************** --
  -- Set Default Values
  -- ********************************************************************** --
  SELECT @tCurrDate = GETDATE()
  SELECT @sCurrDate = CONVERT(varchar, @tCurrDate, 101)
  SELECT @sNullDate = '1/1/1900'
  
  SELECT @psUser1 = ISNULL(@psUser1, '')
  SELECT @psUser2 = ISNULL(@psUser2, '')
  SELECT @pfUser3 = ISNULL(@pfUser3, 0)
  SELECT @pfUser4 = ISNULL(@pfUser4, 0)
  SELECT @psUser5 = ISNULL(@psUser5, '')
  SELECT @psUser6 = ISNULL(@psUser6, '')
  SELECT @ptUser7 = ISNULL(@ptUser7, @sNullDate)
  SELECT @ptUser8 = ISNULL(@ptUser8, @sNullDate)
  
  IF @psDocType IS NULL OR @psDocType NOT IN ('VO','AD','AC') 
    SELECT @psDocType = 'VO'
    
  -- If Document Date not supplied set to default
  SELECT @ptDocDate = ISNULL(@ptDocDate, @sCurrDate)
 
  -- If Invoice Date not supplied set to default
  SELECT @ptInvcDate = ISNULL(@ptInvcDate, @sCurrDate)
  
  -- Get the Terms Info used in determining the following
  SELECT
    @iDiscIntrv = DiscIntrv,
    @fDiscPct = DiscPct,
    @sDiscType = DiscType,
    @iDueIntrv = DueIntrv,
    @sDueType = DueType
  FROM
    Terms
  WHERE
    TermsID = @psTerms
       
  -- If Discount Date not supplied, we should determine from Terms table
  IF @ptDiscDate IS NULL BEGIN

    IF @sDiscType = 'D' BEGIN
      -- Days
      SELECT
        @ptDiscDate = DATEADD(d, @iDiscIntrv, @ptInvcDate)
    END ELSE BEGIN
      -- Day of next month
      SELECT
        @ptDiscDate = CAST(DATEPART(m,DATEADD(m, 1, @ptInvcDate)) AS varchar) + '/' + CAST(@iDiscIntrv as varchar) + '/'  + CAST(DATEPART(yy, DATEADD(m, 1, @ptInvcDate)) AS varchar)   
    END
    
  END
    
  -- If Due Date not supplied, we should determine from Terms table
  IF @ptDueDate IS NULL BEGIN
                                      
    IF @sDueType = 'D' BEGIN
      -- Days
      SELECT
        @ptDueDate = DATEADD(d, @iDueIntrv, @ptInvcDate)
    END ELSE BEGIN
      -- Day of next month
      SELECT
        @ptDueDate = CAST(DATEPART(m,DATEADD(m, 1, @ptInvcDate)) AS varchar) + '/' + CAST(@iDueIntrv as varchar) + '/'  + CAST(DATEPART(yy, DATEADD(m, 1, @ptInvcDate)) AS varchar)   
    END
    
  END
  
  -- If Pay Date not supplied, we should default it to the Discount Date
  IF @ptPayDate IS NULL BEGIN

    SELECT
      @ptPayDate = @ptDiscDate
      
  END
    
  -- If Discount amount not supplied then calculate it from the terms
  IF @pfDiscBal IS NULL BEGIN
    
    SELECT 
      @pfDiscBal = ROUND(@fDiscPct / 100 * @pfOrigDocAmt,2)
        
  END
  
  SELECT @psInvcNbr = ISNULL(@psInvcNbr, '')

  -- Get Information from APSetup  
  SELECT
    @sCashAcct = ChkAcct,
    @sCashSub = ChkSub
  FROM
    APSetup
          
  -- Some values need to be changed for Debit Adjustments
  IF @psDocType = 'AD' BEGIN
    SELECT
      @sCashAcct = '',
      @sCashSub = '',
      @ptPayDate = @sNullDate
  END
  
  -- ********************************************************************** --
  -- Create the AP Document
  -- ********************************************************************** --

  BEGIN TRAN
  
  -- Lock the table
  UPDATE APSetup SET User3 = User3 + 0
  
  SELECT 
    @osRefNbr = RIGHT('000000' + CAST(CAST(LastRefNbr as int) + 1 as varchar),6)
  FROM 
    APSetup
    
  UPDATE
    APSetup
  SET
    LastRefNbr = @osRefNbr
    
  COMMIT TRAN  

  SELECT
    @sAPAcct = APAcct,
    @sAPSub = APSub
  FROM
    Vendor
  WHERE
    VendID = @psVendID

  SELECT
    @sCpnyID = CpnyID,
    @sCuryID = CuryID,
    @sCuryMultDiv = CuryMultDiv,
    @fCuryRate = CuryRate,
    @sCuryRateType = CuryRateType,
    @sPerPost = PerPost
  FROM
    #Batch
  WHERE
    BatNbr = @psBatNbr
  
  -- Fill Temp Table
  INSERT INTO #APDoc (
    Acct                 , 
    AddlCost             ,
    ApplyAmt             ,
    ApplyDate            ,
    ApplyRefNbr          , 
    BatNbr               , 
    BatSeq               ,
    CashAcct             , 
    CashSub              , 
    ClearAmt             ,
    ClearDate            ,
    CpnyID               , 
    Crtd_DateTime        ,
    Crtd_Prog            ,
    Crtd_User            , 
    CurrentNbr           ,
    CuryDiscBal          ,
    CuryDiscTkn          ,
    CuryDocBal           ,
    CuryEffDate          ,
    CuryId               ,
    CuryMultDiv          ,
    CuryOrigDocAmt       ,
    CuryPmtAmt           ,
    CuryRate             ,
    CuryRateType         ,
    CuryTaxTot00         ,
    CuryTaxTot01         ,
    CuryTaxTot02         ,
    CuryTaxTot03         ,
    CuryTxblTot00        ,
    CuryTxblTot01        ,
    CuryTxblTot02        ,
    CuryTxblTot03        ,
    Cycle                ,
    DfltDetail           ,
    DirectDeposit        ,
    DiscBal              ,
    DiscDate             ,
    DiscTkn              ,
    Doc1099              ,
    DocBal               ,
    DocClass             ,
    DocDate              ,
    DocDesc              , 
    DocType              ,
    DueDate              ,
    Econfirm             , 
    Estatus              ,
    InstallNbr           ,
    InvcDate             ,
    InvcNbr              , 
    LCCode               , 
    LineCntr             ,
    LUpd_DateTime        ,
    LUpd_Prog            ,
    LUpd_User            , 
    MasterDocNbr         , 
    NbrCycle             ,
    NoteID               ,
    OpenDoc              ,
    OrigDocAmt           ,
    PayDate              ,
    PayHoldDesc          , 
    PC_Status            ,
    PerClosed            ,
    PerEnt               ,
    PerPost              ,
    PmtAmt               ,
    PmtID                , 
    PmtMethod            ,
    PONbr                , 
    PrePay_RefNbr        , 
    ProjectID            , 
    RefNbr               , 
    Retention            ,
    RGOLAmt              ,
    Rlsed                ,
    S4Future01           , 
    S4Future02           , 
    S4Future03           ,
    S4Future04           ,
    S4Future05           ,
    S4Future06           ,
    S4Future07           ,
    S4Future08           ,
    S4Future09           ,
    S4Future10           ,
    S4Future11           , 
    S4Future12           , 
    Selected             ,
    Status               ,
    Sub                  , 
    TaxCntr00            ,
    TaxCntr01            ,
    TaxCntr02            ,
    TaxCntr03            ,
    TaxId00              , 
    TaxId01              , 
    TaxId02              , 
    TaxId03              , 
    TaxTot00             ,
    TaxTot01             ,
    TaxTot02             ,
    TaxTot03             ,
    Terms                ,
    TxblTot00            ,
    TxblTot01            ,
    TxblTot02            ,
    TxblTot03            ,
    User1                , 
    User2                , 
    User3                ,
    User4                ,
    User5                , 
    User6                , 
    User7                ,
    User8                ,
    VendId               )
  VALUES (
    @sAPAcct,    --Acct                 , 
    0,    --AddlCost             ,
    0,    --ApplyAmt             ,
    @ptDocDate,    --ApplyDate            ,
    '',    --ApplyRefNbr          , 
    @psBatNbr,    --BatNbr               , 
    0,    --BatSeq               ,
    @sCashAcct,    --CashAcct             , 
    @sCashSub,    --CashSub              , 
    0,    --ClearAmt             ,
    @sNullDate,    --ClearDate            ,
    @sCpnyID,    --CpnyID               , 
    @sCurrDate,    --Crtd_DateTime        ,
    '03010',    --Crtd_Prog            ,
    'SYSADMIN',    --Crtd_User            , 
    1,    --CurrentNbr           ,
    @pfDiscBal,    --CuryDiscBal          ,
    0,    --CuryDiscTkn          ,
    ROUND(@pfOrigDocAmt,2),    --CuryDocBal           ,
    @ptDocDate,    --CuryEffDate          ,
    @sCuryID,    --CuryId               ,
    @sCuryMultDiv,    --CuryMultDiv          ,
    ROUND(@pfOrigDocAmt,2),    --CuryOrigDocAmt       ,
    0,    --CuryPmtAmt           ,
    @fCuryRate,    --CuryRate             ,
    @sCuryRateType,    --CuryRateType         ,
    0,    --CuryTaxTot00         ,
    0,    --CuryTaxTot01         ,
    0,    --CuryTaxTot02         ,
    0,    --CuryTaxTot03         ,
    0,    --CuryTxblTot00        ,
    0,    --CuryTxblTot01        ,
    0,    --CuryTxblTot02        ,
    0,    --CuryTxblTot03        ,
    1,    --Cycle                ,
    0,    --DfltDetail           ,
    '',    --DirectDeposit        ,
    @pfDiscBal,    --DiscBal              ,
    @ptDiscDate,    --DiscDate             ,
    0,    --DiscTkn              ,
    0,    --Doc1099              ,  NOTE: This will be updated when transferred to live table - based on transaction detail
    ROUND(@pfOrigDocAmt,2),    --DocBal               ,
    'N',    --DocClass             ,
    @ptDocDate,    --DocDate              ,
    '',    --DocDesc              , 
    @psDocType,    --DocType              ,
    @ptDueDate,    --DueDate              ,
    '',    --Econfirm             , 
    '',    --Estatus              ,
    0,    --InstallNbr           ,
    @ptInvcDate,    --InvcDate             ,
    @psInvcNbr,    --InvcNbr              , 
    '',    --LCCode               , 
    0,    --LineCntr             ,  NOTE: This will be updated when transferred to live table - based on transaction detail
    @sCurrDate,    --LUpd_DateTime        ,
    '03010',    --LUpd_Prog            ,
    'SYSADMIN',    --LUpd_User            , 
    '',    --MasterDocNbr         , 
    0,    --NbrCycle             ,
    0,    --NoteID               ,
    1,    --OpenDoc              ,
    ROUND(@pfOrigDocAmt,2),    --OrigDocAmt           ,
    @ptPayDate,    --PayDate              ,
    '',    --PayHoldDesc          , 
    '',    --PC_Status            ,
    '',    --PerClosed            ,
    @sPerPost,    --PerEnt               ,
    @sPerPost,    --PerPost              ,
    0,    --PmtAmt               ,
    '',    --PmtID                , 
    'C',    --PmtMethod            ,
    '',    --PONbr                , 
    '',    --PrePay_RefNbr        , 
    '',    --ProjectID            , 
    @osRefNbr,    --RefNbr               , 
    0,    --Retention            ,
    0,    --RGOLAmt              ,
    0,    --Rlsed                ,
    '',    --S4Future01           , 
    '',    --S4Future02           , 
    0,    --S4Future03           ,
    0,    --S4Future04           ,
    0,    --S4Future05           ,
    0,    --S4Future06           ,
    @sNullDate,    --S4Future07           ,
    @sNullDate,    --S4Future08           ,
    0,    --S4Future09           ,
    0,    --S4Future10           ,
    '',    --S4Future11           , 
    '',    --S4Future12           , 
    0,    --Selected             ,
    'A',    --Status               ,
    @sAPSub,    --Sub                  , 
    0,    --TaxCntr00            ,
    0,    --TaxCntr01            ,
    0,    --TaxCntr02            ,
    0,    --TaxCntr03            ,
    '',    --TaxId00              , 
    '',    --TaxId01              , 
    '',    --TaxId02              , 
    '',    --TaxId03              , 
    0,    --TaxTot00             ,
    0,    --TaxTot01             ,
    0,    --TaxTot02             ,
    0,    --TaxTot03             ,
    @psTerms,    --Terms                ,
    0,    --TxblTot00            ,
    0,    --TxblTot01            ,
    0,    --TxblTot02            ,
    0,    --TxblTot03            ,
    @psUser1,    --User1                , 
    @psUser2,    --User2                , 
    @pfUser3,    --User3                ,
    @pfUser4,    --User4                ,
    @psUser5,    --User5                , 
    @psUser6,    --User6                , 
    @ptUser7,    --User7                ,
    @ptUser8,    --User8                ,
    @psVendID)    --VendId               )
  
  
  -- If we got this far, then the batch was created
  SELECT
    @oiRetVal = 0,
    @osRetMsg = ''
GO
