USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_BU970_BTD]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BU970_BTD]

AS

SELECT act_amount as 'BTDAmount'
, project as 'Job'
, pjt_entity as 'Function'
FROM PJPTDSUM
WHERE PJPTDSUM.act_amount <> '0'
	AND acct = 'APS BTD'
GO
