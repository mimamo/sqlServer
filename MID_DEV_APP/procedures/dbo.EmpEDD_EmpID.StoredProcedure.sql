USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EmpEDD_EmpID]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EmpEDD_EmpID] @parm1 varchar(15), @parm2 varchar(2)  
AS  
	SELECT *  
	FROM EmpEDD  
	WHERE EmpID = @parm1 AND DocType like @parm2  
	ORDER BY EmpID, DocType
GO
