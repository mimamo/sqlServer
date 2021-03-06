USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV]
GO

CREATE Procedure [dbo].[pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV]
	@ParmUser varchar(10), 
	@ParmClient varchar(15), 
	@ParmProduct varchar(4), 
	@ParmJob varchar(16), 
	@SortCol varchar(60)  

AS

/*******************************************************************************************************
*   DENVERAPP.dbo.pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins.
********************************************************************************************************/
	exec("

	--CyGen - CG - 8-10-06 - on the next line and a few lines down I replaced the P.Customer field with the P.pm_id01 field
	--because they do not always match, and Manny said that we should be using the pm_id01 value for the customer id, this appears
	--to be due to a customization that was made by Alterra for Integer since Integers client and billable customer for a single job
	--can be different
	Select 'Product ID'=rtrim(P.pm_id02), 
		'Product Description'=rtrim(D.descr)
	from PJProj P
	left outer join CUSTOMER C
		on P.pm_id01 = C.CustId  
	inner join PJPROJEM E
		on P.project = E.project 
	inner join xIGProdCode D
		on P.pm_id02 = D.code_id
	where (E.employee = '" + @ParmUser + "' 
			or E.employee = '*')  
        and P.Project like '%" + @ParmJob + "%'		
		and P.Status_PA = 'A' 
		and P.Status_LB = 'A' 		
		and P.pm_id01 like '%" + @ParmClient + "%' 
		and P.pm_id02 like '%" + @ParmProduct + "%'		
	Group by P.pm_id02, D.descr
	Order by " + @SortCol  
	)
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV to BFGROUP
go

grant execute on pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV to MSDSL
go

grant control on pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV to MSDSL
go

grant execute on pw_GetProductsWithActiveJobsForUserByUserClientProductJob_PV to MSDynamicsSL
go
