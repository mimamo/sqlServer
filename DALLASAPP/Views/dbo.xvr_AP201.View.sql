USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_AP201]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_AP201]
AS
SELECT     r.RI_ID, t.Acct, t.Sub, d.Acct AS dAcct, d.Sub AS dSub, b.BatNbr, t.DrCr, t.ProjectID AS JobNum, t.Qty, COALESCE (d.RefNbr, t.RefNbr) AS RefNbr, 
                      t.TranAmt, t.TranDesc, t.UnitDesc, t.UnitPrice, b.CrTot, b.CtrlTot, d.OrigDocAmt, b.CpnyID AS batchcpny, d.DiscBal, d.DiscTkn, d.DiscDate, d.DocType, 
                      d.DocDate, b.DrTot, d.DueDate, b.EditScrnNbr, d.InvcDate, d.InvcNbr, b.JrnlType, b.NbrCycle, COALESCE (d.CpnyID, b.CpnyID) AS CpnyID, d.PayDate, 
                      t.PerEnt, t.PerPost, d.PONbr, b.Rlsed, b.Status, d.Terms, COALESCE (d.VendId, t.VendId) AS VendID, c.RI_ID AS cRI_ID, c.CpnyName,
                          (SELECT     Name
                            FROM          dbo.Vendor AS v
                            WHERE      (VendId = COALESCE (d.VendId, t.VendId))) AS Name, ISNULL(p.project_desc, '') AS Job, ISNULL(t.TaskID, '') AS FunctionID, 
                      ISNULL(p.pm_id01, '') AS ClientID, ISNULL(p.pm_id02, '') AS ProdID, d.User1 AS InvDesc, t.Labor_Class_Cd
FROM         dbo.Batch AS b LEFT OUTER JOIN
                      dbo.APDoc AS d ON b.BatNbr = d.BatNbr AND b.Module = 'AP' LEFT OUTER JOIN
                      dbo.APTran AS t ON b.BatNbr = t.BatNbr AND NOT (ISNULL(d.DocType, '') = 'VC' AND ISNULL(d.Status, '') <> 'V') AND (d.RefNbr = t.RefNbr OR
                      b.EditScrnNbr = '03060' OR
                      b.EditScrnNbr = '03040' AND b.Rlsed = 0) INNER JOIN
                      dbo.RptRuntime AS r ON COALESCE (d.PerEnt, t.PerEnt) BETWEEN r.BegPerNbr AND r.EndPerNbr OR
                      COALESCE (d.PerPost, t.PerPost) BETWEEN r.BegPerNbr AND r.EndPerNbr INNER JOIN
                      dbo.RptCompany AS c ON b.CpnyID = c.CpnyID AND r.RI_ID = c.RI_ID LEFT OUTER JOIN
                      dbo.APDoc AS mc ON mc.BatNbr = d.BatNbr AND mc.InvcNbr = d.RefNbr AND mc.VendId = d.VendId AND mc.DocType = 'VC' AND 
                      b.EditScrnNbr IN ('03010', '03020') LEFT OUTER JOIN
                      dbo.PJPROJ AS p ON t.ProjectID = p.project
WHERE     (b.EditScrnNbr NOT IN ('03010', '03020')) OR
                      (ISNULL(d.DocType, '') <> 'VC')
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
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 234
               Bottom = 114
               Right = 394
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 197
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 114
               Left = 235
               Bottom = 222
               Right = 389
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mc"
            Begin Extent = 
               Top = 222
               Left = 227
               Bottom = 330
               Right = 387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_AP201'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_AP201'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvr_AP201'
GO
