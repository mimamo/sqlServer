USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_LineSummary_NoZero]    Script Date: 12/21/2015 15:36:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create PROCEDURE [dbo].[EDSOShipLine_LineSummary_NoZero] @Parm1 varchar( 10 ), @Parm2 varchar( 15 ) AS

SELECT count(*),sum(qtyship)
  FROM SOShipLine
 WHERE CpnyId = @parm1
   AND ShipperId = @Parm2
   AND QtyShip <> 0
GO
