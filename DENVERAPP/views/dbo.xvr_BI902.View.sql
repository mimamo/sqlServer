USE [DENVERAPP]
GO
/****** Object:  View [dbo].[xvr_BI902]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_BI902]
AS
SELECT     p.status_pa, d.project_billwith, d.hold_status, d.acct, d.source_trx_date, d.amount, d.project, d.pjt_entity, p1.project_desc, a.sort_num, p.pm_id01, 
                      x.code_ID, x.descr, p.end_date, d.li_type, c.Name, d.draft_num, a.acct_group_cd, 
                      CASE WHEN h.fiscalno > '200911' THEN 'U' WHEN h.fiscalno = '' THEN 'U' ELSE 'B' END AS Bill_Status
FROM         dbo.PJInvDet AS d LEFT OUTER JOIN
                      dbo.PJINVHDR AS h ON d.draft_num = h.draft_num INNER JOIN
                      dbo.PJPROJ AS p ON d.project_billwith = p.project INNER JOIN
                      dbo.PJACCT AS a ON d.acct = a.acct INNER JOIN
                      dbo.PJPROJ AS p1 ON d.project = p1.project LEFT OUTER JOIN
                      dbo.xIGProdCode AS x ON p.pm_id02 = x.code_ID LEFT OUTER JOIN
                      dbo.Customer AS c ON p.pm_id01 = c.CustId
WHERE     (d.hold_status <> 'PG') AND (d.fiscalno <= '201002') AND (a.acct_group_cd NOT IN ('CM', 'FE')) AND (p1.project NOT IN
                          (SELECT     JobID
                            FROM          dbo.xWIPAgingException)) AND (p.contract_type <> 'APS') AND (SUBSTRING(d.acct, 1, 6) <> 'OFFSET') OR
                      (d.hold_status <> 'PG') AND (d.fiscalno <= '201002') AND (a.acct_group_cd NOT IN ('CM', 'FE')) AND (p1.project NOT IN
                          (SELECT     JobID
                            FROM          dbo.xWIPAgingException AS xWIPAgingException_2)) AND (p.contract_type <> 'APS') AND (d.acct = 'OFFSET PREBILL')
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
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 242
               Bottom = 114
               Right = 413
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 114
               Left = 258
               Bottom = 222
               Right = 409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p1"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "x"
            Begin Extent = 
               Top = 222
               Left = 258
               Bottom = 330
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 0
         End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_BI902'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_BI902'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_BI902'
GO
