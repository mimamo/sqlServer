USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_LineNbr2]    Script Date: 12/21/2015 14:34:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_BatNbr_LineNbr2] @parm1 varchar ( 10), @parm2 varchar (10), @parm3beg smallint, @parm3end smallint as
Select *
from PRTran
	left outer join EarnType
		on PRTran.EarnDedId = EarnType.Id
where PRTran.BatNbr = @parm1
	and PRTran.EmpId like @parm2
	and PRTran.LineNbr BETWEEN @parm3beg and @parm3end
order by PRTran.LineNbr
GO
