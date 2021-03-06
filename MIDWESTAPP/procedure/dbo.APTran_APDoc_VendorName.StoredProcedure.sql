USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_APDoc_VendorName]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APTran_APDoc_VendorName] 
	@parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint, @parm3 varchar ( 10), @parm4 varchar ( 24)
AS

	Select APTran.*, APDoc.*, Vendor.name
	from APTran
		left outer join APDoc
			on APTran.RefNbr = APDoc.RefNbr
		left outer join Vendor
			on APTran.VendID = Vendor.VendID
	where APTran.BatNbr = @parm1
	and APTran.LineNbr between @parm2beg and @parm2end
	and APDoc.DocClass = 'C'
	and APDoc.Acct = @parm3
	and APDoc.Sub = @parm4
	order by APTran.BatNbr, APTran.LineNbr
GO
