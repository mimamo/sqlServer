USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwSaveDonovanHdr]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xiwSaveDonovanHdr]
	(
	   @iDonovanHdrKey int OUTPUT
	  ,@sAPBatNbr  char (10)
	  ,@sCrtd_User char (50)
	)

AS

  IF EXISTS(SELECT DonovanHdrKey FROM xiwDonovanHdr WHERE DonovanHdrKey = @iDonovanHdrKey) BEGIN
    -- We only update the APBatNbr on existing records
    UPDATE
      xiwDonovanHdr
    SET
      APBatNbr = @sAPBatNbr  
    WHERE
      DonovanHdrKey = @iDonovanHdrKey
    END
  ELSE BEGIN
    INSERT INTO xiwDonovanHdr (
       APBatNbr   
      ,APBatTot
      ,Crtd_DateTime   
      ,Crtd_User )
    VALUES (
       COALESCE(@sAPBatNbr, '')
      ,0
      ,GETDATE()
      ,COALESCE(@sCrtd_User, 'SYSADMIN'))
  
    -- Return the Identity of the newly created row
    SELECT @iDonovanHdrKey = @@IDENTITY
  
  END
GO
