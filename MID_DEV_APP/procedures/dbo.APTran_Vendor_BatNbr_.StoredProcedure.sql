USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_Vendor_BatNbr_]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APTran_Vendor_BatNbr_] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint, @parm3 varchar ( 10), @parm4 varchar ( 24) as
Select APTran.*, APDoc.*
from APTran
	left outer join APDoc
		on APTran.RefNbr = APDoc.RefNbr
where APTran.BatNbr = @parm1
and APTran.LineNbr between @parm2beg and @parm2end
and APDoc.DocClass = 'C'
and APDoc.Acct = @parm3
and APDoc.Sub = @parm4
order by APTran.BatNbr, APTran.LineNbr
GO
