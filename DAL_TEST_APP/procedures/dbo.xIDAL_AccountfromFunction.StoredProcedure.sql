USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_AccountfromFunction]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_AccountfromFunction] @Function varchar(10) 

AS

SELECT 
	Data2
FROM
	PJCODE
WHERE
	code_type = '0FUN' AND
	code_value = @Function
GO
