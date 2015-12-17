USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_DeleteBatches]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DMG_DeleteBatches]
    @parm1 varchar ( 2), 	-- Module
    @parm2 varchar ( 6), 	-- Module Retention Period
    @parm3 varchar ( 6), 	-- GL Retention Period
    @parm4 Varchar (10)		-- Company ID
As
Delete From Batch
    Where Batch.Module = @parm1
      And PerPost < @parm2
      And PerPost < @parm3
      And Cpnyid = @parm4
      And STATUS IN ('V', 'C', 'P')
GO
