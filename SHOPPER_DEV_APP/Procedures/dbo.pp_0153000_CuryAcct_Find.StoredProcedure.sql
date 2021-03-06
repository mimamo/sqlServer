USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_0153000_CuryAcct_Find]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[pp_0153000_CuryAcct_Find] @parm1 varchar(10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 24), @parm5 varchar ( 4), @parm6 varchar ( 4) as
SELECT *
  FROM  CuryAcct
  WHERE CpnyID    =    @parm1
     and Acct     =    @parm2
     and Sub      =    @parm3
     and LedgerID =    @parm4
     and FiscYr   =    @parm5
     and CuryID   =    @parm6
Order by CpnyID, Acct, Sub, LedgerID, FiscYr, CuryID
GO
