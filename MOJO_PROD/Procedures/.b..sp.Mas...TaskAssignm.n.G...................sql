USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskAssignmentGet]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskAssignmentGet]
	@MasterTaskAssignmentKey int

AS --Encrypt

		SELECT mta.*
		FROM tMasterTaskAssignment mta (nolock)
		WHERE
			MasterTaskAssignmentKey = @MasterTaskAssignmentKey

	RETURN 1
GO
