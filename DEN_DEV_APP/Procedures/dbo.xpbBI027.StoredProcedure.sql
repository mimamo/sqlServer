USE [DEN_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'xpbBI027'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xpbBI027]
GO

CREATE PROCEDURE [dbo].[xpbBI027] 

	
AS 

/*******************************************************************************************************
*   DEN_DEV_APP.dbo.xpbBI027 
*
*   Creator: Michelle Morales	   
*   Date:    01/25/2016      
*   
*          
*
*   Usage:	

	execute DEN_DEV_APP.dbo.xpbBI027  
	
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*  
********************************************************************************************************/
---------------------------------------------
-- body of stored procedure
---------------------------------------------
 SELECT top 100 id.draft_num, 
	 id.project, 
	 id.pjt_entity, 
	 isec.inv_format_cd, 
	 id.acct, 
	 ih.project_billwith, 
	 ih.invoice_num, 
	 ih.inv_attach_cd, 
	 ih.draft_num, 
	 p.purchase_order_num, 
	 id.amount, 
	 isec.is_id09, 
	 id.li_type, 
	 id.cost_amt, 
	 b.pb_id20, 
	 id.in_id18, 
	 ih.CuryId, 
	 id.CuryTranamt, 
	 p.project_desc, 
	 pc.code_ID, 
	 pc.descr, 
	 id.noteid, 
	 ih.noteid, 
	 ih.invoice_date, 
	 c.Terms, 
	 cc.CName, 
	 cc.EmailAddress, 
	 ctrl.control_data
FROM DEN_DEV_APP.dbo.PJInvDet id (nolock)
LEFT OUTER JOIN DEN_DEV_APP.dbo.PJINVHDR ih (nolock)
	ON id.project_billwith = ih.project_billwith 
	AND id.draft_num = ih.draft_num 
LEFT OUTER JOIN DEN_DEV_APP.dbo.PJBILL b (nolock)
	ON id.project_billwith = b.project 
LEFT OUTER JOIN DEN_DEV_APP.dbo.PJPROJ p (nolock)
	ON id.project_billwith = p.project 
LEFT OUTER JOIN DEN_DEV_APP.dbo.PJINVSEC isec (nolock)
	ON id.acct = isec.acct 
LEFT OUTER JOIN DEN_DEV_APP.dbo.xIGProdCode pc (nolock)
	ON p.pm_id02 = pc.code_ID 
LEFT OUTER JOIN DEN_DEV_APP.dbo.Customer c (nolock)
	ON p.customer = c.CustId 
LEFT OUTER JOIN DEN_DEV_APP.dbo.xClientContact cc (nolock) 
	ON p.user2 = cc.EA_ID 
LEFT OUTER JOIN DEN_DEV_APP.dbo.PJCONTRL ctrl (nolock)
	ON isec.section_type = ctrl.control_code
WHERE  id.in_id18 <> 'NP'
ORDER BY ih.project_billwith
