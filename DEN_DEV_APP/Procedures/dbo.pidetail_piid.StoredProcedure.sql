USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pidetail_piid]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pidetail_piid    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[pidetail_piid] @parm1 varchar(10), @parm2beg int, @parm2end int As
    select * from pidetail
    where piid = @parm1
    and linenbr between @parm2beg and @parm2end
    order by piid, linenbr
GO
