USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[vr_ShareControlDoc2]    Script Date: 12/21/2015 14:33:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vr_ShareControlDoc2] AS

SELECT CNum = 1

UNION

SELECT CNum = -1
GO
