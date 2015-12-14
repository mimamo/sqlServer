USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[xWKMJG_Timecard_Exception]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gregory Houston / IronWare
-- Create date: 12.27.2011
-- Description:	To generate WKMJG exception report for Time Sheets
-- =============================================
CREATE PROCEDURE [dbo].[xWKMJG_Timecard_Exception]
	
	@ENTITYKEY int,
	@DATEADDEDFROM smalldatetime,
	@DATEADDEDTO smalldatetime,
	@TRANSFERRED int,
	@PROJECTNUMBER varchar(50),
	@FUNCTIONCODE varchar(50),
	@USERID varchar(50),
	@WORKDATE smalldatetime,
	@APPROVERID varchar(50)
	
AS
BEGIN

SET NOCOUNT ON
SELECT * INTO #xWKMJG_Timecard_Exception FROM xWKMJG_Timecard_Exception_tmp WHERE 1 = 2

IF @TRANSFERRED = 0 BEGIN
INSERT INTO #xWKMJG_Timecard_Exception
SELECT a.EntityKey, a.Action, a.DateAdded, a.DateTransferred, a.Error, A.TransferStatus,
		b.ProjectNumber, b.SalesAccountNumber as FunctionCode, b.UserID, b.TotalHours,
		b.WorkDate, b.ApproverID, b.TransactionDate from intLogQueue a RIGHT OUTER JOIN intLogTimeDetail b ON
		a.LogKey = b.LogKey
		WHERE Entity = 'TimeSheet' AND a.Action = 'Approved' AND a.DateTransferred IS NULL END
		ELSE BEGIN
INSERT INTO #xWKMJG_Timecard_Exception		
SELECT a.EntityKey, a.Action, a.DateAdded, a.DateTransferred, a.Error, A.TransferStatus,
		b.ProjectNumber, b.SalesAccountNumber as FunctionCode, b.UserID, b.TotalHours,
		b.WorkDate, b.ApproverID, b.TransactionDate from intLogQueue a RIGHT OUTER JOIN intLogTimeDetail b ON
		a.LogKey = b.LogKey
		WHERE Entity = 'TimeSheet' AND a.Action = 'Approved' AND a.DateTransferred IS NOT NULL
		END
   
 IF @ENTITYKEY <> 0 BEGIN
 DELETE FROM #xWKMJG_Timecard_Exception WHERE EntityKey <> @ENTITYKEY END
 
 IF @DATEADDEDFROM <> Cast('1/1/1900' as smalldatetime) BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE DateAdded < @DATEADDEDFROM  END
  
IF @DATEADDEDTO <> Cast('1/1/1900' as smalldatetime) BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE DateAdded > @DATEADDEDFROM  END
  
IF @PROJECTNUMBER <> '' BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE ProjectNumber <> @PROJECTNUMBER END 
  
IF @FUNCTIONCODE <> '' BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE FunctionCode <> @FUNCTIONCODE END  
  
IF @WORKDATE <> Cast('1/1/1900' as smalldatetime) BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE WorkDate <> @WORKDATE END  
  
IF @USERID <> '' BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE UserID NOT LIKE @USERID + '%' END  

IF @APPROVERID <> '' BEGIN
  DELETE FROM #xWKMJG_Timecard_Exception WHERE ApproverID NOT LIKE @APPROVERID + '%' END  
     
   
SELECT * FROM #xWKMJG_Timecard_Exception
END
GO
