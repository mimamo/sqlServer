USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[WSPInstance_All]    Script Date: 12/21/2015 16:01:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WSPInstance_All] @parm1 varchar(60)  
AS  
	SELECT *  
	FROM WSPInstance
	WHERE SLTypeDesc Like @parm1 
	ORDER BY SLTypeDesc
GO
