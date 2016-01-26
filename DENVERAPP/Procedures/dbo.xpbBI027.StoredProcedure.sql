USE [DENVERAPP]
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
*   DENVERAPP.dbo.xpbBI027 
*
*   Creator: Michelle Morales	   
*   Date:    01/25/2016      
*   
*          
*
*   Usage:	

	execute DENVERAPP.dbo.xpbBI027  
	
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
FROM DENVERAPP.dbo.PJInvDet id (nolock)
LEFT OUTER JOIN DENVERAPP.dbo.PJINVHDR ih (nolock)
	ON id.project_billwith = ih.project_billwith 
	AND id.draft_num = ih.draft_num 
LEFT OUTER JOIN DENVERAPP.dbo.PJBILL b (nolock)
	ON id.project_billwith = b.project 
LEFT OUTER JOIN DENVERAPP.dbo.PJPROJ p (nolock)
	ON id.project_billwith = p.project 
LEFT OUTER JOIN DENVERAPP.dbo.PJINVSEC isec (nolock)
	ON id.acct = isec.acct 
LEFT OUTER JOIN DENVERAPP.dbo.xIGProdCode pc (nolock)
	ON p.pm_id02 = pc.code_ID 
LEFT OUTER JOIN DENVERAPP.dbo.Customer c (nolock)
	ON p.customer = c.CustId 
LEFT OUTER JOIN DENVERAPP.dbo.xClientContact cc (nolock) 
	ON p.user2 = cc.EA_ID 
LEFT OUTER JOIN DENVERAPP.dbo.PJCONTRL ctrl (nolock)
	ON isec.section_type = ctrl.control_code
WHERE  id.in_id18 <> 'NP'
ORDER BY ih.project_billwith
