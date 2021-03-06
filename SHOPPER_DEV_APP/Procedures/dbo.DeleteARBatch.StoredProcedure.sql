USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteARBatch]    Script Date: 12/21/2015 14:34:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/********************************************************************************
*             Copyright Solomon Software, Inc. 1994-1999 All Rights Reserved
** Proc Name: DeleteARBatch
** Narrative: Deletes Docs, Trans, and DocTerms of a batch. Sets Batch status to V
** Inputs   : Batch Number, User ID
** Outputs  :
** Called by: 0801000 Application Update1_Delete()
*
*/

CREATE PROCEDURE [dbo].[DeleteARBatch] @BatchNbr VARCHAR(10), @UserID as Char (10) AS

UPDATE BATCH
   SET Status = 'V',
       Rlsed = 1,
       AutoRev = 0,
       LUpd_Prog = '08010',
       LUpd_User = @UserID,
       LUpd_DateTime = GETDATE()
WHERE BatNbr = @BatchNbr and Module = 'AR'

DELETE DOCTERMS
 FROM  DOCTERMS DT  INNER JOIN ARDOC ARD
                 ON  DT.DocType = ARD.DocType And
                     DT.RefNbr  = ARD.RefNbr
 WHERE ARD.BatNbr = @BatchNbr

DELETE ARDoc
  WHERE ARDoc.BatNbr = @BatchNbr

DELETE ARTran
 WHERE ARTran.BatNbr = @BatchNbr
GO
