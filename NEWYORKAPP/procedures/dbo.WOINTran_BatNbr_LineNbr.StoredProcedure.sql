USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOINTran_BatNbr_LineNbr]    Script Date: 12/21/2015 16:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOINTran_BatNbr_LineNbr]
   @BatNbr    varchar( 10 ),
   @TranType  varchar( 2 )
AS
   SELECT     *
   FROM       INTran
   WHERE      BatNbr =  @BatNbr and
              TranType = @TranType
   ORDER BY   BatNbr, LineNbr
GO
