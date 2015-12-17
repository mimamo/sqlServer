USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProductClass_All1]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ProductClass_All1    Script Date: 4/4/05 7:41:53 AM ******/
Create Proc [dbo].[ProductClass_All1] @parm1 varchar ( 6) as
    SELECT *
      FROM ProductClass
     WHERE ClassId like @parm1
       AND (PFOvhMatlRate <> 0 OR PVOvhMatlRate <> 0)
     ORDER BY ClassId
GO
