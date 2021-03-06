USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepCompleteStatus]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepCompleteStatus]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/22/12 RLB	10.557	(147089) only checking to see if there are any not completed Approval actions
*/

if exists(Select 1 from tApprovalStep (nolock) Where Entity = @Entity and EntityKey = @EntityKey and Action = 2 and Completed = 0)
	return 0
else
	return 1
GO
