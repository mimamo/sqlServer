USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AllocSrc_GrpId]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocSrc_GrpId    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocSrc_GrpId] @parm1 varchar ( 6), @parm2 varchar ( 10), @parm3 varchar ( 24) as
       Select * from AllocSrc
           where GrpId =    @parm1
             and Acct  like @parm2
             and Sub   like @parm3
           order by GrpId, Acct, Sub
GO
