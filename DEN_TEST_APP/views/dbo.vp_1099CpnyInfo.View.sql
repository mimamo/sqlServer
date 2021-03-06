USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_1099CpnyInfo]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_1099CpnyInfo] AS  			
 
SELECT r.RI_ID RI_ID, 
       c2.Master_Fed_ID Master_Fed_ID,
       c2.CpnyID CpnyID

FROM RptCompany r INNER JOIN vs_Company c ON r.cpnyid = c.cpnyid
                  INNER JOIN vs_Company c2 ON c.master_FED_id = c2.master_Fed_ID
GROUP BY r.RI_ID, c2.master_fed_ID, c2.cpnyid
GO
