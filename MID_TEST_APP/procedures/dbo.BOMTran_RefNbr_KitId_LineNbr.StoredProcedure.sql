USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_RefNbr_KitId_LineNbr]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOMTran_RefNbr_KitId_LineNbr] @parm1 varchar(15), @parm2 varchar(30), @parm3beg smallint, @parm3end smallint as
   Select * from BOMTran where RefNbr = @parm1 and
		   KitId = @parm2 and
           LineNbr between @parm3beg and @parm3end
       order by RefNbr, KitId, LineNbr
GO
