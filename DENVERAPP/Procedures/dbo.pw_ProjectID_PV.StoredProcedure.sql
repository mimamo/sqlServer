USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH (nolock)
            WHERE NAME = 'pw_ProjectID_PV'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pw_ProjectID_PV]
GO


Create Procedure [dbo].[pw_ProjectID_PV] 
	@Parm0 varchar(16), 
	@Parm1 varchar(10), 
	@ParmEmployee varchar(10), 
	@SortCol varchar(60) 

AS

/*******************************************************************************************************
*   DENVERAPP.dbo.pw_ProjectID_PV 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.pw_ProjectID_PV 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins.
********************************************************************************************************/


	DECLARE @ProjCaption char(16)

	Select @ProjCaption=ltrim(substring(control_data,2,16)) 
	from PJContrl 
	where control_type = 'FK' 
		and control_code = 'PROJECT'

	exec("
 	Select '" + @ProjCaption + "'=rtrim(P.Project), 
 		'Description'=P.Project_Desc, 
		'Customer ID'=P.Customer, 
		'Customer Name'=C.Name 
	from PJProj P 
	left outer join CUSTOMER C 
		on P.Customer = C.CustId
	where Project like '%" + @Parm0 + "%'
		and P.Status_PA = 'A' 
	Order by " + @SortCol  

	)
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pw_ProjectID_PV to BFGROUP
go

grant execute on pw_ProjectID_PV to MSDSL
go

grant control on pw_ProjectID_PV to MSDSL
go

grant execute on pw_ProjectID_PV to MSDynamicsSL
go