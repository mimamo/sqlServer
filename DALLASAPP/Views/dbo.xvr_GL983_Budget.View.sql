USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_GL983_Budget]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_GL983_Budget]
as

SELECT a.project
, a.amount
, a.revID
, b.Post_Period
FROM (
SELECT project
, sum(amount) as 'amount'
, revID
FROM PJREVCAT  
GROUP BY project, revID) a LEFT JOIN PJREVHDR b ON a.project = b.project
	AND a.revID = b.RevID
GO
