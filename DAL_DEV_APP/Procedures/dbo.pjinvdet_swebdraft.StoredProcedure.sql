USE [DAL_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'pjinvdet_swebdraft'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pjinvdet_swebdraft]
GO

Create Procedure [dbo].[pjinvdet_swebdraft] 
	@parm1 varchar (10)
	
AS 

/*******************************************************************************************************
*   DAL_DEV_APP.dbo.pjinvdet_swebdraft 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute DAL_DEV_APP.dbo.pjinvdet_swebdraft 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins
********************************************************************************************************/

select  pjinvdet.*,
	pjinvhdr.invoice_num, 
	pjinvhdr.
	invoice_date,
	pjemploy.emp_name
From pjinvdet
left outer join pjinvhdr
	on pjinvdet.draft_num = pjinvhdr.draft_num  
left outer join pjemploy
	on pjinvdet.employee = pjemploy.employee   
Where pjinvdet.draft_num = @PARM1 	
order by pjinvdet.source_trx_id

GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pjinvdet_swebdraft to BFGROUP
go

grant execute on pjinvdet_swebdraft to MSDSL
go

grant control on pjinvdet_swebdraft to MSDSL
go

grant execute on pjinvdet_swebdraft to MSDynamicsSL
go
