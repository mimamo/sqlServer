USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_LineNbr_PRDocEmp]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_BatNbr_LineNbr_PRDocEmp] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
Select *
from PRTran
	left outer join PRDoc
		on PRTran.ChkAcct = PRDoc.Acct
		and PRTran.ChkSub = PRDoc.Sub
		and PRTran.RefNbr = PRDoc.ChkNbr
		and PRTran.TranType = PRDoc.DocType
where PRTran.BatNbr = @parm1
	and PRTran.LineNbr BETWEEN @parm2beg and @parm2end
order by PRTran.BatNbr,
	PRTran.ChkAcct,
	PRTran.ChkSub,
	PRTran.RefNbr,
	PRTran.TranType,
	PRTran.LineNbr
GO
