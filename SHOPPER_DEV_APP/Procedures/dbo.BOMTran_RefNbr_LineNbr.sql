USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_RefNbr_LineNbr]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOMTran_RefNbr_LineNbr] @parm1 varchar ( 15), @parm2beg smallint, @parm2end smallint as
   	Select * from BOMTran where
		RefNbr = @parm1 and
		BOMLineNbr between
       		@parm2beg and @parm2end order by RefNbr, BOMLineNbr
GO
