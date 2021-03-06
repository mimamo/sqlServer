USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvw_Labor_MW]    Script Date: 12/21/2015 15:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* LABOR
------  NEW LABOR VIEW THAT TIES OUT*/
CREATE VIEW [dbo].[xvw_Labor_MW]
AS
SELECT     CASE WHEN c.Custid IN ('2MWINT', '3DNVER', '3MWINT') THEN 'INDIRECT' ELSE 'DIRECT' END AS CP_Type, 'HOURS' AS CP_Group, 
                      'MIDWEST AGENCY' AS PCenter, a.acct, c.ClassGroup, c.GroupDesc, c.ClassId, c.Descr AS ClassDesc, c.CustId, c.Name AS CustName, t.project, t.units AS TTLHrs, 
                      t.fiscalno, t.trans_date, CASE WHEN t .Fiscalno >= CONVERT(char(4), YEAR(t .trans_date)) + CASE WHEN len(CONVERT(varchar, month(t .trans_date))) 
                      = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(t .trans_date)) THEN t .Fiscalno ELSE CONVERT(char(4), YEAR(t .trans_date)) 
                      + CASE WHEN len(CONVERT(varchar, month(t .trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(varchar, MONTH(t .trans_date)) END AS FiscalPeriod, 
                      CONVERT(CHAR(4), YEAR(t.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(t .trans_date))) = 1 THEN '0' ELSE '' END + CONVERT(VARCHAR, 
                      MONTH(t.trans_date)) AS TransPeriod, t.employee, t.gl_subacct
FROM         dbo.PJTran AS t LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON t.project = p.project LEFT OUTER JOIN
                      dbo.xvw_ClientGroupings_MW AS c ON p.pm_id01 = c.CustId LEFT OUTER JOIN
                      dbo.PJACCT AS a ON t.acct = a.acct
WHERE     (t.fiscalno > '201301') AND (t.acct = 'LABOR')
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
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 114
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 489
               Bottom = 114
               Right = 640
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 1134
               Bottom = 114
               Right = 1301
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvw_Labor_MW'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvw_Labor_MW'
GO
