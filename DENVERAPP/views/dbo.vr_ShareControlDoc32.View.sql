USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vr_ShareControlDoc32]    Script Date: 12/21/2015 15:42:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_ShareControlDoc32] AS

SELECT Ord = 1, CNum = 1

UNION

SELECT Ord = 2, CNum = 1

UNION

SELECT Ord = 2, CNum = -1

UNION

SELECT Ord = 3, CNum = 1
GO
