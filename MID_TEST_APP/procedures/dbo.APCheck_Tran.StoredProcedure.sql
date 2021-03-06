USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APCheck_Tran]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APCheck_Tran    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APCheck_Tran] @parm1 varchar ( 10), @parm2 varchar ( 2), @parm3 varchar ( 10), @parm4 varchar ( 24), @parm5beg smallint, @parm5end smallint As
Select * from APTran Where
RefNbr = @parm1 And
TranType = @parm2 And
Acct = @parm3 And
Sub = @parm4 And
LineNbr Between @parm5beg and @parm5end
Order By Acct, Sub, RefNbr, LineNbr
GO
