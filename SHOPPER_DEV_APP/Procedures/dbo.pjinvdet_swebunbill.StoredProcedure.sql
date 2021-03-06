USE [SHOPPER_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH (nolock)
            WHERE NAME = 'pjinvdet_swebunbill'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pjinvdet_swebunbill]
GO

Create Procedure [dbo].[pjinvdet_swebunbill] 
	@parm1 varchar (16) , 
	@parm2 varchar (10) , 
	@parm3 varchar (10) 

	
AS 

/*******************************************************************************************************
*   SHOPPER_DEV_APP.dbo.pjinvdet_swebunbill 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute SHOPPER_DEV_APP.dbo.pjinvdet_swebunbill 

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
	and pjinvdet.bill_status IN ('U', 'S') 
	and pjinvdet.source_trx_date >= @PARM2 
	and pjinvdet.source_trx_date <= @PARM3 
order by pjinvdet.source_trx_id

GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pjinvdet_swebunbill to BFGROUP
go

grant execute on pjinvdet_swebunbill to MSDSL
go

grant control on pjinvdet_swebunbill to MSDSL
go

grant execute on pjinvdet_swebunbill to MSDynamicsSL
go
