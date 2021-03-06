USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_Module_BatNbr_LineNbr]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLTran_Module_BatNbr_LineNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLTran_Module_BatNbr_LineNbr] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3beg smallint, @parm3end smallint as
       Select * from GLTran
           where Module  = @parm1
             and BatNbr  = @parm2
             and LineNbr between @parm3beg and @parm3end
           order by Module, BatNbr, LineNbr
GO
