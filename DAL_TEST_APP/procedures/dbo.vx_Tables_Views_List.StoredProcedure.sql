USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[vx_Tables_Views_List]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vx_Tables_Views_List] 
@parm1 Varchar (20), 
@parm2 Varchar (20), 
@parm3 Varchar (20), 
@parm4 Varchar (20), 
@parm5 Varchar (20), 
@parm6 Varchar (20), 
@parm7 Varchar (20), 
@parm8 Varchar (20)
AS 
Select * from vx_Tables_Views
Where Name in (@parm1, @parm2, @parm3, @parm4, @parm5, @parm6, @parm7)
and Name like @parm8
Order by Name
GO
