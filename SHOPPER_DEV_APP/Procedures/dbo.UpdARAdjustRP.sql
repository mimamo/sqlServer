USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[UpdARAdjustRP]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[UpdARAdjustRP] @parm1 varchar ( 15), @parm2 varchar ( 2), @parm3 varchar ( 10),
@parm4 varchar (10) as

    Update ARAdjust set S4Future11 = @parm4
	   where CustId = @parm1
           and AdjgDocType = @parm2
           and AdjgRefNbr = @parm3
	   and AdjAmt < 0
GO
