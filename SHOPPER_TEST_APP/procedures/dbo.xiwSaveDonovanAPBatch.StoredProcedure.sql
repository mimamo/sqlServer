USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwSaveDonovanAPBatch]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[xiwSaveDonovanAPBatch]

/* This procedure will take the header key and will create the AP Batch, Documents and transactions lines for the 
   valid Donovan Detail lines in the staging tables.  If a Batch is created it will return that batch number to the
   calling application.  
   
   Edit: 2012-12-17 Delmer  Added InvoiceDate
*/
   
  (
    @iDonovanHdrKey int
    ,@sAPBatNbr char(10) OUTPUT
  )

AS 

IF OBJECT_ID('tempdb..#Batch') IS NOT NULL
    DROP TABLE #Batch

IF OBJECT_ID('tempdb..#APDoc') IS NOT NULL
    DROP TABLE #APDoc

IF OBJECT_ID('tempdb..#APTran') IS NOT NULL
    DROP TABLE #APTran
    
CREATE TABLE #Batch (
  Acct                 char               (10),    
  AutoRev              smallint               , 
  AutoRevCopy          smallint               , 
  BalanceType          char               (1) ,    
  BankAcct             char               (10),    
  BankSub              char               (24),    
  BaseCuryID           char               (4) ,   
  BatNbr               char               (10),    
  BatType              char               (1) ,   
  clearamt             float                  , 
  Cleared              smallint               , 
  CpnyID               char               (10),    
  Crtd_DateTime        smalldatetime          , 
  Crtd_Prog            char               (8) ,    
  Crtd_User            char               (10),    
  CrTot                float                  , 
  CtrlTot              float                  , 
  CuryCrTot            float                  , 
  CuryCtrlTot          float                  , 
  CuryDepositAmt       float                  , 
  CuryDrTot            float                  , 
  CuryEffDate          smalldatetime          , 
  CuryId               char               (4) ,    
  CuryMultDiv          char               (1) ,    
  CuryRate             float                  ,
  CuryRateType         char               (6) ,    
  Cycle                smallint               , 
  DateClr              smalldatetime          , 
  DateEnt              smalldatetime          , 
  DepositAmt           float                  , 
  Descr                char               (30),    
  DrTot                float                  ,
  EditScrnNbr          char               (5) ,    
  GLPostOpt            char               (1) ,    
  JrnlType             char               (3) ,    
  LedgerID             char               (10),    
  LUpd_DateTime        smalldatetime          ,
  LUpd_Prog            char               (8) ,    
  LUpd_User            char               (10),    
  Module               char               (2) ,    
  NbrCycle             smallint               ,
  NoteID               int                    ,
  OrigBatNbr           char               (10),    
  OrigCpnyID           char               (10),    
  OrigScrnNbr          char               (5) ,    
  PerEnt               char               (6) ,    
  PerPost              char               (6) ,    
  Rlsed                smallint               ,
  S4Future01           char               (30),    
  S4Future02           char               (30),    
  S4Future03           float                  ,
  S4Future04           float                  ,
  S4Future05           float                  ,
  S4Future06           float                  ,
  S4Future07           smalldatetime          ,
  S4Future08           smalldatetime          ,
  S4Future09           int                    ,
  S4Future10           int                    ,
  S4Future11           char               (10),    
  S4Future12           char               (10),    
  [Status]             char               (1) ,    
  Sub                  char               (24),    
  User1                char               (30),    
  User2                char               (30),    
  User3                float                  ,
  User4                float                  ,
  User5                char               (10),    
  User6                char               (10),    
  User7                smalldatetime          ,
  User8                smalldatetime          
)                                             
                                              
