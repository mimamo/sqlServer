USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LaborClass_All]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LaborClass_All] @parm1 varchar ( 10) as
            Select * from LaborClass where LbrClassId like @parm1
                order by LbrCLassId
GO
