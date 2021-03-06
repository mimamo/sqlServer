USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPA940Pre]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xPA940Pre] @RI_ID smallint 
AS
DECLARE @SQL as nvarchar(4000),
		@RI_WHERE as nvarchar(500),
		@Period as nvarchar(6),
		@Month as varchar(2),
		@Year as varchar(4),
		@YTDAmount as money,
		@QTDAmount as money,
		@YTDHours as float,
		@PrepWhere as nvarchar(500), 
		@VerCSelect as nvarchar(500), 
		@VerHSelect as nvarchar(500), 
		@VerSelect as nvarchar(500), 
		@ReportName as nvarchar(10)

DELETE FROM xPA940 WHERE RI_ID = @RI_ID

SELECT
	@RI_WHERE = RTRIM(RI_WHERE),
	@Period = BegPerNbr, 
	@ReportName = ReportName 
FROM
	RptRuntime
WHERE
	RI_ID = @RI_ID

SET @RI_WHERE = REPLACE(@RI_WHERE, 'xPA940.customer', 'PJ.customer')
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xPA940.Job', 'PJ.Project') 

SET @VerCSelect = ' and (ca_id04 <> 140 and pjt_entity not like ' + char(39) + 'ST%' + char(39) + ')'
SET @VerHSelect = ' and (ca_id04 = 140 or pjt_entity like ' + char(39) + 'ST%' + char(39) + ')'

SET @VerSelect = case when rtrim(@ReportName) = 'PA940C' then @VerCSelect when rtrim(@ReportName) in ('PA940H', 'PA940AS') then @VerHSelect else '' end 

--print '1 '+ @RI_WHERE 
print @VerSelect 

--if ltrim(@RI_WHERE) >= '(' 
--begin 
--	SET @RI_WHERE = rtrim(@VerSelect) + ' and ' + @RI_WHERE 
--end

--print '2 '+ @RI_WHERE 

if ltrim(@RI_WHERE) < '(' 
begin 
	SET @RI_WHERE = 'PJ.customer = PJ.customer' 
end

--print '3 '+ @RI_WHERE 

print @RI_WHERE 

--IF @RI_WHERE != ''
--	BEGIN
--		SET @RI_WHERE = ' AND (' + @RI_WHERE + ')'
--	END
--SET @RI_WHERE =  + @RI_WHERE
SET @PrepWhere = @RI_WHERE
--SET @RI_WHERE = @RI_WHERE + ' AND 


SET @SQL = 'INSERT INTO [dbo].[xPA940]
           ([RI_ID]
           ,[Customer]
           ,[Job]
           ,[Product_desc]
           ,[SortID]
           ,[SortName]
           ,[Current]
           ,[QTD]
           ,[YTD]
           ,[Hours])
SELECT
	' + CAST(@RI_ID as varchar(5)) + ',
	PJ.Customer,
	PJ.Project as Job,
	PC.code_value_desc,
	PJ.SortID,
	PJ.SortName,
	SUM(ISNULL(PT.amount * PA.ca_id07, 0)),
	0,
	0,
	0
FROM
	(SELECT 
		PJ.project, 
		PJ.Customer, 
		XS.SortName, 
		XS.SortID 
	FROM 
		PJPROJ PJ,
		xPA940Sort XS) PJ
	LEFT OUTER JOIN (SELECT
						ACCT,
						ca_id04,
						ca_id07
					FROM
						PJACCT
					WHERE
						ca_id04 <> ' + '''' + '''' + ') PA
		ON PJ.SortID = PA.ca_id04
	LEFT OUTER JOIN (SELECT pjtran.* FROM PJTRAN inner join pjacct on pjtran.acct = pjacct.acct WHERE ISNULL(fiscalno, ' + '''' + @Period + '''' + ') = ' + '''' + @Period + '''' + rtrim(@VerSelect) + ') PT
		ON PA.Acct = PT.Acct AND
		   PJ.Project = PT.Project
	LEFT OUTER JOIN (SELECT * FROM RptCompany WHERE ISNULL(RI_ID, ' + CAST(@RI_ID as nvarchar(5)) + ') = ' + CAST(@RI_ID as nvarchar(5)) + ') RC
		ON RC.CpnyID = PT.CpnyID 
	LEFT OUTER JOIN (SELECT * FROM PJCODE WHERE code_type = ' + '''' + '0PRD' + '''' + ') PC
		ON PC.code_value = SUBSTRING(PJ.Project, 4, 3) 
WHERE
	' + @RI_WHERE + '
GROUP BY
	PJ.SortName,
	PJ.SortID,
	PJ.Project,
	PJ.Customer,
	PC.code_value_desc
ORDER BY
	PJ.Project,
	PJ.SortID'


PRINT @SQL

