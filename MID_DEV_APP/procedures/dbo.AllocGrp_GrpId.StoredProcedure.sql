USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocGrp_GrpId]    Script Date: 12/21/2015 14:17:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocGrp_GrpId    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocGrp_GrpId] @parm1 varchar ( 10),@parm2 varchar ( 6) as
       Select * from AllocGrp
           where CpnyId like @parm1
             and GrpId like @parm2
           order by CpnyId, GrpId
GO
