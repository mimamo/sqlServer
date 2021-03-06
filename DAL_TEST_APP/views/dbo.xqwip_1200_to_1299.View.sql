USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqwip_1200_to_1299]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Denver stuff taken out as per Evan request.
union all 

select rp.ri_id, D.project projectid, project_desc, '01/01/1900' trandate, 0 cramt, 0 dramt, '' crtd_prog, 
'Denver Adjustment' trandesc, '' refnbr, 
customer.name customer_name, 
0 crrnt, 0 thrity_to_59, 0 sixty_to_89, 0 ninety_to_119, 0 one_twenty_to_179, D.wipamt one_eighty_and_higher 
from rptruntime rp 
cross join xwrk_DenverWIP D  
left outer join pjproj on D.project = pjproj.project 
left outer join customer on pjproj.customer = custid */
CREATE VIEW [dbo].[xqwip_1200_to_1299]
AS
SELECT     rp.RI_ID, dbo.GLTran.ProjectID, dbo.PJPROJ.project_desc, dbo.GLTran.TranDate, dbo.GLTran.CrAmt, dbo.GLTran.DrAmt, dbo.GLTran.Crtd_Prog, 
                      dbo.GLTran.TranDesc, dbo.GLTran.RefNbr, dbo.Customer.Name AS customer_name, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, 
                      reportdate) < 30 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) < 30 THEN - 1 * cramt ELSE 0 END END AS crrnt, 
                      CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 30 AND 
                      59 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 30 AND 
                      59 THEN - 1 * cramt ELSE 0 END END AS thrity_to_59, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 60 AND 
                      89 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 60 AND 
                      89 THEN - 1 * cramt ELSE 0 END END AS sixty_to_89, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 90 AND 
                      119 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 90 AND 
                      119 THEN - 1 * cramt ELSE 0 END END AS ninety_to_119, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) BETWEEN 
                      120 AND 179 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) BETWEEN 120 AND 
                      179 THEN - 1 * cramt ELSE 0 END END AS one_twenty_to_179, CASE WHEN dramt <> 0 THEN CASE WHEN datediff(day, trandate, reportdate) 
                      >= 180 THEN dramt ELSE 0 END ELSE CASE WHEN datediff(day, trandate, reportdate) 
                      >= 180 THEN - 1 * cramt ELSE 0 END END AS one_eighty_and_higher
FROM         dbo.RptRuntime AS rp INNER JOIN
                      dbo.GLTran LEFT OUTER JOIN
                      dbo.PJPROJ ON dbo.GLTran.ProjectID = dbo.PJPROJ.project LEFT OUTER JOIN
                      dbo.Customer ON dbo.PJPROJ.customer = dbo.Customer.CustId ON rp.BegPerNbr >= dbo.GLTran.PerPost
WHERE     (dbo.GLTran.Acct BETWEEN '1200' AND '1299') AND (dbo.GLTran.Posted = 'P') OR
                      (dbo.GLTran.Acct = '1321') AND (dbo.GLTran.Posted = 'P')
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "rp"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GLTran"
            Begin Extent = 
               Top = 6
               Left = 230
               Bottom = 114
               Right = 387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJPROJ"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer"
            Begin Extent = 
               Top = 114
               Left = 258
               Bottom = 222
               Right = 413
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xqwip_1200_to_1299'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xqwip_1200_to_1299'
GO
