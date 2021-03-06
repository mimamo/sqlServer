USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA920_Actuals]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA920_Actuals]
AS
SELECT			acct,
				SUM(Amount01) AS 'Amount01',
				SUM(Amount02) AS 'Amount02',
				SUM(Amount03) AS 'Amount03',
				SUM(Amount04) AS 'Amount04',
				SUM(Amount05) AS 'Amount05',
				SUM(Amount06) AS 'Amount06',
				SUM(Amount07) AS 'Amount07',
				SUM(Amount08) AS 'Amount08',
				SUM(Amount09) AS 'Amount09',
				SUM(Amount10) AS 'Amount10',
				SUM(Amount11) AS 'Amount11',
				SUM(Amount12) AS 'Amount12',
				SUM(Amount13) AS 'Amount13',
				SUM(Amount14) AS 'Amount14',
				SUM(Amount15) AS 'Amount15',
				SUM(AmountBF) AS 'AmountBF',
				FSYearNum,
				project,
				AcctGroupCode,
				ControlCode	
FROM			(SELECT     act.acct, act.amount_01 AS Amount01, act.amount_02 AS Amount02, act.amount_03 AS Amount03, act.amount_04 AS Amount04, 
									  act.amount_05 AS Amount05, act.amount_06 AS Amount06, act.amount_07 AS Amount07, act.amount_08 AS Amount08, act.amount_09 AS Amount09, 
									  act.amount_10 AS Amount10, act.amount_11 AS Amount11, act.amount_12 AS Amount12, act.amount_13 AS Amount13, act.amount_14 AS Amount14, 
									  act.amount_15 AS Amount15, act.amount_bf AS AmountBF, act.fsyear_num AS FSYearNum, act.project, ISNULL(a.acct_group_cd, '') AS AcctGroupCode, 
									  ISNULL(c.control_code, '') AS ControlCode
				FROM         dbo.PJACTROL AS act LEFT OUTER JOIN
									  dbo.PJACCT AS a ON act.acct = a.acct LEFT OUTER JOIN
									  dbo.PJCONTRL AS c ON act.acct = c.control_data
				WHERE     (a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE', 'NA')) OR
									  (c.control_code = 'BTD')
				UNION ALL SELECT		XX.[acct],
							CASE WHEN RIGHT(XX.fiscalno,2) = '01' THEN XX.amount ELSE 0 END AS 'Amount01',
							CASE WHEN RIGHT(XX.fiscalno,2) = '02' THEN XX.amount ELSE 0 END AS 'Amount02',
							CASE WHEN RIGHT(XX.fiscalno,2) = '03' THEN XX.amount ELSE 0 END AS 'Amount03',
							CASE WHEN RIGHT(XX.fiscalno,2) = '04' THEN XX.amount ELSE 0 END AS 'Amount04',
							CASE WHEN RIGHT(XX.fiscalno,2) = '05' THEN XX.amount ELSE 0 END AS 'Amount05',
							CASE WHEN RIGHT(XX.fiscalno,2) = '06' THEN XX.amount ELSE 0 END AS 'Amount06',
							CASE WHEN RIGHT(XX.fiscalno,2) = '07' THEN XX.amount ELSE 0 END AS 'Amount07',
							CASE WHEN RIGHT(XX.fiscalno,2) = '08' THEN XX.amount ELSE 0 END AS 'Amount08',
							CASE WHEN RIGHT(XX.fiscalno,2) = '09' THEN XX.amount ELSE 0 END AS 'Amount09',
							CASE WHEN RIGHT(XX.fiscalno,2) = '10' THEN XX.amount ELSE 0 END AS 'Amount10',
							CASE WHEN RIGHT(XX.fiscalno,2) = '11' THEN XX.amount ELSE 0 END AS 'Amount11',
							CASE WHEN RIGHT(XX.fiscalno,2) = '12' THEN XX.amount ELSE 0 END AS 'Amount12',
							CASE WHEN RIGHT(XX.fiscalno,2) = '13' THEN XX.amount ELSE 0 END AS 'Amount13',
							CASE WHEN RIGHT(XX.fiscalno,2) = '14' THEN XX.amount ELSE 0 END AS 'Amount14',
							CASE WHEN RIGHT(XX.fiscalno,2) = '15' THEN XX.amount ELSE 0 END AS 'Amount15',
							XX.[previousFiscalAmt] AS 'AmountBF',
							LEFT(XX.fiscalno,4) AS 'FSYearNum',
							XX.[project] AS 'project',
							ISNULL(a.acct_group_cd, '') AS AcctGroupCode,
							ISNULL(c.control_code, '') AS ControlCode
				FROM		(SELECT		'WIP ST OFFSET' AS 'acct',
										Z.project,
										Z.fiscalno,
										SUM(Z.amount) AS amount,
										COALESCE((SELECT SUM(Y.amount) FROM dbo.pjtran Y WHERE Z.project = Y.project AND Y.data1 = 'WIP ST HARD COST' AND Y.acct = 'WIP PROD OFFSET' AND (LEFT(Z.fiscalno,4) =(LEFT(Y.fiscalno,4)-1))),0) AS 'previousFiscalAmt'
							FROM		dbo.pjtran Z
							WHERE		Z.data1 = 'WIP ST HARD COST' AND Z.acct = 'WIP PROD OFFSET'
							GROUP BY	Z.project, Z.fiscalno) AS XX LEFT OUTER JOIN
							dbo.PJACCT AS a ON XX.acct = a.acct LEFT OUTER JOIN
							dbo.PJCONTRL AS c ON XX.acct = c.control_data
				WHERE		(a.acct_group_cd IN ('WA', 'WP', 'CM', 'PB', 'FE', 'NA')) OR
									  (c.control_code = 'BTD')) AS drvTbl
GROUP BY	acct, FSYearNum, project, AcctGroupCode, ControlCode
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
         Begin Table = "act"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 189
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920_Actuals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA920_Actuals'
GO
