USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CA_Find_APDoc_Date]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_Find_APDoc_Date] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 smalldatetime as
Select * from apdoc
Where cpnyid = @parm1
and acct = @parm2
and sub = @parm3
and RefNbr = @parm4
and DocDate = @parm5
and rlsed = 1
and status <> 'V'
GO
