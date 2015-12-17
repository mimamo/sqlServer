USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vRetainerCosts]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vRetainerCosts] AS
SELECT	RetainerKey, SUM(TotalLabor) AS TotalLabor, SUM(TotalExpense) AS TotalExpense, SUM(Billed) AS Billed
FROM	vProjectRetainerCosts
GROUP BY RetainerKey
GO
