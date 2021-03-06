USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_Cpnyid_RefNbr_LnNbr]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_Cpnyid_RefNbr_LnNbr] @parm1 varchar ( 15),
	@parm2 varchar (10), @parm3beg smallint, @parm3end smallint as
       Select * from RtgTran,Operation where
	Rtgtran.Cpnyid = @parm1 and
	Rtgtran.RefNbr = @parm2 and
	Rtgtran.LineNbr between @parm3beg and @parm3end and
	RtgTran.OperationID = Operation.OperationID  and
	Rtgtran.Cpnyid = Operation.Cpnyid
	order by Rtgtran.Cpnyid, Rtgtran.RefNbr, Rtgtran.LineNbr
GO
