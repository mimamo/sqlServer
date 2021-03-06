USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_Dbnav]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INUnit_Dbnav    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INUnit_Dbnav    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INUnit_Dbnav] @parm1 varchar ( 1), @parm2 varchar ( 6), @parm3 varchar ( 30), @parm4 varchar ( 6), @parm5 varchar ( 6) as
    Select * from INUnit
        where UnitType like @parm1
        and ClassId like @parm2
                and InvtId like @parm3
                and FromUnit like @parm4
                and ToUnit like @parm5
        order by UnitType, ClassId, InvtId, FromUnit, ToUnit
GO
