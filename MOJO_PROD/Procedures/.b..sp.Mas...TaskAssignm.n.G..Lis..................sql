USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskAssignmentGetList]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskAssignmentGetList]

	@MasterTaskKey int


AS --Encrypt

		SELECT *
		FROM tMasterTaskAssignment (nolock)
		WHERE
		MasterTaskKey = @MasterTaskKey
		Order By WorkOrder

	RETURN 1
GO
