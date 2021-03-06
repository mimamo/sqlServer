USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_PA934_PJTRAN]    Script Date: 12/21/2015 14:33:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA934_PJTRAN]

AS

SELECT sum(Units) as 'Hours'
, Project
, pjt_entity
FROM PJTRAN
WHERE acct = 'LABOR'
GROUP BY Project, pjt_entity
GO
