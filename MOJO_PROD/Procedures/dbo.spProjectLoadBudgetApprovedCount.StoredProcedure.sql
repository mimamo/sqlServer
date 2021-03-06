USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadBudgetApprovedCount]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadBudgetApprovedCount]
	(
	@ProjectKey int
	)
AS --Encrypt

Declare @Count INT

SELECT @Count = COUNT(*) FROM tEstimate (NOLOCK)
WHERE ((isnull(ExternalApprover, 0) > 0 and ExternalStatus = 4)
Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))  
AND ProjectKey = @ProjectKey
 
 
Return ISNULL(@Count, 0)
GO
