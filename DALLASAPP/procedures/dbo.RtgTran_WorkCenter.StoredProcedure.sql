USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_WorkCenter]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_WorkCenter] @parm1 varchar ( 10) as
	Select * from RtgTran,BomDoc where
	RtgTran.RefNbr = BomDoc.RefNbr and
	RtgTran.Workcenterid = @parm1 and
	BomDoc.Status <> 'C'
	order by Rtgtran.RefNbr
GO
