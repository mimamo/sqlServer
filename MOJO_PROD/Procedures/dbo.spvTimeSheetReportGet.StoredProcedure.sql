USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvTimeSheetReportGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvTimeSheetReportGet]
 (
  @TimeSheetKey int
 )
AS --Encrypt

/*
  || When     Who Rel     What
  || 03/22/10 RLB 10.520  (77260) Added Transferred Out
*/
 
 SELECT 
  *
 FROM 
  vTimeSheet (NOLOCK)
 WHERE 
  TimeSheetKey = @TimeSheetKey AND TransferredOut = 0
 ORDER BY 
  TimeSheetKey, WorkDate
GO
