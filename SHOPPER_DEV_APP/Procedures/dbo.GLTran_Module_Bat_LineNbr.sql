USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_Module_Bat_LineNbr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[GLTran_Module_Bat_LineNbr] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 integer as
Select * from GLTran
where Module = @parm1
and BatNbr = @parm2
and LineNbr = @parm3
GO