CREATE TABLE #APDoc (
  Acct                 char               (10), 
  AddlCost             smallint               ,
  ApplyAmt             float                  ,
  ApplyDate            smalldatetime          ,
  ApplyRefNbr          char               (10), 
  BatNbr               char               (10), 
  BatSeq               int                    ,
  CashAcct             char               (10), 
  CashSub              char               (24), 
  ClearAmt             float                  ,
  ClearDate            smalldatetime          ,
  CpnyID               char               (10), 
  Crtd_DateTime        smalldatetime          ,
  Crtd_Prog            char               (8) ,
  Crtd_User            char               (10), 
  CurrentNbr           smallint               ,
  CuryDiscBal          float                  ,
  CuryDiscTkn          float                  ,
  CuryDocBal           float                  ,
  CuryEffDate          smalldatetime          ,
  CuryId               char               (4) ,
  CuryMultDiv          char               (1) ,
  CuryOrigDocAmt       float                  ,
  CuryPmtAmt           float                  ,
  CuryRate             float                  ,
  CuryRateType         char               (6) ,
  CuryTaxTot00         float                  ,
  CuryTaxTot01         float                  ,
  CuryTaxTot02         float                  ,
  CuryTaxTot03         float                  ,
  CuryTxblTot00        float                  ,
  CuryTxblTot01        float                  ,
  CuryTxblTot02        float                  ,
  CuryTxblTot03        float                  ,
  Cycle                smallint               ,
  DfltDetail           smallint               ,
  DirectDeposit        char               (1) ,
  DiscBal              float                  ,
  DiscDate             smalldatetime          ,
  DiscTkn              float                  ,
  Doc1099              smallint               ,
  DocBal               float                  ,
  DocClass             char               (1) ,
  DocDate              smalldatetime          ,
  DocDesc              char               (30), 
  DocType              char               (2) ,
  DueDate              smalldatetime          ,
  Econfirm             char               (18), 
  Estatus              char               (1) ,
  InstallNbr           smallint               ,
  InvcDate             smalldatetime          ,
  InvcNbr              char               (15), 
  LCCode               char               (10), 
  LineCntr             int                    ,
  LUpd_DateTime        smalldatetime          ,
  LUpd_Prog            char               (8) ,
  LUpd_User            char               (10), 
  MasterDocNbr         char               (10), 
  NbrCycle             smallint               ,
  NoteID               int                    ,
  OpenDoc              smallint               ,
  OrigDocAmt           float                  ,
  PayDate              smalldatetime          ,
  PayHoldDesc          char               (30), 
  PC_Status            char               (1) ,
  PerClosed            char               (6) ,
  PerEnt               char               (6) ,
  PerPost              char               (6) ,
  PmtAmt               float                  ,
  PmtID                char               (10), 
  PmtMethod            char               (1) ,
  PONbr                char               (10), 
  PrePay_RefNbr        char               (10), 
  ProjectID            char               (16), 
  RefNbr               char               (10), 
  [Retention]          smallint               ,
  RGOLAmt              float                  ,
  Rlsed                smallint               ,
  S4Future01           char               (30), 
  S4Future02           char               (30), 
  S4Future03           float                  ,
  S4Future04           float                  ,
  S4Future05           float                  ,
  S4Future06           float                  ,
  S4Future07           smalldatetime          ,
  S4Future08           smalldatetime          ,
  S4Future09           int                    ,
  S4Future10           int                    ,
  S4Future11           char               (10), 
  S4Future12           char               (10), 
  Selected             smallint               ,
  [Status]             char               (1) ,
  Sub                  char               (24), 
  TaxCntr00            smallint               ,
  TaxCntr01            smallint               ,
  TaxCntr02            smallint               ,
  TaxCntr03            smallint               ,
  TaxId00              char               (10), 
  TaxId01              char               (10), 
  TaxId02              char               (10), 
  TaxId03              char               (10), 
  TaxTot00             float                  ,
  TaxTot01             float                  ,
  TaxTot02             float                  ,
  TaxTot03             float                  ,
  Terms                char               (2) ,
  TxblTot00            float                  ,
  TxblTot01            float                  ,
  TxblTot02            float                  ,
  TxblTot03            float                  ,
  User1                char               (30), 
  User2                char               (30), 
  User3                float                  ,
  User4                float                  ,
  User5                char               (10), 
  User6                char               (10), 
  User7                smalldatetime          ,
  User8                smalldatetime          ,
  VendId               char               (15) 
)                                             

