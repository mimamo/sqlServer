USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_RefNbr_LnNbr]    Script Date: 12/21/2015 15:43:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_RefNbr_LnNbr] @parm1 varchar ( 15), @parm2beg smallint, @parm2end smallint as
       Select * from RtgTran,Operation where RefNbr = @parm1 and LineNbr between
       @parm2beg and @parm2end and Operation.OperationID = RtgTran.OperationID
	order by RefNbr, LineNbr
GO
