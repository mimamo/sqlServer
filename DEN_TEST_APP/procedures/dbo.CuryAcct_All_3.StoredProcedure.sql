USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcct_All_3]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[CuryAcct_All_3]
@parm1 varchar(10), 
@parm2 varchar ( 10), 
@parm3 varchar ( 24), 
@parm4 varchar ( 24), 
@parm5 varchar ( 4), 
@parm6 varchar ( 4) as
	Select * 
	from CuryAcct
	where CpnyID = @parm1
		 and Acct = @parm2
		 and Sub = @parm3 
		 and LedgerID = @parm4
		 and FiscYr = @parm5
		 and CuryID like @parm6
	order by CpnyID, Acct, Sub, LedgerID, FiscYr, CuryID
GO
