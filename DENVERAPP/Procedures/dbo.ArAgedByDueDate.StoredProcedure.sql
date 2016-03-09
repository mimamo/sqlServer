USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'ArAgedByDueDate'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[ArAgedByDueDate]
GO

CREATE PROCEDURE [dbo].[ArAgedByDueDate]     
	 @Company varchar(30)
     
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.ArAgedByDueDate 
*
*   Created By: 
*	Date:
*
*   Notes:         
*                  
*
*   Usage:  

        execute DENVERAPP.dbo.ArAgedByDueDate @Company = 'DENVER'
        execute DENVERAPP.dbo.ArAgedByDueDate @Company = 'SHOPPERNY'
        execute DENVERAPP.dbo.ArAgedByDueDate @Company = 'DENVER|SHOPPERNY'
        
        set statistics io on 
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
DECLARE @sql1 nvarchar(max),
	@sql2 nvarchar(max),
	@sql3 nvarchar(max),
	@sql nvarchar(max),
	@Date date,
	@dbName nvarchar(24),
	@CurCompany varchar(254)

SET @Date = getdate()

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @parsedCompany table (Name varchar(254))

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @dbName = null

select @dbName = case when @Company = 'DENVER' then 'DENVERAPP' 
						when @Company = 'SHOPPERNY' then 'SHOPPERAPP'
						else 'DENVERAPP|SHOPPERAPP'
					end

insert @parsedCompany (Name)
SELECT Name
FROM DENVERAPP.dbo.SplitString(@dbName)

select @CurCompany = min(Name)
from @parsedCompany

truncate table DENVERAPP.dbo.ArAgingByDueDate	

