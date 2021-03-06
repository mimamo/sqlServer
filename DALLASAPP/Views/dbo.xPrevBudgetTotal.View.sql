USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xPrevBudgetTotal]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xPrevBudgetTotal]
AS
SELECT     RT.NoteId, RT.pjt_entity_desc, RCE.Amount, RCE.Amount AS Expr1, RH_1.RevId, RH_1.Project, RCE.Acct, RT.pjt_entity, C.Name, TaxRate.TaxRate, 
                      ISNULL(RateTable.Rate_level, 0) AS Rate_Level, ISNULL(PR.rate, 1) + 1 AS Commission, 
                      CASE WHEN RH_1.Status = 'P' THEN RCE.Amount ELSE (RCE.Amount * (ISNULL(PR.Rate, 0) + 1)) END AS FinalCurrentAmount, ISNULL(RCPE.Amount, 
                      0) AS FinalPreviousAmount, CASE WHEN RH_1.Status = 'P' THEN ISNULL(RCT.Amount, 0) ELSE (CASE WHEN PC.data4 = 1 THEN ((RCE.Amount) 
                      * TaxRate.TaxRate) - (RCE.Amount) ELSE 0 END) END AS CurrentTax, ISNULL(RCPT.Amount, 0) AS PreviousTax, RateTable.effect_date
