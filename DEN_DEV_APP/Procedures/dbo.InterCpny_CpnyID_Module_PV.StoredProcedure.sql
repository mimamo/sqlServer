USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[InterCpny_CpnyID_Module_PV]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[InterCpny_CpnyID_Module_PV] @parm1 varchar ( 10), @parm2 varchar ( 7), @parm3 varchar ( 2), @parm4 varchar ( 10) AS
Select * from InterCompany where FromCompany = @parm1 and ToCompany LIKE @parm4 and
(screen = @parm2 or (Screen = "ALL  " and Module = @parm3)
or (screen = "ALL  " and Module = "**") or (Module = "ZZ" and @parm1 LIKE @parm4))
GO
