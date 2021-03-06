USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_RefNbr_Kitid_LnNbr]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_RefNbr_Kitid_LnNbr] @parm1 varchar ( 15), @parm2 varchar (30), @parm3beg smallint , @parm3end smallint  as
       Select * from RtgTran, Operation where
		RefNbr = @parm1 and
		KitId = @parm2 and
		LineNbr between @parm3beg and @parm3end and
		Operation.OperationId = RtgTran.OperationId
		 order by Rtgtran.Refnbr,Rtgtran.Kitid, Rtgtran.LineNbr
GO
