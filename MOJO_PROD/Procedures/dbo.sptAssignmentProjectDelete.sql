USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentProjectDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptAssignmentProjectDelete]

	(
		@ProjectKey int,
		@CompanyKey int,
		@Type int -- Type of User 1 for Employees, 2 for Contacts
	)

AS --Encrypt

	IF @Type = 1
		DELETE FROM tAssignment
		WHERE
			ProjectKey = @ProjectKey AND
			UserKey IN (SELECT UserKey FROM tUser WHERE CompanyKey = @CompanyKey)
	
	IF @Type = 2
		DELETE FROM tAssignment
		WHERE
			ProjectKey = @ProjectKey AND
			UserKey IN (SELECT UserKey FROM tUser WHERE OwnerCompanyKey = @CompanyKey)
GO
