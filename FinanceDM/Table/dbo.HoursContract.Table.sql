USE [FinanceDM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   drop table financeDm.dbo.HoursContract
*
*   Creator:	Michelle Morales
*   Date:		04/15/2016
*		
*
*   Notes:     am I generating unique ids or is the web?

			select top 100 *
			from FinanceDM.dbo.HoursContract
			
			select top 100 *
			from FinanceDM.dbo.HoursContractScopedFte
			
			truncate table FinanceDM.dbo.HoursContract
			truncate table FinanceDM.dbo.HoursContractScopedFte
			truncate table FinanceDM.dbo.HoursContractProductCode
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'hoursContract') < 1

-- every time a contract or a copy of a contract is created, the integerId, contractGroup and the version number is copied into a new record in the HoursContractLine table
CREATE TABLE [dbo].[hoursContract]
(
	integerId int identity(1,1),  --> just auto increments, generated for new contracts as well as copies of contracts
	contractGroupId int,  --> created when a new contract is made; unique when combined with versionNo
	versionNo int, --> new contracts are assigned a 1, copies made of the original contract will be auto-incremented; unique when combined with versionNo
	contractTitle varchar(40), 
	client varchar(15),	
	startDate datetime,
	endDate datetime,
	fteHours float,
	createdDate datetime,
	updatedDate datetime,	
	constraint [pkc_hoursContract_client_contractGroupId_versionNo] primary key clustered (integerId)
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
				where object_id = OBJECT_ID(N'[HoursContract]') 
					and name = 'idx_HoursContract')
begin

CREATE NONCLUSTERED INDEX idx_HoursContract ON [dbo].[HoursContract] (company, projectId, BillBatchId, productID, EmployeeDeptId )
INCLUDE (employee, approver, DocNbr) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

--drop index idx_HoursContract_DepartmentId_CurMonth on  HoursContract

end
go   
*/
---------------------------------------------
-- permissions
---------------------------------------------

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursContract TO BFGROUP

GRANT SELECT, CONTROL ON dbo.HoursContract TO MSDSL

GRANT SELECT on dbo.HoursContract TO public

GRANT SELECT on dbo.HoursContract TO MSDynamicsSL

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.HoursContract TO timecard