FROM         (SELECT     PH.Project, PH.RevId, ISNULL(A.PrevRevID, ISNULL(B.PrevRevID, '')) AS PrevRevID, PH.status
                       FROM          dbo.PJREVHDR AS PH LEFT OUTER JOIN
                                                  (SELECT     dbo.PJREVHDR.Project, dbo.PJREVHDR.RevId, dbo.PJPROJEX.PM_ID25 AS PrevRevID
                                                    FROM          dbo.PJREVHDR INNER JOIN
                                                                           dbo.PJPROJEX ON dbo.PJPROJEX.project = dbo.PJREVHDR.Project AND 
                                                                           dbo.PJREVHDR.RevId > dbo.PJPROJEX.PM_ID25
                                                    WHERE      (dbo.PJPROJEX.PM_ID25 <> '')) AS A ON PH.Project = A.Project AND PH.RevId = A.RevId LEFT OUTER JOIN
                                                  (SELECT     RH.Project, RH.RevId, MAX(RH1.RevId) AS PrevRevID
                                                    FROM          dbo.PJREVHDR AS RH INNER JOIN
                                                                               (SELECT     approved_by1, approved_by2, approved_by3, approver, Change_Order_Num, Create_Date, crtd_datetime, 
                                                                                                        crtd_prog, crtd_user, end_date, Est_Approve_Date, lupd_datetime, lupd_prog, lupd_user, NoteId, Post_Date, 
                                                                                                        Post_Period, Preparer, Project, RevId, RevisionType, Revision_Desc, rh_id01, rh_id02, rh_id03, rh_id04, 
                                                                                                        rh_id05, rh_id06, rh_id07, rh_id08, rh_id09, rh_id10, start_date, status, update_type, User1, User2, User3, User4,
                                                                                                         User5, User6, User7, User8, tstamp
                                                                                 FROM          dbo.PJREVHDR AS PJREVHDR_1
                                                                                 WHERE      (status = 'P')) AS RH1 ON RH.Project = RH1.Project AND RH.RevId > RH1.RevId
                                                    GROUP BY RH.Project, RH.RevId) AS B ON PH.Project = B.Project AND PH.RevId = B.RevId) AS RH_1 INNER JOIN
                      dbo.PJREVTSK AS RT ON RH_1.Project = RT.project AND RH_1.RevId = RT.revid INNER JOIN
                      dbo.PJPROJ AS PP ON PP.project = RH_1.Project INNER JOIN
                      dbo.Customer AS C ON PP.customer = C.CustId LEFT OUTER JOIN
                      dbo.PJCODE AS PC ON RT.pjt_entity = PC.code_value AND PC.code_type = '0FUN' LEFT OUTER JOIN
                      dbo.PJADDR AS PA ON PP.project = PA.addr_key AND PA.addr_type_cd = 'BI' LEFT OUTER JOIN
                          (SELECT     Acct, Amount, crtd_datetime, crtd_prog, crtd_user, lupd_datetime, lupd_prog, lupd_user, NoteId, pjt_entity, project, Rate, rc_id01, rc_id02, 
                                                   rc_id03, rc_id04, rc_id05, rc_id06, rc_id07, rc_id08, rc_id09, rc_id10, RevId, Units, user1, user2, user3, user4, User5, User6, User7, 
                                                   User8, tstamp
                            FROM          dbo.PJREVCAT
                            WHERE      (Acct = 'ESTIMATE')) AS RCE ON RH_1.Project = RCE.project AND RH_1.RevId = RCE.RevId AND 
                      RT.pjt_entity = RCE.pjt_entity LEFT OUTER JOIN
                          (SELECT     Acct, Amount, crtd_datetime, crtd_prog, crtd_user, lupd_datetime, lupd_prog, lupd_user, NoteId, pjt_entity, project, Rate, rc_id01, rc_id02, 
                                                   rc_id03, rc_id04, rc_id05, rc_id06, rc_id07, rc_id08, rc_id09, rc_id10, RevId, Units, user1, user2, user3, user4, User5, User6, User7, 
                                                   User8, tstamp
                            FROM          dbo.PJREVCAT AS PJREVCAT_3
                            WHERE      (Acct = 'ESTIMATE TAX')) AS RCT ON RH_1.Project = RCT.project AND RH_1.RevId = RCT.RevId AND 
                      RT.pjt_entity = RCT.pjt_entity LEFT OUTER JOIN
                          (SELECT     Acct, Amount, crtd_datetime, crtd_prog, crtd_user, lupd_datetime, lupd_prog, lupd_user, NoteId, pjt_entity, project, Rate, rc_id01, rc_id02, 
                                                   rc_id03, rc_id04, rc_id05, rc_id06, rc_id07, rc_id08, rc_id09, rc_id10, RevId, Units, user1, user2, user3, user4, User5, User6, User7, 
                                                   User8, tstamp
                            FROM          dbo.PJREVCAT AS PJREVCAT_2
                            WHERE      (Acct = 'ESTIMATE')) AS RCPE ON RH_1.Project = RCPE.project AND RH_1.PrevRevID = RCPE.RevId AND 
                      RT.pjt_entity = RCPE.pjt_entity LEFT OUTER JOIN
                          (SELECT     Acct, Amount, crtd_datetime, crtd_prog, crtd_user, lupd_datetime, lupd_prog, lupd_user, NoteId, pjt_entity, project, Rate, rc_id01, rc_id02, 
                                                   rc_id03, rc_id04, rc_id05, rc_id06, rc_id07, rc_id08, rc_id09, rc_id10, RevId, Units, user1, user2, user3, user4, User5, User6, User7, 
                                                   User8, tstamp
                            FROM          dbo.PJREVCAT AS PJREVCAT_1
                            WHERE      (Acct = 'ESTIMATE TAX')) AS RCPT ON RH_1.Project = RCPT.project AND RH_1.PrevRevID = RCPT.RevId AND 
                      RT.pjt_entity = RCPT.pjt_entity LEFT OUTER JOIN
                          (SELECT     SUM(ISNULL(dbo.SalesTax.TaxRate, 0)) / 100 + 1 AS TaxRate, dbo.Customer.CustId
                            FROM          dbo.Customer LEFT OUTER JOIN
                                                   dbo.SalesTax ON dbo.Customer.TaxID00 = dbo.SalesTax.TaxId OR dbo.Customer.TaxID01 = dbo.SalesTax.TaxId OR 
                                                   dbo.Customer.TaxID02 = dbo.SalesTax.TaxId OR dbo.Customer.TaxID03 = dbo.SalesTax.TaxId OR 
                                                   dbo.Customer.TaxLocId = dbo.SalesTax.TaxId
                            GROUP BY dbo.Customer.CustId) AS TaxRate ON C.CustId = TaxRate.CustId LEFT OUTER JOIN
                          (SELECT     PP.project, C.CustId, RT.pjt_entity, MIN(RateTable_1.rate_level) AS Rate_level, MAX(RateTable_1.effect_date) AS effect_date, 
                                                   RateTable_1.rate_table_id
                            FROM          dbo.PJREVTSK AS RT LEFT OUTER JOIN
                                                   dbo.PJPROJ AS PP ON PP.project = RT.project LEFT OUTER JOIN
                                                   dbo.Customer AS C ON PP.customer = C.CustId INNER JOIN
                                                       (SELECT     rate_key_value1, rate_key_value2, rate_level, rate_table_id, effect_date
                                                         FROM          dbo.PJRATE
                                                         WHERE      (rate_type_cd = 'HC')) AS RateTable_1 ON RateTable_1.rate_table_id = PP.rate_table_id AND 
                                                   (PP.project = RateTable_1.rate_key_value1 AND RT.pjt_entity = RateTable_1.rate_key_value2 OR
                                                   C.CustId = RateTable_1.rate_key_value1 AND RT.pjt_entity = RateTable_1.rate_key_value2 OR
                                                   PP.project = RateTable_1.rate_key_value1 AND RateTable_1.rate_key_value2 = '' OR
                                                   C.CustId = RateTable_1.rate_key_value1 AND RateTable_1.rate_key_value2 = '' OR
                                                   RT.pjt_entity = RateTable_1.rate_key_value1 AND RateTable_1.rate_key_value2 = '' OR
                                                   C.CustId = RateTable_1.rate_key_value1 AND SUBSTRING(PP.project, 4, 3) = RateTable_1.rate_key_value2) AND 
                                                   PP.start_date >= RateTable_1.effect_date
                            GROUP BY PP.project, C.CustId, RT.pjt_entity, RateTable_1.rate_table_id) AS RateTable ON RateTable.project = PP.project AND 
                      RateTable.pjt_entity = RT.pjt_entity LEFT OUTER JOIN
                      dbo.PJRATE AS PR ON PR.rate_table_id = PP.rate_table_id AND (PP.project = PR.rate_key_value1 AND RT.pjt_entity = PR.rate_key_value2 OR
                      C.CustId = PR.rate_key_value1 AND RT.pjt_entity = PR.rate_key_value2 OR
                      PP.project = PR.rate_key_value1 AND RTRIM(PR.rate_key_value2) = '' OR
                      C.CustId = PR.rate_key_value1 AND PR.rate_key_value2 = '' OR
                      RT.pjt_entity = PR.rate_key_value1 AND PR.rate_key_value2 = '' OR
                      C.CustId = PR.rate_key_value1 AND SUBSTRING(PP.project, 4, 3) = PR.rate_key_value2) AND RateTable.Rate_level = PR.rate_level AND 
                      PR.rate_type_cd = 'HC' AND PR.effect_date = RateTable.effect_date
