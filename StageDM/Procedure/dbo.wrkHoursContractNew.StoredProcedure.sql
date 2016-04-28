USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkHoursContractNew'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkHoursContractNew]
GO

CREATE PROCEDURE [dbo].[wrkHoursContractNew] 

	-- @isCopy int = 0, -- if it's a copy, need the web to pass in the ContractGroupId and versionNo, otherwise
	@contractTitle varchar(40), 
	@client varchar(15),	
	@productCode varchar(max), 
	@startDate datetime,
	@fteHours float
	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkHoursContractNew
*
*   Creator: Michelle Morales    
*   Date: 04/19/2016          
*   
*
*          
*   Notes:  
*
*   Usage:	set statistics io on

		execute StageDm.dbo.wrkHoursContractNew @contractTitle = 'A new contract', 
				@client = '1arcas',	
				@startDate = '04/01/2016',
				@fteHours = 1800			
						

			select hc.integerId,
				hc.contractGroupId,
				hc.versionNo,
				hcl.productCode, 
				hcl.departmentId,
				hcl.ftePercent
			from FinanceDM.dbo.HoursContract hc
			left join FinanceDM.dbo.HoursContractLine hcl
				on hc.contractGroupId = hcl.contractGroupId
				and hc.versionNo = hcl.versionNo
		
		FinanceDm.dbo.sp_spaceused HoursContract
		
		truncate table FinanceDm.dbo.HoursContract
		truncate table FinanceDm.dbo.HoursContractLine
	

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
	@newContractGroupId int

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

select @newContractGroupId = max(contractGroupId) + 1
from financeDm.dbo.HoursContract

if @newContractGroupId is null
begin

	select @newContractGroupId = 1

end

insert financeDm.dbo.HoursContract
(
	contractGroupId,
	versionNo,
	contractTitle,  
	client,	
	startDate,
	fteHours,
	createdDate,
	updatedDate
)
select contractGroupId = @newContractGroupId,
	versionNo = 1, --> for new contractGroupIds, versionNo should be 1
	contractTitle = @contractTitle,  
	client = @client,	
	startDate = @startDate,
	fteHours = @fteHours,
	createdDate = @today,
	updatedDate = @today
	

select @newIntegerId = integerId
from financeDm.dbo.HoursContract
where contractGroupId = @newContractGroupId
	and versionNo = 1

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
grant execute on wrkHoursContractNew to BFGROUP
go

grant execute on wrkHoursContractNew to MSDSL
go

grant control on wrkHoursContractNew to MSDSL
go

grant execute on wrkHoursContractNew to MSDynamicsSL
go

grant control on wrkHoursContractNew to timecard
go

grant execute on wrkHoursContractNew to timecard
go