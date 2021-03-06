USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.views WITH(NOLOCK)
            WHERE NAME = 'xvr_AR002_Aged'
                AND type = 'V'
           )
    DROP VIEW [dbo].[xvr_AR002_Aged]
GO

CREATE VIEW [dbo].[xvr_AR002_Aged]

as

/*******************************************************************************************************
*   DENVERAPP.dbo.xvr_AR002_Aged 
*
*   Creator:      
*   Date:          
*   
*
*   Notes:      
				select top 100 * 
				from DENVERAPP.dbo.xvr_AR000_Aged    
				where custId = '1PGFEM'

				select sum(CuryOrigDocAmt)
				from DENVERAPP.dbo.xvr_AR000_Aged    
				where custId = '1PGFEM'
					
				select d.custId, d.CuryOrigDocAmt, *
				from DENVERAPP.dbo.ARDoc d
				INNER JOIN DENVERAPP.dbo.AR_Balances b 
					ON d.CustID = b.CustID 
				where d.custId = '1PGFEM'

				select sum(CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 
							ELSE -1 
						END * d.CuryOrigDocAmt)
				from DENVERAPP.dbo.ARDoc d
				INNER JOIN DENVERAPP.dbo.AR_Balances b 
					ON d.CustID = b.CustID 
				where d.custId = '1PGFEM'
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/24/2016	Use DocDate if DueDate is null
********************************************************************************************************/


SELECT d.CustID
, d.ProjectID
, ClientRefNum = ISNULL(p.purchase_order_num, '')
, JobDescr = ISNULL(p.project_desc, '') 
, ProdCode = ISNULL(p.pm_id02,'')
, d.RefNbr
, c.ClassID
, DueDate = CASE WHEN coalesce(d.DueDate, '1/1/1900') = '1/1/1900' THEN d.DocDate 
				ELSE d.DueDate 
			END
, d.DocDate
, d.DocType
, CuryOrigDocAmt = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 
			ELSE -1 
		END * d.CuryOrigDocAmt
, CuryDocBal = CASE WHEN d.DocType IN ('IN','DM','FI','NC','AD') THEN 1 
		ELSE -1 
	END * d.CuryDocBal
, b.AvgDayToPay
, d.CpnyID
, d.BatSeq
, d.BatNbr
FROM DENVERAPP.dbo.ARDoc d 
INNER JOIN DENVERAPP.dbo.AR_Balances b 
	ON d.CustID = b.CustID 
LEFT JOIN DENVERAPP.dbo.PJPROJ p 
	ON d.ProjectID = p.Project
LEFT JOIN DENVERAPP.dbo.Customer c 
	ON d.CustID = c.CustID
WHERE d.Rlsed = 1 --Released
	AND d.CuryDocBal <> 0
GO


---------------------------------------------
-- permissions
---------------------------------------------

grant select on xvr_AR002_Aged to BFGROUP 
go

grant insert on xvr_AR002_Aged to BFGROUP 
go

grant update on xvr_AR002_Aged to BFGROUP 
go

grant delete on xvr_AR002_Aged to BFGROUP 
go