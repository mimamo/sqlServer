USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwSaveDonovanDtl]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xiwSaveDonovanDtl]
	(
     @iDonovanDtlKey         int OUTPUT
    ,@iDonovanHdrKey         int
		,@sAccount               char(25)
    ,@tInvoiceDate           smalldatetime
		,@sInvNbr                char(50)
		,@sChkNbr                char (25)
		,@fCurDebit              float
		,@fCurBal                float  
		,@sPrintPayees           char (10)
		,@sImportAPRefNbr        char (10)
		,@iImportStatus          int  
		,@sImportMsg             char (255)
	)

AS

  /* If the user passes a 0 for the DonovanDtlKey we will be inserting the new record.  If the user passes and 
     existing key it will be updated.  Either way the key will be returned to the user
  */
  
  IF EXISTS(SELECT DonovanDtlKey FROM xiwDonovanDtl WHERE DonovanDtlKey = @iDonovanDtlKey) BEGIN
    -- We only update the Import Status columns on existing records
    UPDATE
      xiwDonovanDtl
    SET
       ImportAPRefNbr = @sImportAPRefNbr        
      ,ImportStatus = @iImportStatus          
      ,ImportMsg = @sImportMsg            
    WHERE
      DonovanDtlKey = @iDonovanDtlKey
    END
  ELSE BEGIN
    INSERT INTO xiwDonovanDtl (
       DonovanHdrKey
      ,Account
      ,InvoiceDate
      ,InvNbr 
      ,ChkNbr 
      ,CurDebit 
      ,CurBal 
      ,PrintPayees 
      ,ImportAPRefNbr 
      ,ImportStatus 
      ,ImportMsg 
    )
    VALUES (
       @iDonovanHdrKey    
      ,@sAccount    
      ,@tInvoiceDate
      ,ISNULL(@sInvNbr,'')           
      ,ISNULL(@sChkNbr, '')            
      ,@fCurDebit         
      ,@fCurBal           
      ,@sPrintPayees      
      ,@sImportAPRefNbr   
      ,@iImportStatus     
      ,@sImportMsg              
    )

    -- Return the Identity of the newly created row
    SELECT @iDonovanDtlKey = @@IDENTITY
  
  END
GO
