USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LaborClass_All]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LaborClass_All] @parm1 varchar ( 10) as
            Select * from LaborClass where LbrClassId like @parm1
                order by LbrCLassId
GO
