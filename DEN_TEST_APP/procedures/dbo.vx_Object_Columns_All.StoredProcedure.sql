USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[vx_Object_Columns_All]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[vx_Object_Columns_All] 
@parm1 varchar (20),
@parm2 varchar (20)
 AS
Select * from vx_Object_Columns Where TableViewName = @parm1 and FieldName like @parm2
Order by FieldName
GO
