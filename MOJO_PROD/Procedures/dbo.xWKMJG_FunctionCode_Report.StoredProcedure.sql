USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[xWKMJG_FunctionCode_Report]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gregory Houston / IronWare
-- Create date: 12.27.2011
-- Description:	To generate WKMJG exception report for missing AGY Function code
-- =============================================
CREATE PROCEDURE [dbo].[xWKMJG_FunctionCode_Report]
	
	@ENTITYKEY int,
	@DATEADDEDFROM smalldatetime,
	@DATEADDEDTO smalldatetime,
	@PROJECTNUMBER varchar(50),
	@FUNCTIONCODE varchar(50)
	
AS

BEGIN

	SET NOCOUNT ON
	SELECT * INTO #xWKMJG_FunctionCode_Exception FROM xWKMJG_FunctionCode_Exception WHERE 1 = 2

	IF @ENTITYKEY <> 0 BEGIN
	DELETE FROM #xWKMJG_FunctionCode_Exception WHERE EntityKey <> @ENTITYKEY END

	IF @DATEADDEDFROM <> Cast('1/1/1900' as smalldatetime) BEGIN
	DELETE FROM #xWKMJG_FunctionCode_Exception WHERE DateAdded < @DATEADDEDFROM  END

	IF @DATEADDEDTO <> Cast('1/1/1900' as smalldatetime) BEGIN
	DELETE FROM #xWKMJG_FunctionCode_Exception WHERE DateAdded > @DATEADDEDFROM  END

	IF @PROJECTNUMBER <> '' BEGIN
	DELETE FROM #xWKMJG_FunctionCode_Exception WHERE ProjectNumber <> @PROJECTNUMBER END 

	IF @FUNCTIONCODE <>  '' BEGIN
	DELETE FROM #xWKMJG_FunctionCode_Exception WHERE FunctionCode <> @FUNCTIONCODE END  


	SELECT * FROM #xWKMJG_FunctionCode_Exception

END
GO
