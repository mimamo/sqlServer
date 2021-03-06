USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmcbr00]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------------------------------------------------------------------------------------------------------------
 MAG 4/29/11                                                                                             --
 Created for the Client Billing Rates audit report (XM.CBR.00)                                           --
 This view was created to retrieve billing rates based on all the factors and levels from                --
 the PJRATE table using table '0000', rate type 'LB' and for all the rate levels.                        --
                                                                                                         --
----------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[xmcbr00]
AS
SELECT     SUBSTRING(a.rate_key_value1, 1, 3) AS Client, a.rate_key_value1 AS Job, a.rate_key_value2 AS Labor_Class, '' AS Product, '' AS Employee, 
                      '' AS Function_Code, '1' AS Sort, '1' AS Rate_Level, a.rate AS Billing_Rate, a.effect_date AS Effect_Date
FROM         dbo.PJRATE AS a LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON a.rate_key_value1 = p.project
WHERE     (a.rate_table_id = '0000') AND (a.rate_type_cd = 'LB') AND (a.rate_level = '1') AND (p.status_pa = 'A') AND (a.effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     rate_key_value1 AS Client, '' AS Job, '' AS Labor_Class, rate_key_value2 AS Product, '' AS Employee, '' AS Function_Code, '2' AS Sort, 
                      '2' AS Rate_Level, rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '2') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     rate_key_value1 AS Client, '' AS Job, '' AS Labor_Class, '' AS Product, rate_key_value2 AS Employee, '' AS Function_Code, '3' AS Sort, 
                      '3' AS Rate_Level, rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '3') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     rate_key_value1 AS Client, '' AS Job, rate_key_value2 AS Labor_Class, '' AS Product, '' AS Employee, '' AS Function_Code, '4' AS Sort, 
                      '4' AS Rate_Level, rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '4') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     rate_key_value1 AS Client, '' AS Job, '' AS Labor_Class, '' AS Product, '' AS Employee, rate_key_value2 AS Function_Code, '5' AS Sort, 
                      '5' AS Rate_Level, rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '5') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     'ZZZ-AllClients' AS Client, '' AS Job, '' AS Labor_Class, '' AS Product, '' AS Employee, rate_key_value1 AS Function_Code, '7' AS Sort, 
                      '6' AS Rate_Level, rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '6') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     rate_key_value1 AS Client, '' AS Job, '' AS Labor_Class, '' AS Product, '' AS Employee, '' AS Function_Code, '6' AS Sort, '7' AS Rate_Level, 
                      rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '7') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
UNION ALL
SELECT     'ZZZ-AllClients' AS Client, '' AS Job, rate_key_value1 AS Labor_Class, '' AS Product, '' AS Employee, '' AS Function_Code, '8' AS Sort, 
                      '9' AS Rate_Level, rate AS Billing_Rate, effect_date AS Effect_Date
FROM         dbo.PJRATE AS a
WHERE     (rate_table_id = '0000') AND (rate_type_cd = 'LB') AND (rate_level = '9') AND (effect_date =
                          (SELECT     MAX(effect_date) AS Expr1
                            FROM          dbo.PJRATE
                            WHERE      (rate_table_id = a.rate_table_id) AND (rate_type_cd = a.rate_type_cd) AND (rate_level = a.rate_level) AND 
                                                   (rate_key_value1 = a.rate_key_value1) AND (rate_key_value2 = a.rate_key_value2)))
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
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
      Begin ColumnWidths = 5
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xmcbr00'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xmcbr00'
GO
