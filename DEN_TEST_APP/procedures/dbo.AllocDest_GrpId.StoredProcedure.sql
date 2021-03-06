USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocDest_GrpId]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocDest_GrpId    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocDest_GrpId] @parm1 varchar ( 10), @parm2 varchar ( 6), @parm3 varchar ( 10), @parm4 varchar ( 24) as
       Select * from AllocDest
           where CpnyId Like @parm1
             and GrpId =    @parm2
             and Acct  like @parm3
             and Sub   like @parm4
           order by CpnyId, GrpId, Acct, Sub
GO
