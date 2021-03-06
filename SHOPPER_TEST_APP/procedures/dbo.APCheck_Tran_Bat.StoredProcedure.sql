USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APCheck_Tran_Bat]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APCheck_Tran_Bat    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APCheck_Tran_Bat] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 2), @parm4 varchar ( 10), @parm5 varchar ( 24), @parm6beg smallint, @parm6end smallint As
Select * from APTran Where
BatNbr = @parm1 And
RefNbr = @parm2 And

TranType = @parm3 And
Acct = @parm4 And
Sub = @parm5 And
LineNbr Between @parm6beg and @parm6end
Order By Acct, Sub, RefNbr, LineNbr
GO
