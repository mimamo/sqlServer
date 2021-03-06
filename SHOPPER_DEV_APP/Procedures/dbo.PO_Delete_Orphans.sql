USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PO_Delete_Orphans]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PO_Delete_Orphans]
	@CpnyId		varchar(10)
AS

       -- Delete PurOrdDet records where PONbr not found in PuchOrd(Header)
          DELETE FROM PurOrdDet
	  WHERE PONbr NOT IN (SELECT PONbr FROM PurchOrd)

       -- Delete POTran records where RcptNbr not Found in POReceipt(Header)
	  DELETE FROM POTran
          WHERE CpnyID = @CpnyId
	  AND RcptNbr NOT IN (SELECT RcptNbr FROM POReceipt WHERE CpnyID = @CpnyId)

       -- Delete POReqDet record where ReqNbr not found in POReqHdr(Header)
          DELETE FROM POReqDet
	  WHERE ReqNbr NOT IN (SELECT ReqNbr FROM POReqHdr)

       -- Delete POAlloc for PONbr that doesnot exist in PurchOrd record
	  DELETE FROM POAlloc
          WHERE PONbr NOT IN (SELECT PONbr FROM PurchOrd)

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
