USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_Cpnyid_RefNbr_LineNbr]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOMTran_Cpnyid_RefNbr_LineNbr] @parm1 varchar ( 10), @parm2 varchar (15), @parm3beg smallint, @parm3end smallint as
   Select * from BOMTran where
	Cpnyid = @parm1 and
	RefNbr = @parm2 and
	BOMLineNbr between  @parm3beg and @parm3end
	order by Cpnyid, RefNbr, BOMLineNbr
GO
