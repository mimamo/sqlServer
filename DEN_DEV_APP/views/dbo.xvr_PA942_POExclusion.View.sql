USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA942_POExclusion]    Script Date: 12/21/2015 14:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA942_POExclusion]

AS

SELECT Purchase_Order_Num, count(Project) as 'Cnt'
FROM PJPROJ
WHERE Status_Pa = 'A'
	AND Purchase_Order_Num <> ''
	AND contract_type <> 'APS' 
GROUP BY Purchase_Order_Num
--ORDER BY count(project) ASC
GO
