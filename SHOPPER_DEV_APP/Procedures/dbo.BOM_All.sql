USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOM_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOM_All] @parm1 varchar ( 30) as
            Select * from Kit where KitId like @parm1
                order by KitId
GO
