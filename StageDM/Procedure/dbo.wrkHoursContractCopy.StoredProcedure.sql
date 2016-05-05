USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkHoursContractCopy'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkHoursContractCopy]
GO

CREATE PROCEDURE [dbo].[wrkHoursContractCopy] 

	@integerId int,
	@contractTitle varchar(40), 	
	@client varchar(15),	
	@productCode varchar(max), 
	@startDate datetime,
	@endDate datetime,
	@fteHours float
	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkHoursContractCopy
*
*   Creator: Michelle Morales    
*   Date: 04/19/2016          
*   
*
*          
*   Notes:  
*
*   Usage:	set statistics io on

		execute StageDm.dbo.wrkHoursContractCopy @integetId = 1,
				@contractTitle = 'Another contract', 
				@client = '1arcas',	
				@startDate = '04/15/2016',
				@endDate = '04/30/2016',
				@fteHours = 1800					

		
		select hc.integerId,
			hc.contractGroupId,
			hc.versionNo,
			hc.contractTitle,
			hcl.productCode, 
			hcl.departmentId,
			hcl.ftePercent
		from FinanceDM.dbo.HoursContract hc
		left join FinanceDM.dbo.HoursContractScopedFte hcl
			on hc.integerId = hcl.integerId
	
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
	@newIntegerId int,
	@newVersionNo int,
	@contractGroupId int

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
select @today = getdate()

select @newVersionNo = max(VersionNo) + 1
from financeDm.dbo.HoursContract
where integerId = @integerId
	
if @newVersionNo is null
begin

	select @newVersionNo = 0

end

insert financeDm.dbo.HoursContract
(
	contractGroupId,
	versionNo,
	contractTitle,  
	client,	
	startDate,
	endDate,
	fteHours,
	createdDate,
	updatedDate
)
select contractGroupId = ContractGroupId,
	versionNo = @newVersionNo, --> for new contractGroupIds, versionNo should be 1
	contractTitle = @contractTitle,  
	client = @client,	
	startDate = @startDate,
	endDate = @endDate,
	fteHours = @fteHours,
	createdDate = @today,
	updatedDate = @today
from financeDm.dbo.HoursContract
where integerId = @integerId
	
  
select @contractGroupId = ContractGroupId
from financeDm.dbo.HoursContract
where integerId = @integerId
	
select @newIntegerId = integerId
from financeDm.dbo.HoursContract
where ContractGroupId = @contractGroupId
	and versionNo = @newVersionNo 

insert financeDM.dbo.HoursContractProductCode
(
	integerId, --> populated from hoursContract.integerId
	productCode
)
select integerId = @newIntegerId,
	Name
from den_dev_app.dbo.SplitString(@productCode)

select newIntegerId = @newIntegerId

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkHoursContractCopy to BFGROUP
go

grant execute on wrkHoursContractCopy to MSDSL
go

grant control on wrkHoursContractCopy to MSDSL
go

grant execute on wrkHoursContractCopy to MSDynamicsSL
go

grant control on wrkHoursContractCopy to timecard
go

grant execute on wrkHoursContractCopy to timecard
go