USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Global_Class_SOPOUnits]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Global_Class_SOPOUnits    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Global_Class_SOPOUnits    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Global_Class_SOPOUnits] @parm1 varchar ( 6), @parm2 varchar ( 6), @parm3 varchar ( 30), @parm4 varchar ( 6) as
    Select distinct fromunit, ToUnit from inunit
        where fromUnit like @parm4
                and toUnit = @parm2
        and (InvtId = '*' or InvtId = @parm3)
                and (ClassId = '*' or ClassId = @parm1)
        order by FromUnit, Tounit
GO
