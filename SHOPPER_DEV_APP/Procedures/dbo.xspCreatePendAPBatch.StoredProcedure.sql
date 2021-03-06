USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xspCreatePendAPBatch]    Script Date: 12/21/2015 14:34:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xspCreatePendAPBatch] 
(
  @psCpnyID               char(10),
  @psPerPost              char(6) ,    
  @psUser1                char(30),
  @psUser2                char(30),
  @pfUser3                float,
  @pfUser4                float,
  @psUser5                char(10),
  @psUser6                char(10),
  @ptUser7                smalldatetime,
  @ptUser8                smalldatetime,
  @osBatNbr               char(10)       OUTPUT,    
  @oiRetVal               int            OUTPUT,
  @osRetMsg               varchar(255)   OUTPUT
)

AS

  SET NOCOUNT ON
  
  DECLARE @iCreateBatch   int,                          -- Used as a flag to determine if a new BatNbr needs to be assigned
          @sYear          char(4),                      -- Used to validate the Period
          @sPeriod        char(2),                      -- Used to validate the Period
          @sMaxPeriod     char(2),                      -- Used to validate the Period
          @sBaseCuryID    char(4),                      -- Base Currency ID from GLSetup
          @sCurrDate      varchar(10),                  -- Created Date (string format)
          @tCurrDate      smalldatetime,                -- Created Date (date format)
          @sNullDate      varchar(10),                  -- Null Date
          @sCuryMultDiv   char(1),                      -- Currency Info
          @fCuryRate      float,                        -- Currency Info
          @sCuryRateType  char(6),                      -- Currency Info
          @sGLPostOpt     char(1),                      -- GL Posting Option from APSetup
          @sLedgerID      char(10)                      -- Ledger ID from GLSetup
  

  -- ********************************************************************** --
  -- Set Default Values
  -- ********************************************************************** --
  SELECT @tCurrDate = GETDATE()
  SELECT @sCurrDate = CONVERT(varchar, @tCurrDate, 101)
  SELECT @sNullDate = '1/1/1900'
  
  -- TODO: Get this from Multi-Currency Tables
  SELECT 
    @sCuryMultDiv = 'M',
    @fCuryRate = 1,
    @sCuryRateType = ''

  SELECT @psUser1 = ISNULL(@psUser1, '')
  SELECT @psUser2 = ISNULL(@psUser2, '')
  SELECT @pfUser3 = ISNULL(@pfUser3, 0)
  SELECT @pfUser4 = ISNULL(@pfUser4, 0)
  SELECT @psUser5 = ISNULL(@psUser5, '')
  SELECT @psUser6 = ISNULL(@psUser6, '')
  SELECT @ptUser7 = ISNULL(@ptUser7, @sNullDate)
  SELECT @ptUser8 = ISNULL(@ptUser8, @sNullDate)
  
  -- ********************************************************************** --
  -- Validate the data
  -- ********************************************************************** --
  
  -- Validate the Batch Nbr (if passed)
  IF @osBatNbr IS NULL OR @osBatNbr = '' BEGIN     
    SET @iCreateBatch = 1
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP') BEGIN
      SELECT
        @oiRetVal = -1,
        @osRetMsg = 'Invalid Batch Number'
       
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      
  
  -- Validate the Period (if passed)
  IF @psPerPost IS NULL or @psPerPost = '' BEGIN
    -- Get the current Period to Post
    SELECT 
      @psPerPost = CurrPerNbr 
    FROM
      APSetUp
    
    END
  ELSE BEGIN
    -- Validate the length
    IF LEN(RTRIM(LTRIM(@psPerPost))) <> 6 BEGIN
      SELECT
        @oiRetVal = -2,
        @osRetMsg = 'Invalid Period Post value'
       
      RETURN
    END    -- IF LENGTH(RTRIM(LTRIM(@psPerPost))) <> 6 
    
    -- Validate the year
    SELECT
      @sYear = LEFT(@psPerPost, 4)
      
    IF ISDATE('1/1/' + @sYear) = 0 BEGIN
      SELECT
        @oiRetVal = -2,
        @osRetMsg = 'Invalid Period Post value'
       
      RETURN
    END    -- IF ISDATE('1/1/' + @sYear) = 0 

    -- Validate the Period
    SELECT
      @sPeriod = RIGHT(@psPerPost, 2)
      
    SELECT
      @sMaxPeriod = NbrPer
    FROM
      GLSetup
      
    IF ISNUMERIC(@sPeriod) = 0 BEGIN
      SELECT
        @oiRetVal = -2,
        @osRetMsg = 'Invalid Period Post value'
       
      RETURN
    END    -- IF ISNUMERIC(@sPeriod) = 0 
    
    IF CAST(@sPeriod AS int) > CAST(@sMaxPeriod as int) BEGIN
      SELECT
        @oiRetVal = -2,
        @osRetMsg = 'Invalid Period Post value'
       
      RETURN
    END    -- IF CAST(@sPeriod AS int) > CAST(@sMaxPeriod as int) 
  
  END    -- IF @psPerPost IS NULL or @psPerPost = '' 
       
  -- Validate the Company ID
  IF @psCpnyID IS NULL OR @psCpnyID = '' BEGIN     
     SELECT
      @oiRetVal = -3,
      @osRetMsg = 'Company ID Not supplied'
     
    RETURN
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM vs_Company WHERE CpnyID = @psCpnyID) BEGIN
      SELECT
        @oiRetVal = -3,
        @osRetMsg = 'Invalid Company ID'
       
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      
  
  
  
  -- ********************************************************************** --
  -- Create the Batch or Load from tables
  -- ********************************************************************** --
  
  IF @iCreateBatch = 1 BEGIN
    BEGIN TRAN
    
    -- Lock the table
    UPDATE APSetup SET User3 = User3 + 0
    
    SELECT 
      @osBatNbr = RIGHT('000000' + CAST(CAST(LastBatNbr as int) + 1 as varchar),6)
    FROM 
      APSetup
      
    UPDATE
      APSetup
    SET
      LastBatNbr = @osBatNbr
      
    COMMIT TRAN  
  
    SELECT 
      @sBaseCuryID = BaseCuryID,
      @sLedgerID = LedgerID
    FROM
      GLSetup

    SELECT
      @sGLPostOpt = GLPostOpt
    FROM
      APSetup
      
    -- Fill Temp Table
    INSERT INTO #Batch (
      Acct                 ,    
      AutoRev              , 
      AutoRevCopy          , 
      BalanceType          ,    
      BankAcct             ,    
      BankSub              ,    
      BaseCuryID           ,   
      BatNbr               ,    
      BatType              ,   
      clearamt             , 
      Cleared              , 
      CpnyID               ,    
      Crtd_DateTime        , 
      Crtd_Prog            ,    
      Crtd_User            ,    
      CrTot                , 
      CtrlTot              , 
      CuryCrTot            , 
      CuryCtrlTot          , 
      CuryDepositAmt       , 
      CuryDrTot            , 
      CuryEffDate          , 
      CuryId               ,    
      CuryMultDiv          ,    
      CuryRate             ,
      CuryRateType         ,    
      Cycle                , 
      DateClr              , 
      DateEnt              , 
      DepositAmt           , 
      Descr                ,    
      DrTot                ,
      EditScrnNbr          ,    
      GLPostOpt            ,    
      JrnlType             ,    
      LedgerID             ,    
      LUpd_DateTime        ,
      LUpd_Prog            ,    
      LUpd_User            ,    
      Module               ,    
      NbrCycle             ,
      NoteID               ,
      OrigBatNbr           ,    
      OrigCpnyID           ,    
      OrigScrnNbr          ,    
      PerEnt               ,    
      PerPost              ,    
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
      Status               ,    
      Sub                  ,    
      User1                ,    
      User2                ,    
      User3                ,
      User4                ,
      User5                ,    
      User6                ,    
      User7                ,
      User8                )
    VALUES (
      '',    -- Acct                 ,   
      0,    -- AutoRev              ,   
      0,    -- AutoRevCopy          ,   
      '',    -- BalanceType          ,   
      '',    -- BankAcct             ,   
      '',    -- BankSub              ,   
      @sBaseCuryID,    -- BaseCuryID           ,   
      @osBatNbr,    -- BatNbr               ,   
      'N',    -- BatType              ,   
      0,    -- clearamt             ,   
      0,    -- Cleared              ,   
      @psCpnyID,    -- CpnyID               ,   
      @sCurrDate,    -- Crtd_DateTime        ,   
      '03010',    -- Crtd_Prog            ,   
      'SYSADMIN',    -- Crtd_User            ,   
      0,    -- CrTot                ,   
      0,    -- CtrlTot              ,   
      0,    -- CuryCrTot            ,   
      0,    -- CuryCtrlTot          ,   
      0,    -- CuryDepositAmt       ,   
      0,    -- CuryDrTot            ,   
      @sCurrDate,    -- CuryEffDate          ,   
      @sBaseCuryID,    -- CuryId               ,   
      @sCuryMultDiv,    -- CuryMultDiv          ,   
      @fCuryRate,    -- CuryRate             ,   
      @sCuryRateType,    -- CuryRateType         ,   
      0,    -- Cycle                ,   
      @sNullDate,    -- DateClr              ,   
      @sNullDate,    -- DateEnt              ,   
      0,    -- DepositAmt           ,   
      '',    -- Descr                ,   
      0,    -- DrTot                ,   
      '03010',    -- EditScrnNbr          ,   
      @sGLPostOpt,    -- GLPostOpt            ,   
      'AP',    -- JrnlType             ,   
      @sLedgerID,    -- LedgerID             ,   
      @sCurrDate,    -- LUpd_DateTime        ,   
      '03010',    -- LUpd_Prog            ,   
      'SYSADMIN',    -- LUpd_User            ,   
      'AP',    -- Module               ,   
      0,    -- NbrCycle             ,   
      0,    -- NoteID               ,   
      '',    -- OrigBatNbr           ,   
      '',    -- OrigCpnyID           ,   
      '',    -- OrigScrnNbr          ,   
      @psPerPost,    -- PerEnt               ,   
      @psPerPost,    -- PerPost              ,   
      0,    -- Rlsed                ,   
      '',    -- S4Future01           ,   
      '',    -- S4Future02           ,   
      0,    -- S4Future03           ,   
      0,    -- S4Future04           ,   
      0,    -- S4Future05           ,   
      0,    -- S4Future06           ,   
      @sNullDate,    -- S4Future07           ,   
      @sNullDate,    -- S4Future08           ,   
      0,    -- S4Future09           ,   
      0,    -- S4Future10           ,   
      '',    -- S4Future11           ,   
      '',    -- S4Future12           ,   
      'H',    -- Status               ,   
      '',    -- Sub                  ,   
      @psUser1,    -- User1                ,   
      @psUser2,    -- User2                ,   
      @pfUser3,    -- User3                ,   
      @pfUser4,    -- User4                ,   
      @psUser5,    -- User5                ,   
      @psUser6,    -- User6                ,   
      @ptUser7,    -- User7                ,   
      @ptUser8)    -- User8                )   
    END
  ELSE BEGIN
    INSERT INTO #Batch (
      Acct                 ,    
      AutoRev              , 
      AutoRevCopy          , 
      BalanceType          ,    
      BankAcct             ,    
      BankSub              ,    
      BaseCuryID           ,   
      BatNbr               ,    
      BatType              ,   
      clearamt             , 
      Cleared              , 
      CpnyID               ,    
      Crtd_DateTime        , 
      Crtd_Prog            ,    
      Crtd_User            ,    
      CrTot                , 
      CtrlTot              , 
      CuryCrTot            , 
      CuryCtrlTot          , 
      CuryDepositAmt       , 
      CuryDrTot            , 
      CuryEffDate          , 
      CuryId               ,    
      CuryMultDiv          ,    
      CuryRate             ,
      CuryRateType         ,    
      Cycle                , 
      DateClr              , 
      DateEnt              , 
      DepositAmt           , 
      Descr                ,    
      DrTot                ,
      EditScrnNbr          ,    
      GLPostOpt            ,    
      JrnlType             ,    
      LedgerID             ,    
      LUpd_DateTime        ,
      LUpd_Prog            ,    
      LUpd_User            ,    
      Module               ,    
      NbrCycle             ,
      NoteID               ,
      OrigBatNbr           ,    
      OrigCpnyID           ,    
      OrigScrnNbr          ,    
      PerEnt               ,    
      PerPost              ,    
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
      Status               ,    
      Sub                  ,    
      User1                ,    
      User2                ,    
      User3                ,
      User4                ,
      User5                ,    
      User6                ,    
      User7                ,
      User8                )
    SELECT
      Acct                 ,    
      AutoRev              , 
      AutoRevCopy          , 
      BalanceType          ,    
      BankAcct             ,    
      BankSub              ,    
      BaseCuryID           ,   
      BatNbr               ,    
      BatType              ,   
      clearamt             , 
      Cleared              , 
      CpnyID               ,    
      Crtd_DateTime        , 
      Crtd_Prog            ,    
      Crtd_User            ,    
      CrTot                , 
      CtrlTot              , 
      CuryCrTot            , 
      CuryCtrlTot          , 
      CuryDepositAmt       , 
      CuryDrTot            , 
      CuryEffDate          , 
      CuryId               ,    
      CuryMultDiv          ,    
      CuryRate             ,
      CuryRateType         ,    
      Cycle                , 
      DateClr              , 
      DateEnt              , 
      DepositAmt           , 
      Descr                ,    
      DrTot                ,
      EditScrnNbr          ,    
      GLPostOpt            ,    
      JrnlType             ,    
      LedgerID             ,    
      LUpd_DateTime        ,
      LUpd_Prog            ,    
      LUpd_User            ,    
      Module               ,    
      NbrCycle             ,
      NoteID               ,
      OrigBatNbr           ,    
      OrigCpnyID           ,    
      OrigScrnNbr          ,    
      PerEnt               ,    
      PerPost              ,    
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
      Status               ,    
      Sub                  ,    
      User1                ,    
      User2                ,    
      User3                ,
      User4                ,
      User5                ,    
      User6                ,    
      User7                ,
      User8                
    FROM
      Batch
    WHERE
      BatNbr = @osBatNbr AND
      Module = 'AP'  
        
  END    -- IF @iCreateBatch = 1
  
  
  -- If we got this far, then the batch was created
  SELECT
    @oiRetVal = 0,
    @osRetMsg = ''
GO
