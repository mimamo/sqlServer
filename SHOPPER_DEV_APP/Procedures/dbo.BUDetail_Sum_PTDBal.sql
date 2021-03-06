USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUDetail_Sum_PTDBal]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUDetail_Sum_PTDBal    Script Date: 11/12/99 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUDetail_Sum_PTDBal] @Parm1 varchar ( 10), @Parm2 varchar ( 4),
@Parm3 varchar ( 10), @Parm4 varchar(10), @parm5 varchar ( 24) AS
SELECT ROUND((PTDBal00 + PTDBal01 + PTDBal02 +  PTDBal03 + PTDBal04 + PTDBal05 + PTDBal06 + PTDBal07
 + PTDBal08 + PTDBal09 + PTDBal10 + PTDBal11 + PTDBal12), 2) FROM AcctHist WHERE CpnyId = @parm1
 AND FiscYr = @Parm2 and ledgerid = @parm3 AND Acct = @Parm4 And Sub Like @Parm5
 ORDER BY CPnyID, Acct, Sub, Ledgerid, FiscYr DESC
GO
