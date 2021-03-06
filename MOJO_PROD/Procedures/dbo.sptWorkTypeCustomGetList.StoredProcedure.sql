USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeCustomGetList]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeCustomGetList]
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int
AS

/*
|| When      Who Rel      What
|| 1/12/10   CRG 10.5.1.6 Created
*/

	SELECT	wt.WorkTypeKey, 
			ISNULL(c.Subject, wt.WorkTypeName) AS Subject,
			ISNULL(c.Description, wt.Description) AS Description
	FROM	tWorkType wt (nolock)
	LEFT JOIN tWorkTypeCustom c (nolock) ON c.Entity = @Entity AND c.EntityKey = @EntityKey AND wt.WorkTypeKey = c.WorkTypeKey
	WHERE	wt.CompanyKey = @CompanyKey
	AND		wt.Active = 1
GO
