USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvr_PA930_PmtDet]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* cash receipts only, not credit memos*/
CREATE VIEW [dbo].[xvr_PA930_PmtDet]
AS
SELECT     r.RI_ID, a.doctype, a.check_refnbr AS CheckNbr, c.AdjgDocDate AS DocDate, a.applied_amt AS Amount, a.CustId, a.discount_amt AS Discount, 
                      a.invoice_refnbr AS InvoiceNbr, a.invoice_type AS InvoiceType, b.ProjectID AS Project, c.RecordID AS AdjRecordid
FROM         dbo.PJARPAY AS a INNER JOIN
                      dbo.ARDoc AS b ON a.CustId = b.CustId AND a.invoice_type = b.DocType AND a.invoice_refnbr = b.RefNbr INNER JOIN
                      dbo.ARAdjust AS c ON a.CustId = c.CustId AND a.invoice_type = c.AdjdDocType AND a.invoice_refnbr = c.AdjdRefNbr AND 
                      a.doctype = c.AdjgDocType AND a.applied_amt = c.AdjAmt AND a.check_refnbr = c.AdjgRefNbr INNER JOIN
                      dbo.RptRuntime AS r ON c.AdjgDocDate <= r.ReportDate
WHERE     (a.doctype = 'PA')
UNION ALL
SELECT     r.RI_ID, c.AdjdDocType, 'CM-' + LTRIM(RTRIM(c.AdjgRefNbr)) AS CheckNbr, c.DateAppl AS DocDate, 0 - c.CuryAdjdAmt AS Amount, c.CustId, 
                      '0' AS Discount, c.AdjdRefNbr AS InvoiceNbr, c.AdjgDocType AS InvoiceType, b.ProjectID AS Project, c.RecordID AS AdjRecordid
FROM         dbo.ARAdjust AS c INNER JOIN
                      dbo.ARDoc AS b ON c.CustId = b.CustId AND c.AdjgDocType = b.DocType AND c.AdjgRefNbr = b.RefNbr INNER JOIN
                      dbo.RptRuntime AS r ON c.AdjgDocDate <= r.ReportDate
WHERE     (c.AdjdDocType = 'SC')
UNION ALL
SELECT     r.RI_ID, c.AdjgDocType, 'INV-' + LTRIM(RTRIM(c.AdjdRefNbr)) AS CheckNbr, c.AdjgDocDate AS DocDate, c.CuryAdjdAmt AS Amount, c.CustId, 
                      '0' AS Discount, c.AdjgRefNbr AS InvoiceNbr, c.AdjdDocType AS InvoiceType, b.ProjectID AS Project, c.RecordID AS AdjRecordid
FROM         dbo.ARAdjust AS c INNER JOIN
                      dbo.ARDoc AS b ON c.CustId = b.CustId AND c.AdjdDocType = b.DocType AND c.AdjdRefNbr = b.RefNbr INNER JOIN
                      dbo.RptRuntime AS r ON c.AdjgDocDate <= r.ReportDate
WHERE     (c.AdjgDocType = 'SB')
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA930_PmtDet'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_PA930_PmtDet'
GO
