USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CA_Find_PRDoc]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_Find_PRDoc] @CpnyID varchar ( 10), @acct varchar ( 10), @sub varchar ( 24), @ChkNbr
varchar ( 10) as
Select * from PRdoc
Where CpnyID = @CpnyID
and acct = @acct
and sub = @sub
and ChkNbr = @ChkNbr
and rlsed = 1
and status = 'O'
GO