while @CurCompany is not null
begin

	select @sql1 = '

	if object_id(''tempdb.dbo.#ARAging'') > 0 drop table #ARAging
	CREATE TABLE #ARAging
	(
		[Company] Varchar(20) NOT NULL,
		[CustID] varchar(50) NOT NULL,
		[Customer] varchar (50) NOT NULL,
		[ProjectID] char(16) NOT NULL,
		[invoice_date] Smalldatetime NOT NULL, 
		[year] Varchar (10) NOT NULL,
		[ClientRefNum] varchar(50) NULL,
		[JobDescr] varchar(50) NULL,
		[ProdCode] varchar(50) NULL,
		[RefNbr] varchar(50) NOT NULL,
		[DueDate] smalldatetime NOT NULL,
		[DocDate] smalldatetime NOT NULL,
		[DocType] char(2) NOT NULL,
		[CuryOrigDocAmt] float NOT NULL,
		[CuryDocBal] float NOT NULL,
		[AvgDayToPay] float NOT NULL,
		[CpnyID] char(10) NOT NULL,
		[TotalAdjdAmt] float NOT NULL,
		[AdjdRefNbr] varchar(50) NOT NULL,
		[AdjgDocType] char(2) NOT NULL,
		[RecordID] int NOT NULL,
		[DateAppl] smalldatetime NOT NULL,
		[ClassIDDesc] varchar(50) NULL,
		[NotDueYet] float NOT NULL,
		[Below30] float NOT NULL,
		[Below60] float NOT NULL,
		[Below90] float NOT NULL,
		[Below120] float NOT NULL,
		[Below150] float NOT NULL,
		[Below180] float NOT NULL,
		[Over180] float NOT NULL,
		[Total] float NOT NULL,
		[DateDiffDocDate] int NULL,
		[DateDiffDueDate] int NULL,
		rowId int identity(1,1),
		constraint pkc_#ArAgingByDueDate primary key clustered (company, invoice_date, refNbr, rowId) 
	)

	INSERT #ARAging  
	(
		[Company],
		[CustID],
		[Customer],
		[ProjectID],
		[invoice_date], 
		[year],
		[ClientRefNum],
		[JobDescr],
		[ProdCode],
		[RefNbr],
		[DueDate],
		[DocDate],
		[DocType],
		[CuryOrigDocAmt],
		[CuryDocBal],
		[AvgDayToPay],
		[CpnyID],
		[TotalAdjdAmt],
		[AdjdRefNbr],
		[AdjgDocType],
		[RecordID],
		[DateAppl],
		[ClassIDDesc],
		[NotDueYet],
		[Below30],
		[Below60],
		[Below90],
		[Below120],
		[Below150],
		[Below180],
		[Over180],
		[Total],
		[DateDiffDocDate],
		[DateDiffDueDate]
	)                
	SELECT Company = ''' + @CurCompany + '''
		, CustID = RTRIM(a.CustId)
		, Customer = RTRIM(c.Name) 
		, ProjectID = RTRIM(a.ProjectID) 
		, invoice_date = RTRIM(i.Crtd_DateTime)
		, [year] = YEAR(i.crtd_DateTime)
		, ClientRefNum = RTRIM(a.ClientRefNum)
		, JobDescr = RTRIM(a.JobDescr)
		, ProdCode = RTRIM(a.ProdCode)
		, RefNbr = RTRIM(a.RefNbr)
		, DueDate = RTRIM(a.DueDate)
		, DocDate = RTRIM(a.DocDate)
		, DocType = RTRIM(a.DocType)
		, CuryOrigDocAmt = (a.CuryOrigDocAmt)
		, CuryDocBal = (a.CuryDocBal)
		, AvgDayToPay = RTRIM(a.AvgDayToPay)
		, CpnyID = RTRIM(a.CpnyID)
		, TotalAdjdAmt = 0
		, AdjdRefNbr = ''''
		, AdjgDocType = ''''
		, RecordID = 0
		, DateAppl = ''1900/01/01''
		, ClassIDDesc = d.Descr 
		, NotDueYet = 0
		, Below30 = 0
		, Below60 = 0
		, Below90 = 0
		, Below120 = 0
		, Below150 = 0
		, Below180 = 0
		, Over180 = 0
		, Total = 0 
		, DateDiffDocDate = DateDiff(d, a.DocDate, ''' + cast(@Date as nvarchar) + ''')
		, DateDiffDueDate = DateDiff(d, a.DueDate, ''' + cast(@Date as nvarchar) + ''')
	FROM ' + @CurCompany + '.dbo.xvr_AR000_Aged a  with (nolock)
	LEFT OUTER JOIN ' + @CurCompany + '.dbo.ARDoc i  with (nolock)
		ON a.ProjectID = i.ProjectID
		AND a.BatNbr = i.BatNbr
		AND a.RefNbr = i.RefNbr       
	INNER JOIN ' + @CurCompany + '.dbo.Customer c with (nolock)
		ON a.CustID = c.CustId
	INNER JOIN ' + @CurCompany + '.dbo.CustClass d with (nolock)
		ON a.ClassID = d.ClassId       


	UPDATE #ARAging    
		SET TotalAdjdAmt = ISNULL(r.TotalAdjdAmt,0)
			, AdjdRefNbr = ISNULL(r.AdjdRefNbr, '''')
	FROM #ARAging 
	LEFT JOIN (SELECT AdjdRefNbr
					, TotalAdjdAmt = SUM(CuryAdjdAmt)
				FROM ' + @CurCompany + '.dbo.ARAdjust with (nolock)
				WHERE DateAppl <= ''' + cast(@Date as nvarchar) + '''
				GROUP BY AdjdRefNbr) r 
		ON RefNbr = r.AdjdRefNbr '

	select @sql2 = '
							
	UPDATE #ARAging 
		SET AdjgDocType = ISNULL(a.AdjgDocType,'''')
			, DateAppl = ISNULL(a.DateAppl, ''1900/01/01'')
	FROM #ARAging  
	LEFT JOIN ' + @CurCompany + '.dbo.ARAdjust a with (nolock)
		on RefNbr = a.AdjdRefNbr 

	UPDATE #ARAging
		SET TotalAdjdAmt = ISNULL(CuryOrigDocAmt - CuryDocBal, 0)
			, AdjgDocType = ''DV'' --derived
	WHERE AdjdRefNbr = ''''
		AND AdjgDocType = ''''
		AND DateAppl = ''1900/01/01''
		AND RecordID = 0
		AND CuryOrigDocAmt <> CuryDocBal  
	 
	UPDATE #ARAging
		SET NotDueYet = CASE WHEN ''' + cast(@Date as nvarchar) + ''' between invoice_date and DueDate THEN CuryOrigDocAmt - TotalAdjdAmt 
								ELSE 0 
						end,
			 Below30 = CASE WHEN DateDiffDueDate between 0 and 30 THEN CuryOrigDocAmt - TotalAdjdAmt
								ELSE 0 
						end,
			Below60 = CASE WHEN DateDiffDueDate between 31 and 60 THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 
					end, 
			Below90 = CASE WHEN DateDiffDueDate between 61 and 90 THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 
					end, 
			Below120 = CASE WHEN DateDiffDueDate between 91 and 120 THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 
					end, 
			Below150 = CASE WHEN DateDiffDueDate between 121 and 150 THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 
					end, 
			Below180 = CASE WHEN DateDiffDueDate between 151 and 180THEN CuryOrigDocAmt - TotalAdjdAmt
						ELSE 0 
					end,
			Over180 = CASE WHEN DateDiffDueDate > 180 THEN CuryOrigDocAmt - TotalAdjdAmt
							ELSE 0 
						end 
	
		    
	UPDATE #ARAging
		SET Total = NotDueYet + Below30 + Below60 + Below90 + Below120 + Below150 +Below180 + Over180    
	
	select [Company],
		[CustID],
		[Customer],
		[ProjectID],
		[invoice_date], 
		[year],
		[ClientRefNum],
		[JobDescr],
		[ProdCode],
		[RefNbr],
		[DueDate],
		[DocDate],
		[DocType],
		[CuryOrigDocAmt],
		[CuryDocBal],
		[AvgDayToPay],
		[CpnyID],
		[TotalAdjdAmt],
		[AdjdRefNbr],
		[AdjgDocType],
		[RecordID],
		[DateAppl],
		[ClassIDDesc],
		[NotDueYet],
		[Below30],
		[Below60],
		[Below90],
		[Below120],
		[Below150],
		[Below180],
		[Over180],
		[Total],
		[DateDiffDocDate],
	[DateDiffDueDate]
	from #ARAging
	
	drop table #ARAging '
	
	set @sql = @sql1 + @sql2 

	insert DENVERAPP.dbo.ArAgingByDueDate execute sp_executesql @sql

	
	select @CurCompany = min(Name)
	from @parsedCompany
	where Name > @CurCompany
	
end


select 	[Company],
	[CustID],
	[Customer],
	[ProjectID],
	[invoice_date], 
	[year],
	[ClientRefNum],
	[JobDescr],
	[ProdCode],
	[RefNbr],
	[DueDate],
	[DocDate],
	[DocType],
	[CuryOrigDocAmt],
	[CuryDocBal],
	[AvgDayToPay],
	[CpnyID],
	[TotalAdjdAmt],
	[AdjdRefNbr],
	[AdjgDocType],
	[RecordID],
	[DateAppl],
	[ClassIDDesc],
	[NotDueYet],
	[Below30],
	[Below60],
	[Below90],
	[Below120],
	[Below150],
	[Below180],
	[Over180],
	[Total],
	[DateDiffDocDate],
	[DateDiffDueDate]
from DENVERAPP.dbo.ArAgingByDueDate 

/*
        execute DENVERAPP.dbo.ArAgedByDueDate @Company = 'DENVER'
        execute DENVERAPP.dbo.ArAgedByDueDate @Company = 'SHOPPERNY'

*/
    

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on ArAgedByDueDate to MSDSL
go

grant control on ArAgedByDueDate to MSDSL
go

grant execute on ArAgedByDueDate to MSDynamicsSL
go

grant execute on ArAgedByDueDate to BFGROUP
go


