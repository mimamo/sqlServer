USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WSPDoc_All]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WSPDoc_All] @parm1 varchar(5), @parm2 varchar(50)
AS  
	SELECT *  
	FROM WSPDoc
	WHERE Instance Like @parm1 And DocumentType Like @parm2
	ORDER BY DocumentType
GO
