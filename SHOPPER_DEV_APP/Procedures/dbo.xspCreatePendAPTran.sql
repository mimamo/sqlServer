USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xspCreatePendAPTran]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xspCreatePendAPTran] 
(
  @psBatNbr               char(10),
  @psRefNbr               char(10), 
  @psLineType             char(1),
  @psAcct                 char(10),
  @psSub                  char(24),
  @psLCCode               char(10),
  @pfQty                  float,
  @psUnitDesc             char(10),
  @pfUnitPrice            float,
  @pfTranAmt              float,
  @psBoxNbr               char(2),
  @psTranDesc             char(30),
  @psExtRefNbr            char(15),
  @psEmployeeID           char(10),
  @psUser1                char(30),
  @psUser2                char(30),
  @pfUser3                float,
  @pfUser4                float,
  @psUser5                char(10),
  @psUser6                char(10),
  @ptUser7                smalldatetime,
  @ptUser8                smalldatetime,
  @oiRetVal               int            OUTPUT,
  @osRetMsg               varchar(255)   OUTPUT
)

AS

  SET NOCOUNT ON
  
  DECLARE @sCurrDate      varchar(10),                  -- Created Date (string format)
          @tCurrDate      smalldatetime,                -- Created Date (date format)
          @sNullDate      varchar(10),                  -- Null Date
          @sVendID        char(15),                     -- Vendor ID (retrieved from Document)
          @iVend1099      smallint,                     -- Vendor 1099 Flag (retrieved from Vendor)
          @sCpnyID        char(10),                     -- Company ID (retrieved from Batch)
          @sCuryID        char(4),                      -- Multi-currency ID
          @sCuryMultDiv   char(1),                      -- Currency Info
          @fCuryRate      float,                        -- Currency Info
          @sCuryRateType  char(6),                      -- Currency Info
          @sPerPost       char(6),                      -- Period Post (retrieved from Batch)
          @sAPDocType     char(2),                      -- Used to determine the doctype
          @sDrCr          char(1),                      -- Debit/Credit Flag
          @sTranType      char(2),                      -- Transaction Type
          @sDfltBox       char(2)                       -- Default 1099 Box for Vendor
          
          
  -- ********************************************************************** --
  -- Validate the data
  -- ********************************************************************** --
      
  -- Validate the Batch Nbr
  IF @psBatNbr IS NULL OR @psBatNbr = '' BEGIN     
    SELECT
      @oiRetVal = -1,
      @osRetMsg = 'Missing Batch Number'
    RETURN
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM #Batch WHERE BatNbr = @psBatNbr AND Module = 'AP') BEGIN
      SELECT
        @oiRetVal = -1,
        @osRetMsg = 'Invalid Batch Number'       
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      

  -- Validate the Ref Nbr
  IF @psRefNbr IS NULL OR @psRefNbr = '' BEGIN     
    SELECT
      @oiRetVal = -2,
      @osRetMsg = 'Missing Reference Number'
    RETURN
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM #APDoc WHERE RefNbr = @psRefNbr) BEGIN
      SELECT
        @oiRetVal = -2,
        @osRetMsg = 'Invalid Batch Number'
      RETURN
    END    -- IF NOT EXISTS(SELECT * FROM Batch WHERE BatNbr = @osBatNbr AND Module = 'AP')
  END    -- @osBatNbr IS NULL OR @osBatNbr = ''      

  -- Validate the Account Number
  IF @psAcct IS NULL OR @psAcct = '' BEGIN
    SELECT
      @oiRetVal = -3,
      @osRetMsg = 'Invalid Account Number'
    RETURN
  END ELSE BEGIN  
    IF NOT EXISTS(SELECT * FROM Account WHERE Acct = @psAcct) BEGIN
      SELECT 
        @oiRetVal = -3,
        @osRetMsg = 'Invalid Account Number'
      RETURN
    END
  END

  -- Validate the Sub-account Number
  IF @psSub IS NULL OR @psSub = '' BEGIN
    SELECT
      @oiRetVal = -4,
      @osRetMsg = 'Invalid Sub-account Number'
    RETURN
  END ELSE BEGIN  
    IF NOT EXISTS(SELECT * FROM SubAcct WHERE Sub = @psSub) BEGIN
      SELECT 
        @oiRetVal = -4,
        @osRetMsg = 'Invalid Sub-account Number'
      RETURN
    END
  END

  -- Validate Landed Cost Code
  IF @psLCCode IS NULL BEGIN
    SELECT
      @psLCCode = ''
  END ELSE BEGIN  
    IF NOT EXISTS(SELECT * FROM LCCode WHERE LCCode = @psLCCode) BEGIN
      SELECT 
        @oiRetVal = -5,
        @osRetMsg = 'Invalid Landed Cost Code'
      RETURN
    END
  END

  -- Validate Qty
  IF @pfQty IS NULL BEGIN
    SELECT
      @pfQty = 0
  END ELSE BEGIN
    IF @pfQty < 0 BEGIN
      SELECT
        @oiRetVal = -6,
        @osRetMsg = 'Quantity must be greater than or equal to 0'
      RETURN
    END
  END

  -- Validate Unit Price
  IF @pfUnitPrice IS NULL BEGIN
    SELECT
      @pfUnitPrice = 0
  END ELSE BEGIN
    IF @pfUnitPrice < 0 BEGIN
      SELECT
        @oiRetVal = -7,
        @osRetMsg = 'Unit Price must be greater than or equal to 0'
      RETURN
    END
  END
      
  -- Validate the Box Number
  SELECT
    @sVendID = VendID,
    @sAPDocType = DocType
  FROM
    #APDoc
  WHERE
    RefNbr = @psRefNbr
  
  SELECT
    @iVend1099 = Vend1099,
    @sDfltBox = DfltBox
  FROM
    Vendor
  WHERE
    VendID = @sVendID
  
  IF @iVend1099 = 1 BEGIN  
    -- If Vendor is 1099 and didn't specify, grab the default
    IF @psBoxNbr IS NULL 
      SET @psBoxNbr = @sDfltBox
  
    IF @psBoxNbr NOT IN ('','1','2','3','4','5','6','7','8','10','13','14') BEGIN
      SELECT
        @oiRetVal = -8,
        @osRetMsg = 'Invalid Box Number'
      RETURN     
    END  
  END ELSE BEGIN
    SELECT
      @psBoxNbr = ''
  END

  -- Validate the Employee ID
  IF @psEmployeeID IS NULL BEGIN
    SELECT 
      @psEmployeeID = ''
  END ELSE BEGIN
    IF NOT EXISTS(SELECT * FROM Employee WHERE EmpID = @psEmployeeID) BEGIN
      SELECT 
        @oiRetVal = -9,
        @osRetMsg = 'Invalid Employee ID'
      RETURN
    END
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
   
  SELECT @psUnitDesc = ISNULL(@psUnitDesc, '')
  SELECT @psTranDesc = ISNULL(@psTranDesc, '')
  SELECT @psExtRefNbr = ISNULL(@psExtRefNbr, '')
  
  IF @psLineType IS NULL OR @psLineType NOT IN ('N','F','C')
    SELECT @psLineType = 'N'
    
  IF @pfQty <> 0 
    SELECT @pfTranAmt = @pfQty * @pfUnitPrice
   
  SELECT @pfTranAmt = ISNULL(@pfTranAmt, 0) 
  
  IF @sAPDocType = 'AD' 
    SELECT 
      @sDrCr = 'C',
      @sTranType = 'AD'
  ELSE
    SELECT 
      @sDrCr = 'D',
      @sTranType = 'VO'  
  
  -- ********************************************************************** --
  -- Create the AP Transaction
  -- ********************************************************************** --

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
  INSERT INTO #APTran (
    Acct,
    AcctDist,
    AlternateID,
    BatNbr,
    BOMLineRef,
    BoxNbr,
    Component,
    CostType,
    CostTypeWO,
    CpnyID,
    Crtd_DateTime,
    Crtd_Prog,
    Crtd_User,
    CuryId,
    CuryMultDiv,
    CuryPOExtPrice,
    CuryPOUnitPrice,
    CuryPPV,
    CuryRate,
    CuryTaxAmt00,
    CuryTaxAmt01,
    CuryTaxAmt02,
    CuryTaxAmt03,
    CuryTranAmt,
    CuryTxblAmt00,
    CuryTxblAmt01,
    CuryTxblAmt02,
    CuryTxblAmt03,
    CuryUnitPrice,
    DrCr,
    Employee,
    EmployeeID,
    Excpt,
    ExtRefNbr,
    FiscYr,
    InstallNbr,
    InvcTypeID,
    InvtID,
    JobRate,
    JrnlType,
    Labor_Class_Cd,
    LCCode,
    LineId,
    LineNbr,
    LineRef,
    LineType,
    LUpd_DateTime,
    LUpd_Prog,
    LUpd_User,
    MasterDocNbr,
    NoteID,
    PC_Flag,
    PC_ID,
    PC_Status,
    PerEnt,
    PerPost,
    PmtMethod,
    POExtPrice,
    POLineRef,
    PONbr,
    POQty,
    POUnitPrice,
    PPV,
    ProjectID,
    Qty,
    QtyVar,
    RcptLineRef,
    RcptNbr,
    RcptQty,
    RefNbr,
    Rlsed,
    S4Future01,
    S4Future02,
    S4Future03,
    S4Future04,
    S4Future05,
    S4Future06,
    S4Future07,
    S4Future08,
    S4Future09,
    S4Future10,
    S4Future11,
    S4Future12,
    ServiceDate,
    SiteId,
    SoLineRef,
    SOOrdNbr,
    SOTypeID,
    Sub,
    TaskID,
    TaxAmt00,
    TaxAmt01,
    TaxAmt02,
    TaxAmt03,
    TaxCalced,
    TaxCat,
    TaxId00,
    TaxId01,
    TaxId02,
    TaxId03,
    TaxIdDflt,
    TranAmt,
    TranClass,
    TranDate,
    TranDesc,
    trantype,
    TxblAmt00,
    TxblAmt01,
    TxblAmt02,
    TxblAmt03,
    UnitDesc,
    UnitPrice,
    User1,
    User2,
    User3,
    User4,
    User5,
    User6,
    User7,
    User8,
    VendId,
    WONbr,
    WOStepNbr)
  VALUES (
    @psAcct,  -- Acct,
    0,  -- AcctDist,
    '',  -- AlternateID,
    @psBatNbr,  -- BatNbr,
    '',  -- BOMLineRef,
    @psBoxNbr,  -- BoxNbr,
    '',  -- Component,
    '0',  -- CostType,
    '',  -- CostTypeWO,
    @sCpnyID,  -- CpnyID,
    @sCurrDate,  -- Crtd_DateTime,
    '03010',  -- Crtd_Prog,
    'SYSADMIN',  -- Crtd_User,
    @sCuryID,  -- CuryId,
    @sCuryMultDiv,  -- CuryMultDiv,
    0,  -- CuryPOExtPrice,
    0,  -- CuryPOUnitPrice,
    0,  -- CuryPPV,
    @fCuryRate,  -- CuryRate,
    0,  -- CuryTaxAmt00,
    0,  -- CuryTaxAmt01,
    0,  -- CuryTaxAmt02,
    0,  -- CuryTaxAmt03,
    ROUND(@pfTranAmt,2),  -- CuryTranAmt,
    0,  -- CuryTxblAmt00,
    0,  -- CuryTxblAmt01,
    0,  -- CuryTxblAmt02,
    0,  -- CuryTxblAmt03,
    @pfUnitPrice,  -- CuryUnitPrice,
    @sDrCr,  -- DrCr,
    '', -- Employee,
    @psEmployeeID,  -- EmployeeID,
    0,  -- Excpt,
    @psExtRefNbr, -- ExtRefNbr,
    LEFT(@sPerPost, 4),  -- FiscYr,
    0,  -- InstallNbr,
    '',  -- InvcTypeID,
    '',  -- InvtID,
    0,  -- JobRate,
    'AP',  -- JrnlType,
    '',  -- Labor_Class_Cd,
    @psLCCode,   -- LCCode,
    0,  -- LineId,                              NOTE: We'll update when we insert into live tables
    0,  -- LineNbr,                             NOTE: We'll update when we insert into live tables
    '0',  -- LineRef,
    @psLineType,  -- LineType,
    @sCurrDate,  -- LUpd_DateTime,
    '03010',  -- LUpd_Prog,
    'SYSADMIN',  -- LUpd_User,
    '',  -- MasterDocNbr,
    0,  -- NoteID,
    '',  -- PC_Flag,
    '',  -- PC_ID,
    0,  -- PC_Status,
    @sPerPost,  -- PerEnt,
    @sPerPost,  -- PerPost,
    '',  -- PmtMethod,
    0,  -- POExtPrice,
    '',  -- POLineRef,
    '',  -- PONbr,
    0,  -- POQty,
    0,  -- POUnitPrice,
    0,  -- PPV,
    '',  -- ProjectID,
    @pfQty,  -- Qty,
    0,  -- QtyVar,
    '',  -- RcptLineRef,
    '',  -- RcptNbr,
    0,  -- RcptQty,
    @psRefNbr,  -- RefNbr,
    0,  -- Rlsed,
    '',  -- S4Future01,
    '',  -- S4Future02,
    0,  -- S4Future03,
    0,  -- S4Future04,
    0,  -- S4Future05,
    0,  -- S4Future06,
    @sNullDate,   -- S4Future07,
    @sNullDate,   -- S4Future08,
    0,  -- S4Future09,
    0,  -- S4Future10,
    '',  -- S4Future11,
    '',  -- S4Future12,
    @sNullDate,   -- ServiceDate,
    '',  -- SiteId,
    '',  -- SoLineRef,
    '',  -- SOOrdNbr,
    '',  -- SOTypeID,
    @psSub,   -- Sub,
    '',  -- TaskID,
    0,  -- TaxAmt00,
    0,  -- TaxAmt01,
    0,  -- TaxAmt02,
    0,  -- TaxAmt03,
    'Y',  -- TaxCalced,
    '',  -- TaxCat,
    '',  -- TaxId00,
    '',  -- TaxId01,
    '',  -- TaxId02,
    '',  -- TaxId03,
    '',  -- TaxIdDflt,
    ROUND(@pfTranAmt,2),   -- TranAmt,
    '',  -- TranClass,
    @sCurrDate,   -- TranDate,
    @psTranDesc,  -- TranDesc,
    @sTranType,  -- trantype,
    0, -- TxblAmt00,
    0, -- TxblAmt01,
    0, -- TxblAmt02,
    0, -- TxblAmt03,
    @psUnitDesc,  -- UnitDesc,
    @pfUnitPrice,  -- UnitPrice,
    @psUser1,  -- User1,
    @psUser2,  -- User2,
    @pfUser3,  -- User3,
    @pfUser4,  -- User4,
    @psUser5,  -- User5,
    @psUser6,  -- User6,
    @ptUser7,  -- User7,
    @ptUser8,  -- User8,
    @sVendID,  -- VendId,
    '',  -- WONbr,
    '')  -- WOStepNbr)
  
  
  -- If we got this far, then the batch was created
  SELECT
    @oiRetVal = 0,
    @osRetMsg = ''
GO
