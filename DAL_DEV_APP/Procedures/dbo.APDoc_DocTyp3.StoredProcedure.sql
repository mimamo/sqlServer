USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_DocTyp3]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APDoc_DocTyp3] @parm1 varchar ( 255), @parm2 varchar ( 4), @parm3 varchar ( 10) as
Select CuryDiscBal,CuryDiscTkn,CuryDocBal,CuryPmtAmt,DiscBal,DiscDate,DiscTkn,
DocBal,DocDate,DocType,DueDate,InvcDate,InvcNbr,OrigDocAmt,PayDate,PmtAmt,PONbr,
RefNbr, Selected, APDoc.Status, APDoc.VendID,MultiChk, Name, Vendor.Status
from APDoc
	left outer join Vendor
		on APDoc.VendId = Vendor.VendId
where
APDoc.DocType  in ('AC', 'AD', 'VO')
and APDoc.Status in ('A', @parm1)
and APDoc.CuryId = @parm2
and APDoc.RefNbr  like  @parm3
and APDoc.OpenDoc  =  1
and APDoc.Rlsed    =  1
and APDoc.Selected = 0
Order by RefNbr, DocType
GO
