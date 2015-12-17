USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_LaborClass]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_LaborClass] @parm1 varchar ( 10) as
	Select * from RtgTran,BomDoc where
	RtgTran.RefNbr = BomDoc.RefNbr and
	RtgTran.LaborClassID = @parm1 and
	BomDoc.Status <> 'C'
	order by RtgTran.RefNbr
GO
