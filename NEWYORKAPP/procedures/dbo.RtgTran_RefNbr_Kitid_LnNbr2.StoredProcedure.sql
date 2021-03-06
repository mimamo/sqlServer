USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_RefNbr_Kitid_LnNbr2]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_RefNbr_Kitid_LnNbr2] @parm1 varchar(15), @parm2beg smallint, @parm2end smallint as
       Select * from RtgTran, Operation where RefNbr = @parm1 and
       		 LineNbr between @parm2beg and @parm2end and
       		 Operation.OperationId = RtgTran.OperationId
	     	 order by Refnbr,Kitid,Linenbr
GO
