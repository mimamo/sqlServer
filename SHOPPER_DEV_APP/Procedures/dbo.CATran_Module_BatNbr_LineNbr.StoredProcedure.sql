USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_Module_BatNbr_LineNbr]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_Module_BatNbr_LineNbr    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[CATran_Module_BatNbr_LineNbr] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3beg smallint, @parm3end smallint, @parm4 varchar ( 10) as
Select * from CATran where Module = @parm1 and BatNbr = @parm2
and LineNbr between @parm3beg and @parm3end and CpnyID like @parm4
Order by Module, BatNbr, LineNbr
GO
