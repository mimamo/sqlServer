USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSOSched_ReqDate]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSOSched_ReqDate]
   @CpnyID	varchar( 10 ),
   @OrdNbr	varchar( 15 ),
   @LineRef	varchar( 5 )

AS
   SELECT      	S.ReqDate,
   		S.ReqPickDate,
   		S.Hold,
   		H.AdminHold,
   		H.CreditHold
   FROM		SOSched S LEFT OUTER JOIN SOHeader H
   		ON H.CpnyID = S.OrdNbr and H.OrdNbr = S.OrdNbr
   WHERE       	S.CpnyID = @CpnyID and
   		S.OrdNbr = @OrdNbr and
   		S.LineRef = @LineRef
   ORDER BY    	S.ReqDate
GO
