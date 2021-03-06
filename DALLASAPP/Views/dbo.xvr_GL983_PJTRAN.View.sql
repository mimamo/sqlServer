USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_GL983_PJTRAN]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_GL983_PJTRAN]
AS
/*Activity*/ SELECT PJTRAN.acct, PJTRAN.amount, Customer.CustId, PJPROJ.project, Customer.[Name], PJPROJ.pm_id02, PJTRAN.fiscalno, PJPROJ.contract_type, 
                      PJPENT.pjt_entity, PJPROJ.project_desc, PJPROJEX.pm_id25, PJPROJ.status_pa
FROM         PJPROJ JOIN
                      PJPENT ON PJPROJ.project = PJPENT.project LEFT JOIN
                      PJTRAN ON PJPENT.pjt_entity = PJTRAN.pjt_entity AND PJPENT.project = PJTRAN.project LEFT JOIN
                      Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT JOIN
                      PJPROJEX ON PJPROJ.project = PJPROJEX.project 
WHERE    PJPROJ.contract_type = 'NBIZ' AND PJTRAN.gl_acct BETWEEN '7070' AND '7076'
UNION ALL
/*Budgets but no activity*/ SELECT isnull(PJTRAN.acct, '') AS 'acct', isnull(PJTRAN.amount, 0) AS 'amount', Customer.CustId, PJPROJ.project, Customer.[Name], 
                      PJPROJ.pm_id02, isnull(PJTRAN.fiscalno, '') AS 'fiscalno', PJPROJ.contract_type, PJPENT.pjt_entity, PJPROJ.project_desc, PJPROJEX.pm_id25, 
                      PJPROJ.status_pa
FROM         PJPROJ JOIN
                      PJPENT ON PJPROJ.project = PJPENT.project LEFT JOIN
                      PJTRAN ON PJPENT.pjt_entity = PJTRAN.pjt_entity AND PJPENT.project = PJTRAN.project LEFT JOIN
                      Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT JOIN
                      PJPROJEX ON PJPROJ.project = PJPROJEX.project
WHERE     PJPROJ.contract_type = 'NBIZ' AND PJTRAN.amount IS NULL AND PJPROJEX.pm_id25 <> '' AND PJTRAN.gl_acct BETWEEN '7070' AND '7076'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_GL983_PJTRAN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_GL983_PJTRAN'
GO
