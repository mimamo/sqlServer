USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_Global_Unit]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INUnit_Global_Unit    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INUnit_Global_Unit    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INUnit_Global_Unit] @parm1 varchar ( 6) as
    Select * from INUnit
        where UnitType = '1'
                and ToUnit = @parm1
        order by UnitType,  ToUnit
GO
