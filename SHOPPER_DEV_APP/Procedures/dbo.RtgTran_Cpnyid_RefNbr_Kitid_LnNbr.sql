USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_Cpnyid_RefNbr_Kitid_LnNbr]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_Cpnyid_RefNbr_Kitid_LnNbr] @parm1 varchar ( 10),
	@parm2 varchar (15), @parm3 varchar (30), @parm4beg smallint , @parm4end smallint  as
       Select * from RtgTran, Operation where
		Rtgtran.cpnyid = @parm1 and
		RefNbr = @parm2 and
		KitId = @parm3 and
		LineNbr between @parm4beg and @parm4end and
		rtgtran.cpnyid = operation.cpnyid and
		RtgTran.OperationId = Operation.OperationId
		 order by Rtgtran.Cpnyid, Rtgtran.Refnbr,Rtgtran.Kitid, Rtgtran.LineNbr
GO
