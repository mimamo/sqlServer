USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xspCompletePendAPDoc]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xspCompletePendAPDoc] 
(
  @psRefNbr               char(10),    
  @oiRetVal               int            OUTPUT,
  @osRetMsg               varchar(255)   OUTPUT
)

AS

  -- 1) It will update the APTran records (record id, etc)
  -- 2) It will update the ARDoc records (Line ID)

  SET NOCOUNT ON
  
  DECLARE @iLineNbr       smallint,                     -- APTran LineNbr 
          @iLineID        int,                          -- APTran LineId
          @fTranAmt       float,                        -- Used in retrieving the transaction Total from all APTrans in Document
          @fDocBal        float                         -- Used in retrieving the document balance

  
  -- ********************************************************************** --
  -- Update the APTran Records
  -- ********************************************************************** --
  -- Reset the LineNbr seed
  SET @iLineNbr = -32768
  SET @iLineID = 0
  
  UPDATE 
    #APTran
  SET 
    @iLineNbr = LineNbr = @iLineNbr + 256,
    @iLineID = LineID = @iLineID + 1
  WHERE
    RefNbr = @psRefNbr
    
  UPDATE 
    #APTran
  SET
    LineNbr = LineNbr - 256,               -- The above statement starts the counting at 32512, so this sets it back     
    LineRef = CAST(LineID as varchar)
  WHERE
    RefNbr = @psRefNbr
  
  -- ********************************************************************** --
  -- Update the APDoc Records
  -- ********************************************************************** --
  -- Update the APDoc records
  SELECT
    @iLineID = MAX(LineID)
  FROM
    #APTran
  WHERE
    RefNbr = @psRefNbr
    
  UPDATE 
    #APDoc
  SET
    LineCntr = @iLineID
  WHERE
    RefNbr = @psRefNbr
  
  IF EXISTS (SELECT * FROM #APTran WHERE RefNbr = @psRefNbr AND BoxNbr <> '')
    UPDATE
      #APDoc
    SET
      Doc1099 = 1
    WHERE 
      RefNbr = @psRefNbr
        
  
  -- ********************************************************************** --
  -- Verify Document Balances
  -- ********************************************************************** --
  
  -- Get the values from any existing records (if we are adding to the batch)
  SELECT
    @fTranAmt = SUM(TranAmt)
  FROM
    #APTran
  WHERE 
    RefNbr = @psRefNbr

  SELECT
    @fDocBal = DocBal
  FROM
    #APDoc
  WHERE
    RefNbr = @psRefNbr
    
  IF ROUND(@fTranAmt,2) <> ROUND(@fDocBal,2) BEGIN
    SELECT
      @oiRetVal = -1,
      @osRetMsg = 'Document out of balance'
    RETURN
  END
  
  -- If we got this far, then the batch was created
  SELECT
    @oiRetVal = 0,
    @osRetMsg = ''
GO
