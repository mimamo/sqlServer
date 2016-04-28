USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkHoursContractScopedFte'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkHoursContractScopedFte]
GO

CREATE PROCEDURE [dbo].[wrkHoursContractScopedFte] 

	@integerId int,
	@departmentId varchar(24),
	@ftePercent float

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkHoursContractScopedFte
*
*   Creator: Michelle Morales    
*   Date: 04/19/2016          
*   
			execute StageDm.dbo.wrkHoursContractScopedFte @contractGroupId = 1,
				@versionNo = 1,
				@fteHours = 1800,
				@departmentId = '9999',
				@ftePercent = 33
*
*          
*   Notes:  
*
*   Usage:	set statistics io on

			
				
		execute StageDm.dbo.wrkHoursContractScopedFte @contractGroupId = 1,
				@versionNo = 2,
				@contractTitle = 'A new contract copy', 
				@fteHours = 1800,

				@departmentId = '7777',
				@ftePercent = 42
	
		FinanceDm.dbo.sp_spaceused HoursContract
		
		truncate table FinanceDm.dbo.HoursContract
		truncate table FinanceDm.dbo.HoursContractScopedFte
	

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @today datetime,
	@maxContractGroupId int,
	@maxVersionNo int

---------------------------------------------
-- create temp tables
---------------------------------------------

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
insert financeDm.dbo.HoursContractScopedFte
(
	integerId,
	departmentId,
	ftePercent,
	createdDate,
	updatedDate
)
select integerId = @integerId,
	departmentId = @departmentId,
	ftePercent = @ftePercent,
	createdDate = @today,
	updatedDate = @today


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkHoursContractScopedFte to BFGROUP
go

grant execute on wrkHoursContractScopedFte to MSDSL
go

grant control on wrkHoursContractScopedFte to MSDSL
go

grant execute on wrkHoursContractScopedFte to MSDynamicsSL
go

grant control on wrkHoursContractScopedFte to timecard
go

grant execute on wrkHoursContractScopedFte to timecard
go