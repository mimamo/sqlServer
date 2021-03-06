USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SumICGLTrans]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SumICGLTrans    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[SumICGLTrans] @parm1 varchar(20), @parm2 varchar (10), @parm3 varchar (24), @parm4 varchar (10), @parm5 varchar(15), @parm6 varchar(10), @parm7 varchar(24) as

select sum(gltran.dramt), sum(gltran.curydramt), sum(gltran.cramt), sum(gltran.curycramt) from gltran where
Trantype = "IC" and
id = @parm1 and
origacct = @parm2 and
origsub = @parm3 and
cpnyid = @parm4 and
extrefnbr = @parm5 and
acct = @parm6 and
sub = @parm7
GO
