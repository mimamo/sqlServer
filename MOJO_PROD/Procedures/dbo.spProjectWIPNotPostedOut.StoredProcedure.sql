USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectWIPNotPostedOut]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProjectWIPNotPostedOut]
	
	 @CompanyKey int
	,@ProjectKey int
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/23/15 WDF 8.591 (234379) Check if WIP is posted in but not posted out
  */
  
DECLARE @TrackWIP tinyint
DECLARE @ERCnt int, @MCCnt int, @VDCnt int, @NotPostedOutCnt int
  
    SELECT @NotPostedOutCnt = 0

	SELECT @TrackWIP = TrackWIP FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey 

	IF @TrackWIP = 1
	BEGIN
		
		SELECT @ERCnt = COUNT(*)
		  FROM tExpenseReceipt er (nolock) inner join tExpenseEnvelope ee (nolock) on ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
		 WHERE er.VoucherDetailKey is null
		   AND ee.CompanyKey = @CompanyKey
		   AND er.ProjectKey = @ProjectKey
		   AND (er.WIPPostingInKey  > 0
		   AND  er.WIPPostingOutKey = 0)

		SELECT @MCCnt = COUNT(*)
		  FROM tMiscCost mc (nolock) inner join tProject p (nolock) on p.ProjectKey = mc.ProjectKey
		 WHERE p.CompanyKey = @CompanyKey
		   AND mc.ProjectKey = @ProjectKey
		   AND (mc.WIPPostingInKey  > 0
		   AND  mc.WIPPostingOutKey = 0)

		SELECT @VDCnt = COUNT(*)
		  FROM tVoucherDetail (nolock)
		 WHERE ProjectKey = @ProjectKey
		   AND (WIPPostingInKey  > 0
		   AND  WIPPostingOutKey = 0) 
 
        SELECT @NotPostedOutCnt = @ERCnt + @MCCnt + @VDCnt

		IF (@NotPostedOutCnt) = 0
		BEGIN
			SELECT @NotPostedOutCnt = COUNT(*)
			  FROM tTime t (nolock) inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey	
			 WHERE ts.CompanyKey = @CompanyKey
			   AND t.ProjectKey = @ProjectKey
			   AND (t.WIPPostingInKey  > 0
			   AND  t.WIPPostingOutKey = 0)
		END
	END	
		
    SELECT CASE
             WHEN @NotPostedOutCnt > 0 THEN 1
             ELSE 0
           END AS [NotPostedOut]
           
           	
	return 1
GO
