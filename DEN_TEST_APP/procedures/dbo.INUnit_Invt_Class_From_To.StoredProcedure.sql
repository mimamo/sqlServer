USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_Invt_Class_From_To]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_Invt_Class_From_To] @parm1 varchar ( 6), @parm2 varchar ( 6), @parm3 varchar ( 30), @parm4 varchar ( 6) as
    Select * from INUnit
     where ( ClassId = '*' or ClassId = @parm1 )
       and ToUnit = @parm2
       and ( InvtId = '*' or InvtId = @parm3 )
       and not exists(select 'x' from inunit i2
		       where i2.fromunit = inunit.fromunit
			 and i2.tounit = inunit.tounit
			 and i2.Unittype > inunit.unittype
			 and (i2.classid = @parm1 or i2.invtid = @parm3))
       and FromUnit like @parm4
     order by UnitType DESC, ClassId, InvtId, FromUnit, ToUnit
GO
