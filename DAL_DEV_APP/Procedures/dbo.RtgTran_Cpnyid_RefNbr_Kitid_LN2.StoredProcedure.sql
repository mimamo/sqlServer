USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_Cpnyid_RefNbr_Kitid_LN2]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_Cpnyid_RefNbr_Kitid_LN2] @parm1 varchar(10), @parm2 varchar (15),
	@parm3beg smallint, @parm3end smallint as
       Select * from RtgTran, Operation where
		Rtgtran.cpnyid = @parm1 and
		Rtgtran.RefNbr = @parm2 and
       	Rtgtran.LineNbr between @parm3beg and @parm3end and
		RtgTran.cpnyid = Operation.cpnyid and
       		 RtgTran.OperationId = Operation.OperationId
	     	 order by RtgTran.cpnyid , RtgTran.Refnbr, RtgTran.Kitid, RtgTran.Linenbr
GO
