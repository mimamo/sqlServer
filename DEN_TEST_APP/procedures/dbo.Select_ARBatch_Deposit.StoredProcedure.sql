USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Select_ARBatch_Deposit]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[Select_ARBatch_Deposit]  @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime as
Select * from batch where
cpnyid = @parm1
and bankacct = @parm2
and banksub = @parm3
and (dateent >= @parm4 and dateent <= @parm5)
and rlsed = 1
and module = 'AR'
and battype <> 'C'
order by batnbr, dateent
GO
