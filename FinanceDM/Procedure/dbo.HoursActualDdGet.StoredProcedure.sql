USE [FinanceDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'HoursActualDdGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursActualDdGet]
GO

CREATE PROCEDURE [dbo].[HoursActualDdGet] 
	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6)
	
with recompile
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActualDdGet
*
*   Creator: Michelle Morales    
*   Date: 04/19/2016          
*   
*          
*   Notes: 48,479 rows, why does it take so long to export to Excel?

		select *
		from FinanceDM.dbo.HoursActual
		where customerId like '%KEL%'
		order by classId

		select top 100 *
		from FinanceDM.dbo.HoursActual
*
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.HoursActualDdGet @iStartPeriod = '201511', @iEndPeriod = '201511'
	
	execute FinanceDM.dbo.HoursActualDdGet @iStartPeriod = '201507', @iEndPeriod = '201601', @iCustomerId = '1GILNA|1ARCAS'
	
	select distinct DateWorked from FinanceDM.dbo.HoursActual order by DateWorked desc
	
	FinanceDM.dbo.HoursActual_a
	
	select employeeDeptId, SubDept, *
	from FinanceDM.dbo.HoursActual
	where employeeName in('BonSalle, Erin','Desousa, Trista','Hirsch, Steve')
		and customerId = '1GILNA' 
		and year(dateWorked) in (2015,2016)

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
-- doing this to keep SSRS from parameter sniffing
declare	@iStartPeriodInternal varchar(6),	
	@iEndPeriodInternal varchar(6)
	
select @iStartPeriodInternal = @iStartPeriod,	
	@iEndPeriodInternal = @iEndPeriod
/*
select @iStartPeriod = '201510',
	@iEndPeriod = '201511'
*/	

-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------


---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

SELECT     Company, CustomerId, CustomerName, ClassId, ClassGroup, ProductId, ProductDesc, ProjectId, ProjectDesc, JobType, JobSubType, ClientContact, ClientEmail, adpId, 
                      EmployeeDeptId, DepartmentName, SubDept, SubDeptName, EmployeeName, EmployeeEmail, EmployeeTitle, Approver, ApproverEmail, FunctionCode, Hours, 
                      PeriodApproved, WeekEndingDate, DateWorked, WMJFlag, WMJHours, SumOfFteEquity, BusinessUnit, SubUnit, Brand, RetainedOOS, DocNbr, DetailNum, 
                      BillBatchId, BatchId, Employee, RowId, DateAdded
FROM         HoursActual
where PeriodApproved between @iStartPeriod and  @iEndPeriod
	


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursActualDdGet to BFGROUP
go

grant execute on HoursActualDdGet to MSDSL
go

grant control on HoursActualDdGet to MSDSL
go

grant execute on HoursActualDdGet to MSDynamicsSL
go