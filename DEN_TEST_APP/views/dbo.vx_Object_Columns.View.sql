USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vx_Object_Columns]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vx_Object_Columns]
AS
SELECT Left(SysObjects.Name,20) as TableViewName, LEFT(SysColumns.Name, 20) AS FieldName
FROM SysColumns, SysObjects
WHERE SysColumns.Id = SysObjects.Id
GO
