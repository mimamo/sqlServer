USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkAllocGrp_GrpId]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkAllocGrp_GrpId    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc  [dbo].[WrkAllocGrp_GrpId] @parm1 varchar ( 6) as
       Select * from WrkAllocGrp
           where GrpId  =  @parm1
GO
