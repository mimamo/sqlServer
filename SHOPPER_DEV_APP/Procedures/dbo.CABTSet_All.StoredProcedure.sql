USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CABTSet_All]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CABTSet_All    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CABTSet_All] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (10), @parm4 varchar (24) as
Select * from CABTSet
where setupid like @parm1
and cpnyid like @parm2
and bankacct like @parm3
and banksub like @parm4
Order by setupid, cpnyid, bankacct, banksub
GO
