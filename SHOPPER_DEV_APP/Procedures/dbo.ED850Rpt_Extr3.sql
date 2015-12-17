USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Rpt_Extr3]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Rpt_Extr3] @CpnyID varchar(10), @EDIPoId varchar(10), @LineID int AS
SELECT Indicator, CuryTotAmt, Qty, LDiscRate, Pct FROM ED850LDisc
where CpnyId = @CpnyID and
EDIPOId = @EDIPOID and
LineID = @LineId and
Indicator = 'A'
ORDER BY CpnyID, EDIPoId, LineID, LineNbr, CuryTotAmt
GO
