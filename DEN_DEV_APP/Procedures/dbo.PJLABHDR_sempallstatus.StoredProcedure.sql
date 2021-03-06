USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_sempallstatus]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_sempallstatus] @parm1 varchar (10) as

	SET NOCOUNT ON

	/*Create a temp table to hold timecards and the number of line items they have for the employee passed in*/
	CREATE TABLE #LabDetCount( DocNbr CHAR(10) , NbrOfLineItems Int)

	INSERT INTO #LabDetCount		
	SELECT lh.docNbr, count(lh.docnbr) from PjLabHdr lh
	JOIN PjLabDet ld ON lh.docNbr = ld.docNbr 
	where employee = @parm1
	Group By lh.docNbr


	/*Get InProcess timecards with le_status = 'I' in one resultset */
	SELECT lh.*,
	"NbrOfLineItems" = CASE
				WHEN lc.NbrOfLineItems is null THEN 0
				ELSE lc.NbrOfLineItems
			   END				
	from PjLabHdr lh
	left outer join #LabDetCount lc on lh.docNbr = lc.docNbr  
	where le_status = 'I'
	and employee = @parm1
	order by lh.pe_date desc

	/*Get Rejected timecards with le_status = 'R' in one resultset */
	SELECT lh.*,
	"NbrOfLineItems" = CASE
				WHEN lc.NbrOfLineItems is null THEN 0
				ELSE lc.NbrOfLineItems
			   END				
	from PjLabHdr lh
	left outer join #LabDetCount lc on lh.docNbr = lc.docNbr  
	where le_status = 'R'
	and employee = @parm1
	order by lh.pe_date desc

	/*Get Completed timecards with le_status = 'C' in one resultset */
	SELECT lh.*,
	"NbrOfLineItems" = CASE
				WHEN lc.NbrOfLineItems is null THEN 0
				ELSE lc.NbrOfLineItems
			   END				
	from PjLabHdr lh
	left outer join #LabDetCount lc on lh.docNbr = lc.docNbr  
	where le_status = 'C'
	and employee = @parm1
	order by pe_date desc

	/*Get Posted and Approved timecards with le_status = 'P' or 'A' in one resultset */
	SELECT lh.*,
	"NbrOfLineItems" = CASE
				WHEN lc.NbrOfLineItems is null THEN 0
				ELSE lc.NbrOfLineItems
			   END				
	from PjLabHdr lh
	left outer join #LabDetCount lc on lh.docNbr = lc.docNbr  
	where (le_status = 'P' or le_status = 'A')
	and employee = @parm1
	order by pe_date desc

	/*Get timesheet timecards with le_status = 'T' in one resultset */
	SELECT lh.*,
	"NbrOfLineItems" = CASE
				WHEN lc.NbrOfLineItems is null THEN 0
				ELSE lc.NbrOfLineItems
			   END				
	from PjLabHdr lh
	left outer join #LabDetCount lc on lh.docNbr = lc.docNbr  
	where le_status = 'T'
	and employee = @parm1
	order by lh.pe_date desc

	DROP TABLE #LabDetCount
GO
