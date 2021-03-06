USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xvMojo_Report_TimeDetail]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvMojo_Report_TimeDetail]
AS
SELECT     CompanyKey, GLCompanyKey, OwnerCompanyKey, TimeSheetKey, CustomFieldKey, [Client Name], [Client ID], [Project Name], [Project Number], 
                      [Client Project Number], [Project Primary Contact], [Project Full Name], [Project Type], [Campaign ID], [Campaign Name], [Campaign Segment], 
                      [Account Manager], [User System ID], [User First Name], [User Last Name], [User Full Name], [User Department], [User Office Name], 
                      [Project Office Name], [User Company Name], [Parent Company], [Task ID], [Task Full Name], [Task Name], [Assignment ID], [Assignment Subject], 
                      [Assignment Full Name], [Task Type], [Task Description], [Line Number], [Service Code], [Service Rate Level], [Billed Service Code], [Date Created], 
                      [Date Submitted For Approval], [Date Approved], [Date And Time Created], [Date And Time Submitted], [Date And Time Approved], [Approved By], 
                      [Current Approver], [Approval Status], [Write Off Reason], [Service Description], [Client Division], [Client Product], [Date Worked], [Date Worked Year], 
                      [Date Worked Year Formatted], [Date Worked Month], [Date Worked Month Formatted], [Actual Hours Worked], [Actual Billable Hours], 
                      [Actual Non Billable Hours], [Actual Billable Amount], [Actual Non Billable Amount], [Actual Billing Rate], [Actual Cost Rate], [Actual Total Cost], 
                      [Actual Net Profit], [Billed Hours], [Billed Rate], [Billed Total Amount], [Billed Net Profit], [Billed Comments], Comments, [Project Status], 
                      [Non Billable Project], [Active Project], Downloaded, [Invoice Number], [Billing Status], [Marked Billed Hours], [Marked Billed Total], [Write off Hours], 
                      [Write off Total], [Posted Into WIP], [Posted Out Of WIP], Verified, [Start Time], [End Time], [Start Date Time], [End Date Time], [Billed Difference], 
                      [Budget Hours], [Retainer Name], [Project Billing Status], [Date Billed], [Billing Item ID], [Billing Item Name], [Client Company Type], [Company ID], 
                      [Company Name], [Class ID], [Class Name], [Transferred Out], [Date Worked Week]
FROM         OPENQUERY(sqlwmj, 'Select * from MOjo_prod.dbo.vReport_TimeDetail') AS derivedtbl_1
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
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 267
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvMojo_Report_TimeDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'xvMojo_Report_TimeDetail'
GO
