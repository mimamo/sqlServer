USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_PA920]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*added by RF*/
CREATE VIEW [dbo].[xvr_PA920]
AS
SELECT     PJPROJ.pm_id01, Customer.Name AS Client, PJPROJ.pm_id02, ISNULL(PJCODE.code_value_desc, '') AS Product, PJPROJ.project, PJPROJ.project_desc, 
                      PJPROJ.purchase_order_num, ISNULL(PJPTDROL.eac_amount, 0) AS Estimate_amount, ISNULL(PJACTROL.fsyear_num, 0) AS btd_fsyear_num, 
                      ISNULL(PJACTROL.amount_01, 0) AS btd_amount_01, ISNULL(PJACTROL.amount_02, 0) AS btd_amount_02, ISNULL(PJACTROL.amount_03, 0) AS btd_amount_03, 
                      ISNULL(PJACTROL.amount_04, 0) AS btd_amount_04, ISNULL(PJACTROL.amount_05, 0) AS btd_amount_05, ISNULL(PJACTROL.amount_06, 0) AS btd_amount_06, 
                      ISNULL(PJACTROL.amount_07, 0) AS btd_amount_07, ISNULL(PJACTROL.amount_08, 0) AS btd_amount_08, ISNULL(PJACTROL.amount_09, 0) AS btd_amount_09, 
                      ISNULL(PJACTROL.amount_10, 0) AS btd_amount_10, ISNULL(PJACTROL.amount_11, 0) AS btd_amount_11, ISNULL(PJACTROL.amount_12, 0) AS btd_amount_12, 
                      ISNULL(PJACTROL.amount_13, 0) AS btd_amount_13, ISNULL(PJACTROL.amount_14, 0) AS btd_amount_14, ISNULL(PJACTROL.amount_15, 0) AS btd_amount_15, 
                      ISNULL(PJACTROL.amount_bf, 0) AS btd_amount_bf, PJPROJ.start_date, PJPROJ.end_date AS on_shelf_date, PJPROJ.pm_id08 AS close_date, 
                      ISNULL(PJACTROL_1.fsyear_num, 0) AS act_fsyear_num, ISNULL(PJACTROL_1.amount_01, 0) AS act_amount_01, ISNULL(PJACTROL_1.amount_02, 0) 
                      AS act_amount_02, ISNULL(PJACTROL_1.amount_03, 0) AS act_amount_03, ISNULL(PJACTROL_1.amount_04, 0) AS act_amount_04, ISNULL(PJACTROL_1.amount_05, 
                      0) AS act_amount_05, ISNULL(PJACTROL_1.amount_06, 0) AS act_amount_06, ISNULL(PJACTROL_1.amount_07, 0) AS act_amount_07, 
                      ISNULL(PJACTROL_1.amount_08, 0) AS act_amount_08, ISNULL(PJACTROL_1.amount_09, 0) AS act_amount_09, ISNULL(PJACTROL_1.amount_10, 0) 
                      AS act_amount_10, ISNULL(PJACTROL_1.amount_11, 0) AS act_amount_11, ISNULL(PJACTROL_1.amount_12, 0) AS act_amount_12, ISNULL(PJACTROL_1.amount_13, 
                      0) AS act_amount_13, ISNULL(PJACTROL_1.amount_14, 0) AS act_amount_14, ISNULL(PJACTROL_1.amount_15, 0) AS act_amount_15, 
                      ISNULL(PJACTROL_1.amount_bf, 0) AS act_amount_bf, ISNULL(PJACTROL_1.acct, '') AS act_acct, ISNULL(PJACTROL.acct, '') AS btd_acct, ISNULL(PJPTDROL.acct, '') 
                      AS estimate_acct, ISNULL(PJACCT.acct_group_cd, '') AS AcctGrpCd
FROM         dbo.PJPROJ AS PJPROJ LEFT OUTER JOIN
                      dbo.Customer AS Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT OUTER JOIN
                      dbo.PJCODE AS PJCODE ON PJPROJ.pm_id02 = PJCODE.code_value LEFT OUTER JOIN
                          (SELECT     acct, act_amount, act_units, com_amount, com_units, crtd_datetime, crtd_prog, crtd_user, data1, data2, data3, data4, data5, eac_amount, eac_units, 
                                                   fac_amount, fac_units, lupd_datetime, lupd_prog, lupd_user, project, rate, total_budget_amount, total_budget_units, user1, user2, user3, user4, 
                                                   tstamp
                            FROM          dbo.PJPTDROL AS PJPTDROL_1
                            WHERE      (acct IN ('ESTIMATE', 'ESTIMATE TAX'))) AS PJPTDROL ON PJPROJ.project = PJPTDROL.project LEFT OUTER JOIN
                          (SELECT     PJACTROL_2.acct, PJACTROL_2.amount_01, PJACTROL_2.amount_02, PJACTROL_2.amount_03, PJACTROL_2.amount_04, PJACTROL_2.amount_05, 
                                                   PJACTROL_2.amount_06, PJACTROL_2.amount_07, PJACTROL_2.amount_08, PJACTROL_2.amount_09, PJACTROL_2.amount_10, 
                                                   PJACTROL_2.amount_11, PJACTROL_2.amount_12, PJACTROL_2.amount_13, PJACTROL_2.amount_14, PJACTROL_2.amount_15, 
                                                   PJACTROL_2.amount_bf, PJACTROL_2.crtd_datetime, PJACTROL_2.crtd_prog, PJACTROL_2.crtd_user, PJACTROL_2.data1, PJACTROL_2.fsyear_num, 
                                                   PJACTROL_2.lupd_datetime, PJACTROL_2.lupd_prog, PJACTROL_2.lupd_user, PJACTROL_2.project, PJACTROL_2.units_01, PJACTROL_2.units_02, 
                                                   PJACTROL_2.units_03, PJACTROL_2.units_04, PJACTROL_2.units_05, PJACTROL_2.units_06, PJACTROL_2.units_07, PJACTROL_2.units_08, 
                                                   PJACTROL_2.units_09, PJACTROL_2.units_10, PJACTROL_2.units_11, PJACTROL_2.units_12, PJACTROL_2.units_13, PJACTROL_2.units_14, 
                                                   PJACTROL_2.units_15, PJACTROL_2.units_bf, PJACTROL_2.tstamp
                            FROM          dbo.PJACTROL AS PJACTROL_2 INNER JOIN
                                                   dbo.PJCONTRL AS PJCONTRL_1 ON PJACTROL_2.acct = PJCONTRL_1.control_data
                            WHERE      (PJCONTRL_1.control_code = 'BTD')) AS PJACTROL ON PJPROJ.project = PJACTROL.project LEFT OUTER JOIN
                      dbo.PJACTROL AS PJACTROL_1 ON PJPROJ.project = PJACTROL_1.project LEFT OUTER JOIN
                      dbo.PJACCT AS PJACCT ON PJACTROL_1.acct = PJACCT.acct AND PJACCT.acct_group_cd IN ('WP', 'WA', 'NA')
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
         Begin Table = "PJPROJ"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 114
               Right = 423
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJCODE"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJPTDROL"
            Begin Extent = 
               Top = 114
               Left = 239
               Bottom = 222
               Right = 423
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJACTROL"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJACTROL_1"
            Begin Extent = 
               Top = 222
               Left = 227
               Bottom = 330
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PJACCT"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 189
            End
            DisplayFlags = 28' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'0
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920'
GO
