USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_INUnit_Invt_Class_From_To]    Script Date: 12/21/2015 15:42:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_INUnit_Invt_Class_From_To]
	@parm1 varchar ( 6),
	@parm2 varchar ( 6),
	@parm3 varchar ( 30),
	@parm4 varchar ( 6)
AS
    	Select 	*
	from 	INUnit
        where 	FromUnit like @parm4
           and 	ToUnit = @parm2
           and 	(InvtId = '*' or InvtId = @parm3)
           and  (ClassId = '*' or ClassId = @parm1)
        order by UnitType, ClassId, InvtId, FromUnit, ToUnit

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
