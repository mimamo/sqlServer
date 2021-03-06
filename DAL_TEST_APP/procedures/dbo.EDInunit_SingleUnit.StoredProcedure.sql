USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInunit_SingleUnit]    Script Date: 12/21/2015 13:57:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInunit_SingleUnit] @Parm1 varchar(30), @Parm2 varchar(6), @Parm3 varchar(6), @Parm4 varchar(6) As
-- @Parm1 = InvtId, @Parm2 = ClassId, @Parm3 = FromUnit, @Parm4 = ToUnit
Select * From InUnit Where InvtId In (@Parm1, '*') And ClassId In (@Parm2, '*') And
FromUnit = @Parm3 And ToUnit = @Parm4 Order By UnitType Desc
GO
