USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskAssignmentDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskAssignmentDelete]
	@MasterTaskAssignmentKey int

AS --Encrypt

	DELETE
	FROM tMasterTaskAssignment
	WHERE
		MasterTaskAssignmentKey = @MasterTaskAssignmentKey 

	RETURN 1
GO