WHERE     (NOT (RCE.project IS NULL)) OR
                      (NOT (RCE.pjt_entity IS NULL))
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
         Begin Table = "RT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PP"
            Begin Extent = 
               Top = 6
               Left = 420
               Bottom = 114
               Right = 602
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 640
               Bottom = 114
               Right = 805
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PC"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PA"
            Begin Extent = 
               Top = 114
               Left = 239
               Bottom = 222
               Right = 390
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RCE"
            Begin Extent = 
               Top = 114
               Left = 428
               Bottom = 222
               Right = 579
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TaxRate"
            Begin Extent = 
               Top = 222
               Left = 416
               Bottom = 300
               Right = 567
            End
            DisplayFlags = 280
            TopColumn = 0
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xPrevBudgetTotal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      End
         Begin Table = "PR"
            Begin Extent = 
               Top = 300
               Left = 416
               Bottom = 408
               Right = 577
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RH_1"
            Begin Extent = 
               Top = 6
               Left = 231
               Bottom = 114
               Right = 382
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RCT"
            Begin Extent = 
               Top = 114
               Left = 617
               Bottom = 222
               Right = 768
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RCPE"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RCPT"
            Begin Extent = 
               Top = 222
               Left = 227
               Bottom = 330
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RateTable"
            Begin Extent = 
               Top = 222
               Left = 605
               Bottom = 330
               Right = 756
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xPrevBudgetTotal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xPrevBudgetTotal'
GO
