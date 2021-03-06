USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceODBILLING]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceODBILLING]
	(
		@UserKey INT
		,@Value int
	)
AS --Encrypt

	SET NOCOUNT ON 
	
/*
|| When      Who Rel      What
|| 06/04/12  GHL 10.556   Added logic for GL Company restrict
*/
	-- Value or Mode
	-- 1 = My Billing Worksheets
	-- 2 = All Billing Worksheets
			
	Declare @CompanyKey int
			,@RestrictToGLCompany int

	Select @CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		  ,@RestrictToGLCompany = ISNULL(p.RestrictToGLCompany, 0)
	from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	DECLARE @CurrentDate DATETIME
	
	select @CurrentDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)
	
	SELECT b.*
		    ,c.CustomerID   AS ClientID
		    ,c.CompanyName   AS ClientName
		    ,p.ProjectNumber
		    ,p.ProjectName
		    ,ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') As ApproverName
	FROM   tBilling b (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON b.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON b.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tUser u (NOLOCK) ON b.Approver = u.UserKey
	WHERE  b.CompanyKey = @CompanyKey
	AND    b.Status < 4	-- To Approve
	AND	   b.DueDate < @CurrentDate
	AND    (@Value = 2 OR b.Approver = @UserKey)
	and (@RestrictToGLCompany = 0 OR 
	    b.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey)
		)

	RETURN 1
GO
