USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOINTran_Inventory]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOINTran_Inventory]
   @BatNbr     varchar( 10 ),
   @TranType   varchar( 2  )

AS
   SELECT      *
   FROM        INTran LEFT JOIN Inventory
               ON INTran.InvtID = Inventory.InvtID
   WHERE       INTran.Rlsed = 1 and
               INTran.TranType = @TranType and
               INTran.BatNbr = @BatNbr
   ORDER BY    INTran.BatNbr, INTran.LineNbr
GO
