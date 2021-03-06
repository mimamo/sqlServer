USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'xvr_AR003_Aged'
                AND type = 'V'
           )
    DROP VIEW [dbo].[xvr_AR003_Aged]
GO

CREATE VIEW [dbo].[xvr_AR003_Aged]

as


/*******************************************************************************************************
*   DENVERAPP.dbo.xvr_AR003_Aged 
*
*   Creator:      
*   Date:          
*   
*
*   Notes:      
			select sum(CuryOrigDocAmt)
				from DENVERAPP.dbo.xvr_AR003_Aged    
				where custId = '1PGFEM'

*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/24/2016	Use DocDate if DueDate is null
********************************************************************************************************/


SELECT d.CustID
, d.ProjectID
, ISNULL(p.purchase_order_num, '') as 'ClientRefNum'
, ISNULL(p.project_desc, '') as 'JobDescr' 
, ISNULL(p.pm_id02,'') AS 'ProdCode'
, d.RefNbr
, c.ClassID
, DueDate = CASE WHEN coalesce(d.DueDate, '1/1/1900') = '1/1/1900' THEN d.DocDate 
				ELSE d.DueDate 
			END
, d.DocDate
, d.DocType
, CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
		THEN 1 
		ELSE -1 END * d.CuryOrigDocAmt as 'CuryOrigDocAmt'
, CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') 
		THEN 1 
		ELSE -1 END * d.CuryDocBal as 'CuryDocBal'
, b.AvgDayToPay
, d.CpnyID
, d.BatSeq
, d.BatNbr
FROM ARDoc d 
INNER JOIN AR_Balances b 
	ON d.CustID = b.CustID 
LEFT JOIN PJPROJ p 
	ON d.ProjectID = p.Project
LEFT JOIN Customer c 
	ON d.CustID = c.CustID
WHERE d.Rlsed = 1 --Released
	AND d.CuryDocBal <> 0
GO

---------------------------------------------
-- permissions
---------------------------------------------

grant select on xvr_AR003_Aged to BFGROUP 
go

grant insert on xvr_AR003_Aged to BFGROUP 
go

grant update on xvr_AR003_Aged to BFGROUP 
go

grant delete on xvr_AR003_Aged to BFGROUP 
go
