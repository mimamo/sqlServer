USE [MIDWESTAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'pjinvdet_swebdate'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pjinvdet_swebdate]
GO

Create Procedure [dbo].[pjinvdet_swebdate] 
	@parm1 varchar (16) , 
	@parm2 varchar (10) ,
	@parm3 varchar (10)
	
AS 

/*******************************************************************************************************
*   MIDWESTAPP.dbo.pjinvdet_swebdate 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute MIDWESTAPP.dbo.pjinvdet_swebdate 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins.
********************************************************************************************************/


select  pjinvdet.*,
	pjinvhdr.invoice_num, 
	pjinvhdr.invoice_date,
	pjemploy.emp_name
From pjinvdet
left outer join pjinvhdr
	on pjinvdet.draft_num = pjinvhdr.draft_num  
left outer join pjemploy
	on pjinvdet.employee = pjemploy.employee  
Where (pjinvdet.project = @PARM1 
		or pjinvdet.project_billwith = @PARM1)
	and pjinvdet.source_trx_date >= @PARM2 
	and pjinvdet.source_trx_date <= @PARM3 
order by pjinvdet.source_trx_id
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pjinvdet_swebdate to BFGROUP
go

grant execute on pjinvdet_swebdate to MSDSL
go

grant control on pjinvdet_swebdate to MSDSL
go

grant execute on pjinvdet_swebdate to MSDynamicsSL
go
