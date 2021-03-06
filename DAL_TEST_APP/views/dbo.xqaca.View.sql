USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqaca]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xqaca]
AS
SELECT     rp.RI_ID, dbo.GLTran.ProjectID, dbo.PJPROJ.project_desc, dbo.GLTran.TranDate, dbo.GLTran.CrAmt, dbo.GLTran.DrAmt, dbo.GLTran.Crtd_Prog, 
                      dbo.GLTran.TranDesc, dbo.GLTran.RefNbr, dbo.Customer.Name AS customer_name, CASE WHEN cramt <> 0 THEN CASE WHEN datediff(day, trandate, 
                      reportdate) < 30 THEN cramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) < 30 THEN - 1 * dramt ELSE 0 END END AS crrnt, 
                      CASE WHEN cramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 30 AND 
                      59 THEN cramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 30 AND 
                      59 THEN - 1 * dramt ELSE 0 END END AS thrity_to_59, CASE WHEN cramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 60 AND 
                      89 THEN cramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 60 AND 
                      89 THEN - 1 * dramt ELSE 0 END END AS sixty_to_89, CASE WHEN cramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 90 AND 
                      119 THEN cramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 90 AND 
                      119 THEN - 1 * dramt ELSE 0 END END AS ninety_to_119, CASE WHEN cramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 
                      120 AND 179 THEN cramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 120 AND 
                      179 THEN - 1 * dramt ELSE 0 END END AS one_twenty_to_179, CASE WHEN cramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) 
                      >= 180 THEN cramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) 
                      >= 180 THEN - 1 * dramt ELSE 0 END END AS one_eighty_and_higher
FROM         dbo.RptRuntime AS rp INNER JOIN
                      dbo.GLTran LEFT OUTER JOIN
                      dbo.PJPROJ ON dbo.GLTran.ProjectID = dbo.PJPROJ.project LEFT OUTER JOIN
                      dbo.Customer ON dbo.PJPROJ.customer = dbo.Customer.CustId ON rp.BegPerNbr >= dbo.GLTran.PerPost
WHERE     (dbo.GLTran.Acct IN ('2100', '2120')) AND (dbo.GLTran.Posted = 'P')
GO
