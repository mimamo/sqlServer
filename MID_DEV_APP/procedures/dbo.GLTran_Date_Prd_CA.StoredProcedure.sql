USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_Date_Prd_CA]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLTran_Date_Prd_CA    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[GLTran_Date_Prd_CA]
	@parm1 varchar (10),
	@parm2 varchar (24),
	@parm3 smalldatetime,
	@parm4 varchar (6),
	@parm5 varchar ( 10),
	@parm6 as varchar (10)
as
Select * from gltran
Where acct = @parm1
and sub = @parm2
and TranDate = @parm3
and PerPost = @parm4
and rlsed = 1
and CpnyID = @parm5
and Module = 'GL'
and TranType <> 'ZZ'
and ledgerid = @parm6
Order by acct, sub, refnbr
option (fast 100)
GO
