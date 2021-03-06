USE [DALLASAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'pjproj_sweb_PV'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pjproj_sweb_PV]
GO

Create Procedure [dbo].[pjproj_sweb_PV] 
	@Parm0 varchar(16),
	@Parm1 varchar(10), 
	@Parm2 varchar(10), 
	@SortCol varchar(60)
	
AS

/*******************************************************************************************************
*   DALLASAPP.dbo.pjproj_sweb_PV 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute DALLASAPP.dbo.pjproj_sweb_PV 

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
		'Status'=P.Status_PA, 
		'Customer ID'=P.Customer, 
		'Customer Name'=C.Name 
	from PJProj P
	left outer join CUSTOMER C 
		on P.Customer = C.CustId
	where Project like '%" + @Parm0 + "%'	 
	Order by " + @SortCol   
)
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pjproj_sweb_PV to BFGROUP
go

grant execute on pjproj_sweb_PV to MSDSL
go

grant control on pjproj_sweb_PV to MSDSL
go

grant execute on pjproj_sweb_PV to MSDynamicsSL
go