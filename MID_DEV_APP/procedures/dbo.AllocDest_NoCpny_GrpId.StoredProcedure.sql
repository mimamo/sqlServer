USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocDest_NoCpny_GrpId]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocDest_NoCpny_GrpId    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocDest_NoCpny_GrpId] @parm1 varchar ( 6), @parm2 varchar ( 10), @parm3 varchar ( 24) as
       Select * from AllocDest
           where GrpId =    @parm1
             and Acct  like @parm2
             and Sub   like @parm3
           order by GrpId, Acct, Sub
GO