EXEC sp_executesql @SQL

	SET @RI_WHERE = @PrepWhere
	SET @Year = LEFT(@Period, 4)
	SET @Month = RIGHT(@Period, 2)
	IF @Month  = '01'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Period + '''' + ')' 

	IF @Month = '02'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '01' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '03'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '01' + '''' + ', ' + '''' + @Year + '02' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '04'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Period + '''' + ')' 

	IF @Month = '05'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '04' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '06'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '04' + '''' + ', ' + '''' + @Year + '05' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '07'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Period + '''' + ')' 

	IF @Month = '08'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '07' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '09'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '07' + '''' + ', ' + '''' + @Year + '08' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '10'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Period + '''' + ')' 

	IF @Month = '11'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '10' + '''' + ', ' + '''' + @Period + '''' + ')' 

	IF @Month = '12'
		SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(Pt.fiscalno, ' + '''' + @Period + '''' + ') IN (' + '''' + @Year + '10' + '''' + ', ' + '''' + @Year + '11' + '''' + ', ' + '''' + @Period + '''' + ')' 

set @RI_WHERE = rtrim(@RI_WHERE) + @VerSelect

SET @SQL = 
'	UPDATE xPA940
	SET QTD = A.QTDAmount
	FROM
			xPA940 X
			INNER JOIN (SELECT
			' + CAST(@RI_ID as varchar(5)) + ' as RI_ID,
			PJ.Customer,
			PJ.Project as Job,
			PC.code_value_desc,
			PJ.SortID,
			PJ.SortName,
			SUM(ISNULL(PT.amount * PA.ca_id07, 0)) as QTDAmount
		FROM
			(SELECT 
				PJ.project, 
				PJ.Customer, 
				XS.SortName, 
				XS.SortID 
			FROM 
				PJPROJ PJ,
				xPA940Sort XS) PJ
			LEFT OUTER JOIN (SELECT
								ACCT,
								ca_id04,
								ca_id07
							FROM
								PJACCT
							WHERE
								ca_id04 <> ' + '''' + '''' + ') PA
				ON PJ.SortID = PA.ca_id04
			LEFT OUTER JOIN PJTRAN PT
				ON PA.Acct = PT.Acct AND
				   PJ.Project = PT.Project
			LEFT OUTER JOIN (SELECT * FROM RptCompany WHERE ISNULL(RI_ID, ' + CAST(@RI_ID as nvarchar(5)) + ') = ' + CAST(@RI_ID as nvarchar(5)) + ') RC
				ON RC.CpnyID = PT.CpnyID 
			LEFT OUTER JOIN (SELECT * FROM PJCODE WHERE code_type = ' + '''' + '0PRD' + '''' + ') PC
				ON PC.code_value = SUBSTRING(PJ.Project, 4, 3) 
		WHERE
			' + @RI_WHERE + '
		GROUP BY
			PJ.SortName,
			PJ.SortID,
			PJ.Project,
			PJ.Customer,
			PC.code_value_desc) A
			ON A.RI_ID = X.RI_ID AND 
			   A.Job = X.Job AND
			   A.SortID = X.SortID'


PRINT @SQL

EXEC sp_executesql @SQL

	SET @RI_WHERE = @PrepWhere
	SET @RI_WHERE = @RI_WHERE + ' AND ISNULL(LEFT(Pt.fiscalno, 4), ' + '''' + @Year + '''' + ') = ' + '''' + @Year + ''''  

set @RI_WHERE = rtrim(@RI_WHERE) + @VerSelect

SET @SQL = 
'	UPDATE xPA940
	SET YTD = A.YTDAmount, Hours = A.YTDHours
	FROM
			xPA940 X
			INNER JOIN (SELECT
			' + CAST(@RI_ID as varchar(5)) + ' as RI_ID,
			PJ.Customer,
			PJ.Project as Job,
			PC.code_value_desc,
			PJ.SortID,
			PJ.SortName,
			SUM(ISNULL(PT.amount * PA.ca_id07, 0)) as YTDAmount,
			SUM(ISNULL(PT.Units * PA.ca_id07, 0)) as YTDHours
		FROM
			(SELECT 
				PJ.project, 
				PJ.Customer, 
				XS.SortName, 
				XS.SortID 
			FROM 
				PJPROJ PJ,
				xPA940Sort XS) PJ
			LEFT OUTER JOIN (SELECT
								ACCT,
								ca_id04,
								ca_id07
							FROM
								PJACCT
							WHERE
								ca_id04 <> ' + '''' + '''' + ') PA
				ON PJ.SortID = PA.ca_id04
			LEFT OUTER JOIN PJTRAN PT
				ON PA.Acct = PT.Acct AND
				   PJ.Project = PT.Project
			LEFT OUTER JOIN (SELECT * FROM RptCompany WHERE ISNULL(RI_ID, ' + CAST(@RI_ID as nvarchar(5)) + ') = ' + CAST(@RI_ID as nvarchar(5)) + ') RC
				ON RC.CpnyID = PT.CpnyID 
			LEFT OUTER JOIN (SELECT * FROM PJCODE WHERE code_type = ' + '''' + '0PRD' + '''' + ') PC
				ON PC.code_value = SUBSTRING(PJ.Project, 4, 3) 
		WHERE
			' + @RI_WHERE + '
		GROUP BY
			PJ.SortName,
			PJ.SortID,
			PJ.Project,
			PJ.Customer,
			PC.code_value_desc) A
			ON A.RI_ID = X.RI_ID AND 
			   A.Customer = X.Customer AND
			   A.Job = X.Job AND
			   A.code_value_desc = X.Product_desc AND
			   A.SortID = X.SortID AND
			   A.SortName = X.SortName'

PRINT @SQL

EXEC sp_executesql @SQL

UPDATE xPA940 SET Hours = 0 WHERE SortID <> 200 AND RI_ID = @RI_ID
GO
