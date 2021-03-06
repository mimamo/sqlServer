USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_AR_2]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_AR_2]
   @CustID	varchar( 15 ),
   @DocType	varchar( 2 ),
   @RefNbr	varchar( 10 ),
   @BatNbr	varchar( 10 )

AS

	-- ARDoc unique index: CustId, DocType, RefNbr, BatNbr, BatSeq

   	SELECT		A.*, C.*
   	FROM		ARDoc A (NoLock) LEFT OUTER JOIN Customer C (nolock)
   			ON A.CustID = C.CustID
   	WHERE		A.CustID = @CustID
			and A.DocType = @DocType
			and A.RefNbr = @RefNbr
			and A.BatNbr = @BatNbr
--   			and A.BatSeq = @BatSeq
GO
