USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARBal_Custid_CpnyID]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARBal_Custid_CpnyID    Script Date: 4/7/98 12:30:32 PM ******/
CREATE PROC [dbo].[ARBal_Custid_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 15) AS
SELECT *
  FROM AR_Balances
 WHERE CpnyID = @parm1
   AND CustID = @parm2
 ORDER BY CpnyID, CustID
GO
