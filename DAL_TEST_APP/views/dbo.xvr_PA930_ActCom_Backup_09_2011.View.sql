USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_ActCom_Backup_09_2011]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_PA930_ActCom_Backup_09_2011]
AS
SELECT     TOP (100) PERCENT r.RI_ID, t.project AS Project, t.pjt_entity AS Task, COALESCE (a.Acct, '') AS Acct, a.tr_id11, COALESCE (a.tr_id03, '') AS PONbr, 
                      COALESCE (a.vendor_num, '') AS VendorID, COALESCE (a.employee, '') AS EmployeeID, COALESCE (a.trans_date, '01/02/2000') AS TranDate, 
                      COALESCE (a.Amount, 0) AS Amount, COALESCE (a.Units, 0) AS Units, 0 AS MarkupAmount, COALESCE (d.Amount, 0) AS BilledAmount, '' AS TranType, 
                      COALESCE (a.tr_id02, '') AS InvoiceNbr, COALESCE (a.tr_id08, '') AS InvoiceDate, COALESCE (a.tr_comment, '') AS Description, 
                      COALESCE (c.acct_group_cd, 'WP') AS AcctGroup, COALESCE (d.invoice_num, '') AS ClientInvNbr, COALESCE (d.ih_id12, '') AS OrigInvNbr, 
                      COALESCE (d.invoice_type, '') AS Invoice_Type
FROM         dbo.RptRuntime AS r CROSS JOIN
                      dbo.PJPENT AS t LEFT OUTER JOIN
                      dbo.xvr_pa930_pjtran AS a ON t.project = a.Project AND t.pjt_entity = a.pjt_entity AND r.ReportDate >= a.trans_date LEFT OUTER JOIN
                      dbo.PJACCT AS c ON a.Acct = c.acct LEFT OUTER JOIN
                      dbo.xvr_PA930_invdet AS d ON a.tr_id11 = d.in_id12 AND r.ReportDate >= d.invoice_date AND d.bill_status = 'B'
UNION ALL
SELECT     TOP (100) PERCENT r.RI_ID, t.project AS Project, t.pjt_entity AS Task, COALESCE (f.acct, a.acct) AS Acct, a.tr_id23 AS tr_id11, COALESCE (a.tr_id03, '') 
                      AS PONbr, COALESCE (a.vendor_num, '') AS VendorID, COALESCE (a.employee, '') AS EmployeeID, COALESCE (a.trans_date, '01/02/2000') AS TranDate,
                       COALESCE (f.Amount, 0) AS Amount, COALESCE (a.units, 0) AS Units, COALESCE (e.Amount, 0) AS MarkupAmount, COALESCE (d.Amount, 0) 
                      AS BilledAmount, '' AS TranType, COALESCE (a.tr_id02, '') AS InvoiceNbr, COALESCE (a.tr_id08, '') AS InvoiceDate, COALESCE (a.tr_comment, '') 
                      AS Description, COALESCE (f.acct_group_cd, 'WP') AS AcctGroup, COALESCE (CASE WHEN d .invoice_type = 'REVD' THEN '' ELSE d .invoice_num END,
                       '') AS ClientInvNbr, COALESCE (d.ih_id12, '') AS OrigInvNbr, COALESCE (d.invoice_type, '') AS Invoice_Type
FROM         dbo.PJPENT AS t CROSS JOIN
                      dbo.RptRuntime AS r LEFT OUTER JOIN
                      dbo.PJTRAN AS a ON t.project = a.project AND t.pjt_entity = a.pjt_entity AND r.ReportDate >= a.trans_date LEFT OUTER JOIN
                      dbo.PJACCT AS c ON c.acct = a.acct LEFT OUTER JOIN
                      dbo.xvr_PA930_invsum AS d ON a.tr_id23 = d.tr_id12 AND r.ReportDate >= d.invoice_date AND d.bill_status = 'B' LEFT OUTER JOIN
                      dbo.xvr_PA930_MarkupSum AS e ON a.tr_id23 = e.tr_id12 AND r.ReportDate >= e.Trans_date LEFT OUTER JOIN
                      dbo.xvr_PA930_AmountSum AS f ON a.tr_id23 = f.tr_id12 AND r.ReportDate >= f.Trans_date
WHERE     (c.acct_group_cd IN ('LB', 'AC'))
UNION ALL
SELECT     TOP (100) PERCENT r.RI_ID, a.project AS Project, a.pjt_entity AS Task, a.acct AS Acct, '' AS tr_id11, a.purchase_order_num AS PONbr, 
                      a.vendor_num AS VendorID, '' AS EmployeeID, a.po_date AS TranDate, a.amount AS Amount, 0 AS Units, 0 AS MarkupAmount, 0 AS BilledAmount, 
                      'PO' AS TranType, '' AS InvoiceNbr, '' AS InvoiceDate, a.tr_comment AS Description, b.acct_group_cd AS AcctGroup, '' AS ClientInvNbr, '' AS OrigInvNbr, 
                      '' AS Invoice_Type
FROM         dbo.PJCOMDET AS a INNER JOIN
                      dbo.PJACCT AS b ON a.acct = b.acct INNER JOIN
                      dbo.RptRuntime AS r ON a.po_date <= r.ReportDate
ORDER BY project, task
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA930_ActCom_Backup_09_2011'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA930_ActCom_Backup_09_2011'
GO
