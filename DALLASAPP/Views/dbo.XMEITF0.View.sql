USE [DALLASAPP]
GO
/****** Object:  View [dbo].[XMEITF0]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[XMEITF0]
AS
SELECT     g.PerEnt AS Period, g.ProjectID AS Job, SUBSTRING(g.ProjectID, 1, 3) AS Client, g.DrAmt AS Debit_Amt, g.CrAmt AS Credit_Amt, 
                      p.project_desc AS Job_Name, c.Name AS Client_Name
FROM         dbo.GLTran AS g LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON g.ProjectID = p.project LEFT OUTER JOIN
                      dbo.Customer AS c ON c.CustId = SUBSTRING(g.ProjectID, 1, 3)
WHERE     (g.Module = 'BI') AND (g.JrnlType <> 'REV') AND (g.Acct = '1299') AND (g.TaskID = '90200')
GO
