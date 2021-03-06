USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_Vendor_BatNbr]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[APTran_Vendor_BatNbr] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) as
SELECT APTran.*, APDoc.*, Vendor.*
from APTran
	left outer join APDoc
		on APTran.RefNbr = APDoc.RefNbr
	left outer join Vendor
		on APTran.VendID = Vendor.VendID
WHERE APTran.BatNbr = @parm1              AND
      APDoc.DocClass = 'C'                AND
      APDoc.Acct = @parm2                 AND
      APDoc.Sub = @parm3
ORDER BY APTran.BatNbr, APTran.LineNbr
GO
