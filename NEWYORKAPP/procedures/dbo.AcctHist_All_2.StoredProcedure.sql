USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[AcctHist_All_2]    Script Date: 12/21/2015 16:00:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AcctHist_All_2] 
@parm1 varchar(10), 
@parm2 varchar ( 10), 
@parm3 varchar ( 24), 
@parm4 varchar ( 10), 
@parm5 varchar ( 4) as
	Select * 
	from AcctHist
    where CpnyID = @parm1
		and Acct = @parm2
		and Sub = @parm3
		and LedgerID = @parm4
		and FiscYr = @parm5
	order by CpnyID, Acct, Sub, Ledgerid, FiscYr
GO
