USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LaborClass_All1]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LaborClass_All1] @parm1 varchar ( 10) as
      SELECT *
        FROM LaborClass
       WHERE LbrClassId like @parm1
         AND (PPayRate <> 0 OR PStdRate <> 0)
       ORDER BY LbrCLassId
GO