CREATE TABLE #APTran(
  Acct                 char               (10),
  AcctDist             smallint               ,
  AlternateID          char               (30),
  BatNbr               char               (10),
  BOMLineRef           char               (5) ,
  BoxNbr               char               (2) ,
  Component            char               (30),
  CostType             char               (8) ,
  CostTypeWO           char               (2) ,
  CpnyID               char               (10),
  Crtd_DateTime        smalldatetime          ,
  Crtd_Prog            char               (8) ,
  Crtd_User            char               (10),
  CuryId               char               (4) ,
  CuryMultDiv          char               (1) ,
  CuryPOExtPrice       float                  ,
  CuryPOUnitPrice      float                  ,
  CuryPPV              float                  ,
  CuryRate             float                  ,
  CuryTaxAmt00         float                  ,
  CuryTaxAmt01         float                  ,
  CuryTaxAmt02         float                  ,
  CuryTaxAmt03         float                  ,
  CuryTranAmt          float                  ,
  CuryTxblAmt00        float                  ,
  CuryTxblAmt01        float                  ,
  CuryTxblAmt02        float                  ,
  CuryTxblAmt03        float                  ,
  CuryUnitPrice        float                  ,
  DrCr                 char               (1) ,
  Employee             char               (10),
  EmployeeID           char               (10),
  Excpt                smallint               ,
  ExtRefNbr            char               (15),
  FiscYr               char               (4) ,
  InstallNbr           smallint               ,
  InvcTypeID           char               (10),
  InvtID               char               (30),
  JobRate              float                  ,
  JrnlType             char               (3) ,
  Labor_Class_Cd       char               (4) ,
  LCCode               char               (10),
  LineId               int                    ,
  LineNbr              smallint               ,
  LineRef              char               (5) ,
  LineType             char               (1) ,
  LUpd_DateTime        smalldatetime          ,
  LUpd_Prog            char               (8) ,
  LUpd_User            char               (10),
  MasterDocNbr         char               (10),
  NoteID               int                    ,
  PC_Flag              char               (1) ,
  PC_ID                char               (20),
  PC_Status            char               (1) ,
  PerEnt               char               (6) ,
  PerPost              char               (6) ,
  PmtMethod            char               (1) ,
  POExtPrice           float                  ,
  POLineRef            char               (5) ,
  PONbr                char               (10),
  POQty                float                  ,
  POUnitPrice          float                  ,
  PPV                  float                  ,
  ProjectID            char               (16),
  Qty                  float                  ,
  QtyVar               float                  ,
  RcptLineRef          char               (5) ,
  RcptNbr              char               (10),
  RcptQty              float                  ,
  RefNbr               char               (10),
  Rlsed                smallint               ,
  S4Future01           char               (30),
  S4Future02           char               (30),
  S4Future03           float                  ,
  S4Future04           float                  ,
  S4Future05           float                  ,
  S4Future06           float                  ,
  S4Future07           smalldatetime          ,
  S4Future08           smalldatetime          ,
  S4Future09           int                    ,
  S4Future10           int                    ,
  S4Future11           char               (10),
  S4Future12           char               (10),
  ServiceDate          smalldatetime          ,
  SiteId               char               (10),
  SoLineRef            char               (5) ,
  SOOrdNbr             char               (15),
  SOTypeID             char               (4) ,
  Sub                  char               (24),
  TaskID               char               (32),
  TaxAmt00             float                  ,
  TaxAmt01             float                  ,
  TaxAmt02             float                  ,
  TaxAmt03             float                  ,
  TaxCalced            char               (1) ,
  TaxCat               char               (10),
  TaxId00              char               (10),
  TaxId01              char               (10),
  TaxId02              char               (10),
  TaxId03              char               (10),
  TaxIdDflt            char               (10),
  TranAmt              float                  ,
  TranClass            char               (1) ,
  TranDate             smalldatetime          ,
  TranDesc             char               (30),
  trantype             char               (2) ,
  TxblAmt00            float                  ,
  TxblAmt01            float                  ,
  TxblAmt02            float                  ,
  TxblAmt03            float                  ,
  UnitDesc             char               (10),
  UnitPrice            float                  ,
  User1                char               (30),
  User2                char               (30),
  User3                float                  ,
  User4                float                  ,
  User5                char               (10),
  User6                char               (10),
  User7                smalldatetime          ,
  User8                smalldatetime          ,
  VendId               char               (15),
  WONbr                char               (10),
  WOStepNbr            char               (5) 
)                                             

  
  -- ******************************************************************************** --
  -- Create Batch
  -- ******************************************************************************** --
  
  declare @sBatnbr            char(10),
          @iRetVal            int,
          @sRetMsg            varchar(255),
          @sPerPost           char(6),
          @sRefNbr            char(10) ,
          @iDonovanDtlKey     int      ,
          @sAccount           char(25) ,
          @tInvoiceDate       smalldatetime,
          @sInvNbr            char(50) ,
          @sChkNbr            char(25) ,
          @fCurDebit          float    ,
          @sPrintPayees       char(10) ,
          @sVendID            char(15) ,
          @sAcct              char(10) ,
          @sSub               char(24) ,
          @sTranDesc          varchar(100),
          @sUser1             char(30),
          @fCtrlTot           float
              
  
  set @sBatNbr = NULL
  set @sPerPost = NULL
  
  EXEC xspCreatePendAPBatch
    'DALLAS',                           -- @psCpnyID   
    @sPerPost,                          -- @psPerPost  
    NULL,                               -- @psUser1    
    NULL,                               -- @psUser2    
    NULL,                               -- @pfUser3    
    NULL,                               -- @pfUser4    
    NULL,                               -- @psUser5    
    NULL,                               -- @psUser6    
    NULL,                               -- @ptUser7    
    NULL,                               -- @ptUser8    
    @sBatNbr OUTPUT,                    -- @osBatNbr   
    @iRetVal OUTPUT,                    -- @oiRetVal   
    @sRetMsg OUTPUT                     -- @osRetMsg   

  DECLARE curDonovanDtl CURSOR FOR
    SELECT DonovanDtlKey FROM xiwDonovanDtl WHERE DonovanHdrKey = @iDonovanHdrKey AND ImportStatus = 0

  OPEN curDonovanDtl
  FETCH NEXT FROM curDonovanDtl INTO @iDonovanDtlKey
  
  WHILE (@@FETCH_STATUS <> -1) BEGIN 
    
    -- Get Details from record
    SELECT
      @sAccount = Account
      ,@tInvoiceDate = InvoiceDate
      ,@sInvNbr = InvNbr
      ,@sChkNbr = ChkNbr
      ,@fCurDebit = CurDebit
      ,@sPrintPayees = PrintPayees
    FROM
      xiwDonovanDtl
    WHERE
      DonovanDtlKey = @iDonovanDtlKey

    -- Get the Vendor ID to use
    SELECT
      @sVendID = VendID
    FROM
      Vendor
    WHERE
      User1 = @sAccount
    
    SET
      @sUser1 = RTRIM(ISNULL(@sChkNbr,'')) + ' - ' + RTRIM(ISNULL(@sAccount, ''))
              
    EXEC xspCreatePendAPDoc
      @sBatNbr ,                          -- @psBatNbr       
      NULL,                               -- @psDocType      
      @sVendID,                           -- @psVendID       
      NULL,                               -- @ptDocDate      
      @sInvNbr,                           -- @psInvcNbr      
      @tInvoiceDate,                      -- @ptInvcDate     
      NULL,                               -- @psTerms        
      @fCurDebit,                         -- @pfOrigDocAmt   
      NULL,                               -- @pfDiscBal      
      NULL,                               -- @ptDiscDate     
      NULL,                               -- @ptDueDate      
      NULL,                               -- @ptPayDate      
      @sUser1,                            -- @psUser1        
      NULL,                               -- @psUser2        
      NULL,                               -- @pfUser3        
      NULL,                               -- @pfUser4        
      NULL,                               -- @psUser5        
      NULL,                               -- @psUser6        
      NULL,                               -- @ptUser7        
      NULL,                               -- @ptUser8        
      @sRefNbr   OUTPUT,                  -- @osRefNbr       
      @iRetVal   OUTPUT,                  -- @oiRetVal       
      @sRetMsg   OUTPUT                   -- @osRetMsg       
      
    -- Set the Acct/Sub based on the PrintPayess Data
    SELECT
      @sAcct = CASE @sPrintPayees 
                 WHEN 'SS' THEN '2005' 
                 WHEN 'SP' THEN '2010' 
                 ELSE '2010' END,
      @sSub = CASE @sPrintPayees 
                 WHEN 'SS' THEN '0000' 
                 WHEN 'SP' THEN '0000' 
                 ELSE '0000' END
                 
    SELECT
      @sTranDesc = CASE @sPrintPayees 
                     WHEN 'SS' THEN 'Spot Reg' 
                     WHEN 'SP' THEN 'Print Reg' 
                     WHEN 'SQ' THEN 'Print Canada'
                     WHEN 'ST' THEN 'Spot Canada'
                     ELSE @sPrintPayees END
                 
    /*
    -- Testing on 0060 company - remove
    SELECT
      @sAcct = CASE @sPrintPayees 
                 WHEN 'SS' THEN '1030' 
                 WHEN 'SP' THEN '1030' 
                 ELSE '1030' END,
      @sSub = CASE @sPrintPayees 
                 WHEN 'SS' THEN '01100AA00001' 
                 WHEN 'SP' THEN '01100AA00001' 
                 ELSE '01100AA00001' END
    */
    
    EXEC xspCreatePendAPTran 
      @sBatNbr,                           -- @psBatNbr     
      @sRefNbr,                           -- @psRefNbr     
      NULL,                               -- @psLineType   
      @sAcct,                             -- @psAcct       
      @sSub,                              -- @psSub        
      NULL,                               -- @psLCCode     
      NULL,                               -- @pfQty        
      NULL,                               -- @psUnitDesc   
      NULL,                               -- @pfUnitPrice  
      @fCurDebit,                         -- @pfTranAmt    
      NULL,                               -- @psBoxNbr     
      @sTranDesc,                         -- @psTranDesc   
      NULL,                               -- @psExtRefNbr  
      NULL,                               -- @psEmployeeID 
      NULL,                               -- @psUser1      
      NULL,                               -- @psUser2      
      NULL,                               -- @pfUser3      
      NULL,                               -- @pfUser4      
      NULL,                               -- @psUser5      
      NULL,                               -- @psUser6      
      NULL,                               -- @ptUser7      
      NULL,                               -- @ptUser8      
      @iRetVal  OUTPUT,                   -- @oiRetVal     
      @sRetMsg  OUTPUT                    -- @osRetMsg    
    
    EXEC xspCompletePendAPDoc
      @sRefNbr,
      @iRetVal  OUTPUT,                   -- @oiRetVal     
      @sRetMsg  OUTPUT                    -- @osRetMsg      

    -- Update the Source Dtl Record 
    UPDATE
      xiwDonovanDtl
    SET
      ImportAPRefNbr = @sRefNbr
      ,ImportStatus = 1
    WHERE
      DonovanDtlKey = @iDonovanDtlKey
    
    FETCH NEXT FROM curDonovanDtl INTO @iDonovanDtlKey
  END
     
  CLOSE curDonovanDtl
  DEALLOCATE curDonovanDtl  
      
  EXEC xspCommitPendAPBatch
    @sBatnbr,
    @iRetVal  OUTPUT,                   -- @oiRetVal     
    @sRetMsg  OUTPUT                    -- @osRetMsg       

  -- Get the Control Total to put in our log table
  SELECT
    @fCtrlTot = CtrlTot
  FROM
    Batch
  WHERE
    Module = 'AP' 
    AND BatNbr = @sBatNbr
    
  -- Update the Source Hdr Record 
  UPDATE
    xiwDonovanHdr
  SET
    APBatNbr = @sBatnbr
    ,APBatTot = @fCtrlTot
  WHERE
    DonovanHdrKey = @iDonovanHdrKey

  -- Set the return value
  SET @sAPBatNbr = @sBatNbr
GO
