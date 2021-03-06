USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_BU009]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU009] 

AS 

SELECT gl_subacct, project, pjt_entity, sum(units) as 'Hours'
FROM PJTRAN
WHERE acct = 'LABOR'
GROUP BY gl_subacct, project, pjt_entity
GO
