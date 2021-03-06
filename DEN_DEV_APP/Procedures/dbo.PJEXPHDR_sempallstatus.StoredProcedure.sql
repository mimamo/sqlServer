USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPHDR_sempallstatus]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPHDR_sempallstatus] @parm1 varchar (10) as

	SET NOCOUNT ON

	/*Create a temp table to hold expense reports and the number of line items they have for the employee passed in*/
	CREATE TABLE #expdetCount( DocNbr CHAR(10) , NbrOfLineItems Int)

	INSERT INTO #expdetCount		
	SELECT eh.docNbr, count(eh.docnbr) from PJEXPHDR eh
	JOIN Pjexpdet ed ON eh.docNbr = ed.docNbr 
	where employee = @parm1
	Group By eh.docNbr


	/*Get InProcess expense reports with status_1 = 'I' in one resultset */
	SELECT eh.*,
	"NbrOfLineItems" = CASE
				WHEN ec.NbrOfLineItems is null THEN 0
				ELSE ec.NbrOfLineItems
			   END				
	from PJEXPHDR eh
	left outer join #expdetCount ec on eh.docNbr = ec.docNbr  
	where status_1 = 'I'
	and employee = @parm1
	order by eh.docNbr desc

	/*Get Rejected expense reports with status_1 = 'R' in one resultset */
	SELECT eh.*,
	"NbrOfLineItems" = CASE
				WHEN ec.NbrOfLineItems is null THEN 0
				ELSE ec.NbrOfLineItems
			   END				
	from PJEXPHDR eh
	left outer join #expdetCount ec on eh.docNbr = ec.docNbr  
	where status_1 = 'R'
	and employee = @parm1
	order by eh.docNbr desc

	/*Get Completed expense reports with status_1 = 'C' in one resultset */
	SELECT eh.*,
	"NbrOfLineItems" = CASE
				WHEN ec.NbrOfLineItems is null THEN 0
				ELSE ec.NbrOfLineItems
			   END				
	from PJEXPHDR eh
	left outer join #expdetCount ec on eh.docNbr = ec.docNbr  
	where status_1 = 'C'
	and employee = @parm1
	order by eh.docnbr desc

	/*Get Posted expense reports with status_1 = 'P' in one resultset */
	SELECT eh.*,
	"NbrOfLineItems" = CASE
				WHEN ec.NbrOfLineItems is null THEN 0
				ELSE ec.NbrOfLineItems
			   END				
	from PJEXPHDR eh
	left outer join #expdetCount ec on eh.docNbr = ec.docNbr  
	where (status_1 = 'P' or status_1 = 'A')
	and employee = @parm1
	order by eh.docnbr desc

	DROP TABLE #expdetCount
GO
