USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_Timecheck]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xIDAL_Timecheck] @DocNbr varchar(15)
AS

SET NOCOUNT ON
		
		DECLARE @ReturnValue smallint

		SELECT 
			@ReturnValue = ISNULL(PE.em_id10,0)
		FROM 
			PJEMPLOY PE 
			 INNER JOIN PJLABHDR PL
				ON PE.employee = PL.employee
			 INNER JOIN PJLABDET PD
				ON PL.docnbr = PD.DocNbr
		WHERE
			PL.docNbr = @DocNbr
		GROUP BY 
			PE.em_id10,
			PE.User3
		HAVING 		
			SUM(Day1_hr1 + day1_hr2 + day1_Hr3) < pe.User3 OR
			SUM(Day2_hr1 + day2_hr2 + day2_Hr3) < pe.User3 OR
			SUM(Day3_hr1 + day3_hr2 + day3_Hr3) < pe.User3 OR
			SUM(Day4_hr1 + day4_hr2 + day4_Hr3) < pe.User3 OR
			SUM(Day5_hr1 + day5_hr2 + day5_Hr3) < pe.User3 

 
		
		SELECT CAST(ISNULL(@ReturnValue, 0) as smallint) as [Return]
GO
