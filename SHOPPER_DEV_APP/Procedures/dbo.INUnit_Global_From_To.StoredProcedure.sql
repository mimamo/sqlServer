USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_Global_From_To]    Script Date: 12/21/2015 14:34:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INUnit_Global_From_To    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INUnit_Global_From_To    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INUnit_Global_From_To] @parm1 varchar ( 6), @parm2 varchar ( 6) as
    Select * from INUnit
        where UnitType = '1'
                and FromUnit = @parm1
                and ToUnit = @parm2
        order by UnitType, ClassId, InvtId, FromUnit, ToUnit
GO
