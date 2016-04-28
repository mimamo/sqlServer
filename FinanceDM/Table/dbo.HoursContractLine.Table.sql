USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table FinanceDM.dbo.HoursContractScopedFte
*
*   Creator:	Michelle Morales
*   Date:		04/15/20156
*		
*
*   Notes:     am I generating unique ids or is the web?

			select top 100 *
			from FinanceDM.dbo.HoursContractScopedFte
			
			to insert into identity column:
			
			SET IDENTITY_INSERT IdentityTable ON 
			
			INSERT IdentityTable(TheIdentity, TheValue) 
			VALUES (3, 'First Row') 
			
			SET IDENTITY_INSERT IdentityTable OFF 		
			
			select top 100 hc.integerId,
				hc.contractGroupId,
				hc.versionNo,
				hcl.productCode, 
				hcl.departmentId,
				hcl.ftePercent,
				hcl.productCode,
				hcl.departmentId,
				hcl.ftePercent
			from FinanceDM.dbo.HoursContract hc
			inner join FinanceDM.dbo.HoursContractScopedFte hcl
				on hc.contractGroupId = hcl.contractGroupId
				and hc.versionNo = hcl.versionNo
			
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'HoursContractScopedFte') < 1

-- never insert into or update this table manually. only the HoursContract table should insert new records for integerId, contractGroupId and versionNo
-- the remaining fields are updated by the end user in the "contract rows" section of the Hours Contract form.
CREATE TABLE [dbo].[HoursContractScopedFte]
(
	integerId int, --> populated from hoursContract.integerId
	productCode varchar(30), 
	departmentId varchar(24),
	ftePercent float,
	createdDate datetime,
	updatedDate datetime,
	constraint [pkc_HoursContractScopedFte] primary key clustered (integerId, productCode, departmentId, ftePercent)
) ON [PRIMARY]




GO
SET ANSI_PADDING OFF
GO


---------------------------------------------
-- modifications
---------------------------------------------
/*
if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[HoursContractScopedFte]') 
					and name = 'idx_HoursContractScopedFte')
begin

CREATE NONCLUSTERED INDEX idx_HoursContractScopedFte ON [dbo].[HoursContractScopedFte] (company, projectId, BillBatchId, productID, EmployeeDeptId )
INCLUDE (employee, approver, DocNbr) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

--drop index idx_HoursContractScopedFte_DepartmentId_CurMonth on  HoursContractScopedFte

end
go   
*/
---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursContractScopedFte TO BFGROUP

GRANT SELECT, CONTROL ON dbo.HoursContractScopedFte TO MSDSL

GRANT SELECT on dbo.HoursContractScopedFte TO public

GRANT SELECT on dbo.HoursContractScopedFte TO MSDynamicsSL

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursContractScopedFte TO timecard

