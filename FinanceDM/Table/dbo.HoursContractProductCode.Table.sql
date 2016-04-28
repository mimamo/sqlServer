USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table FinanceDM.dbo.HoursContractProductCode
*
*   Creator:	Michelle Morales
*   Date:		04/15/20156
*		
*
*   Notes:     am I generating unique ids or is the web?

			select top 100 *
			from FinanceDM.dbo.HoursContractProductCode
			
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
			inner join FinanceDM.dbo.HoursContractProductCode hcl
				on hc.integerId = hcl.integerId
			
			select *
			from 
			
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'HoursContractProductCode') < 1

-- never insert into or update this table manually. only the HoursContract table should insert new records for integerId, contractGroupId and versionNo
-- the remaining fields are updated by the end user in the "contract rows" section of the Hours Contract form.
CREATE TABLE [dbo].[HoursContractProductCode]
(
	integerId int, --> populated from hoursContract.integerId
	productCode varchar(30)
	constraint [pkc_HoursContractProductCode] primary key clustered (integerId, productCode)
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
				where object_id = OBJECT_ID(N'[HoursContractProductCode]') 
					and name = 'idx_HoursContractProductCode')
begin

CREATE NONCLUSTERED INDEX idx_HoursContractProductCode ON [dbo].[HoursContractProductCode] (company, projectId, BillBatchId, productID, EmployeeDeptId )
INCLUDE (employee, approver, DocNbr) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

--drop index idx_HoursContractProductCode_DepartmentId_CurMonth on  HoursContractProductCode

end
go   
*/
---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursContractProductCode TO BFGROUP

GRANT SELECT, CONTROL ON dbo.HoursContractProductCode TO MSDSL

GRANT SELECT on dbo.HoursContractProductCode TO public

GRANT SELECT on dbo.HoursContractProductCode TO MSDynamicsSL

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursContractProductCode TO timecard

