USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActionLogGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActionLogGetList]
	(
		@UserKey int  = NULL,
		@DepartmentKey int = NULL,
		@ProjectOption int = NULL,
		@GLCompanyKey int = NULL,
		@SessionUserKey int = NULL,	
		@FeedDate smalldatetime = NULL,
		@UTCOffsetHours int = NULL
	)

AS --Encrypt

/*
|| When			Who		Rel			What
|| 02/15/13		MAS		10.5.6.5	Created
|| 07/16/13     KMC     10.5.7.0    (183746) Modified the WHERE clauses to use the ActionDate instead of the 
||                                  ActionDateFormat based of the UTC time for the user.
||                                  Update the logic for the CheckAssignment flag
|| 02/13/15     RLB     10.5.8.9    (246174) removed * -1 on the @UTCOffsetHours
|| 03/12/15     RLB     10.5.8.9    Undoing the above change
|| 03/12/15     RLB     10.5.9.0    The problem with issue 246174 was that time entries action date is not utc so it was not getting pulled on correct day
||                                  so i did a union to split out the time entities and just pull them for the day
*/
	
	DECLARE @SessionUserOfficeKey int, @SessionCompanyKey int, @RestrictToGLCompany int, @Administrator int, @SecurityGroupKey int, @CheckAssignment int

	SELECT @SessionUserOfficeKey = ISNULL(OfficeKey, 0), @SessionCompanyKey = ISNULL(OwnerCompanyKey, CompanyKey),  @Administrator = ISNULL(Administrator, 0), @SecurityGroupKey = ISNULL(SecurityGroupKey, 0) FROM tUser (nolock) WHERE UserKey = @SessionUserKey

	SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0) FROM tPreference (nolock) WHERE CompanyKey = @SessionCompanyKey

	select @CheckAssignment = 1

	IF @Administrator = 1
	BEGIN
		SELECT @CheckAssignment = 0
	END
	ELSE
	BEGIN

		IF EXISTS (SELECT 1 FROM tRight r (nolock)
			INNER JOIN tRightAssigned ra (nolock) ON r.RightKey = ra.RightKey
			WHERE ra.EntityType = 'Security Group'
			AND   ra.EntityKey = @SecurityGroupKey
			AND   r.RightID = 'prjAccessAny')
		
			SELECT @CheckAssignment = 0
		ELSE
			SELECT @CheckAssignment = 1

	END

	DECLARE @NewFeedDate smalldatetime
	SELECT @NewFeedDate = DATEADD(HOUR, (-1 * @UTCOffsetHours), @FeedDate)

	/*------------------------------------------------------------------------------------------
	ProjectOptions
	--------------
	0=All Projects
	1=All projects I am assigned to
	2=Projects where I am the account manager
	3=Only projects in my office
		
	If the ProjectOption = 0 then use the CheckAssignment option to determine what to pull back.
	If the ProjectOption = 1, 2, or 3 then the CheckAssignment should be used all the time.
	-------------------------------------------------------------------------------------------*/

	IF @CheckAssignment = 1
	BEGIN
		IF @ProjectOption = 0
		BEGIN
			SELECT *
			FROM (	
					SELECT *
					FROM vActionLog (nolock)
					WHERE CompanyKey = @SessionCompanyKey
					AND Entity <> 'Time'
					AND ActionDate BETWEEN @NewFeedDate and DATEADD(HOUR, 24, @NewFeedDate)
					AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select ProjectKey FROM tAssignment (nolock) where UserKey = @SessionUserKey))
					AND (@UserKey = -1 OR UserKey = @UserKey)
					AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
					AND     (-- case when @GLCompanyKey = ALL
								(@GLCompanyKey = -1 AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
							)
					
					UNION
					
					SELECT *
					FROM vActionLog (nolock)
					WHERE CompanyKey = @SessionCompanyKey
					AND Entity = 'Time'
					AND ActionDate = @FeedDate
					AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select ProjectKey FROM tAssignment (nolock) where UserKey = @SessionUserKey))
					AND (@UserKey = -1 OR UserKey = @UserKey)
					AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
					AND     (-- case when @GLCompanyKey = ALL
								(@GLCompanyKey = -1 AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
							)
				) AS ActionLogData
				
				Order By ActionDate DESC
				
		END
	END
	ELSE
	BEGIN
		IF @ProjectOption = 0
		BEGIN
			SELECT *
			FROM (
					SELECT *
					FROM vActionLog (nolock)
					WHERE CompanyKey = @SessionCompanyKey
					AND Entity <> 'Time'
					AND ActionDate BETWEEN @NewFeedDate and DATEADD(HOUR, 24, @NewFeedDate)
					AND (@UserKey = -1 OR UserKey = @UserKey)
					AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
					AND     (-- case when @GLCompanyKey = ALL
								(@GLCompanyKey = -1 AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
							)
							
					UNION		
					
					SELECT *
					FROM vActionLog (nolock)
					WHERE CompanyKey = @SessionCompanyKey
					AND Entity = 'Time'
					AND ActionDate = @FeedDate
					AND (@UserKey = -1 OR UserKey = @UserKey)
					AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
					AND     (-- case when @GLCompanyKey = ALL
								(@GLCompanyKey = -1 AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
							)
			) AS ActionLogData
	
			Order By ActionDate DESC
		END
	END
	IF @ProjectOption = 1
	BEGIN
		SELECT *
		FROM (
				SELECT *
				FROM vActionLog (nolock)
				WHERE CompanyKey = @SessionCompanyKey
				AND Entity <> 'Time'
				AND ActionDate BETWEEN @NewFeedDate and DATEADD(HOUR, 24, @NewFeedDate)
				AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select ProjectKey FROM tAssignment (nolock) where UserKey = @SessionUserKey))
				AND (@UserKey = -1 OR vActionLog.UserKey = @UserKey)
				AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
				AND     (-- case when @GLCompanyKey = ALL
							(@GLCompanyKey = -1 AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
						--case when @GLCompanyKey = X or Blank(0)
						 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
						)
						
				UNION
				
				SELECT *
				FROM vActionLog (nolock)
				WHERE CompanyKey = @SessionCompanyKey
				AND Entity = 'Time'
				AND ActionDate = @FeedDate
				AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select ProjectKey FROM tAssignment (nolock) where UserKey = @SessionUserKey))
				AND (@UserKey = -1 OR vActionLog.UserKey = @UserKey)
				AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
				AND     (-- case when @GLCompanyKey = ALL
							(@GLCompanyKey = -1 AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
						--case when @GLCompanyKey = X or Blank(0)
						 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
						)
		) AS ActionLogData
	
		Order By ActionDate DESC	

	END
	
	IF @ProjectOption = 2
	BEGIN
		SELECT *
		FROM (
				SELECT *
					FROM vActionLog (nolock)
					WHERE CompanyKey = @SessionCompanyKey
					AND Entity <> 'Time'
					AND ActionDate BETWEEN @NewFeedDate and DATEADD(HOUR, 24, @NewFeedDate)
					AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select p.ProjectKey FROM tProject p (nolock) INNER JOIN tAssignment asm (nolock) ON p.ProjectKey = asm.ProjectKey where p.AccountManager = @SessionUserKey AND asm.UserKey = @SessionUserKey))
					AND (@UserKey = -1 OR UserKey = @UserKey)
					AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
					AND (@GLCompanyKey = -1 OR GLCompanyKey = @GLCompanyKey)
					AND     (-- case when @GLCompanyKey = ALL
								(@GLCompanyKey = -1 AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
							)
					
				UNION
				
				SELECT *
					FROM vActionLog (nolock)
					WHERE CompanyKey = @SessionCompanyKey
					AND Entity = 'Time'
					AND ActionDate = @FeedDate
					AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select p.ProjectKey FROM tProject p (nolock) INNER JOIN tAssignment asm (nolock) ON p.ProjectKey = asm.ProjectKey where p.AccountManager = @SessionUserKey AND asm.UserKey = @SessionUserKey))
					AND (@UserKey = -1 OR UserKey = @UserKey)
					AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
					AND (@GLCompanyKey = -1 OR GLCompanyKey = @GLCompanyKey)
					AND     (-- case when @GLCompanyKey = ALL
								(@GLCompanyKey = -1 AND 
									(
									@RestrictToGLCompany = 0 OR 
									(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
									)
								)
							--case when @GLCompanyKey = X or Blank(0)
							 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
							)
			) AS ActionLogData		
						
			Order By ActionDate DESC
	END

	IF @ProjectOption = 3
	BEGIN
		SELECT *
		FROM (
				SELECT *
				FROM vActionLog (nolock)
				WHERE CompanyKey = @SessionCompanyKey
				AND Entity <> 'Time'
				AND ActionDate BETWEEN @NewFeedDate and DATEADD(HOUR, 24, @NewFeedDate)
				AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select p.ProjectKey FROM tProject p(nolock) INNER JOIN tAssignment asm (nolock) ON p.ProjectKey = asm.ProjectKey where p.OfficeKey = @SessionUserOfficeKey AND asm.UserKey = @SessionUserKey ))
				AND (@UserKey = -1 OR UserKey = @UserKey)
				AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
				AND (@GLCompanyKey = -1 OR GLCompanyKey = @GLCompanyKey)
				AND     (-- case when @GLCompanyKey = ALL
							(@GLCompanyKey = -1 AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
						--case when @GLCompanyKey = X or Blank(0)
						 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
						)
						
				UNION
						
				SELECT *
				FROM vActionLog (nolock)
				WHERE CompanyKey = @SessionCompanyKey
				AND Entity = 'Time'
				AND ActionDate = @FeedDate
				AND (ISNULL(vActionLog.ProjectKey, 0) = 0 OR ProjectKey in (Select p.ProjectKey FROM tProject p(nolock) INNER JOIN tAssignment asm (nolock) ON p.ProjectKey = asm.ProjectKey where p.OfficeKey = @SessionUserOfficeKey AND asm.UserKey = @SessionUserKey ))
				AND (@UserKey = -1 OR UserKey = @UserKey)
				AND (@DepartmentKey = -1 OR DepartmentKey = @DepartmentKey)
				AND (@GLCompanyKey = -1 OR GLCompanyKey = @GLCompanyKey)
				AND     (-- case when @GLCompanyKey = ALL
							(@GLCompanyKey = -1 AND 
								(
								@RestrictToGLCompany = 0 OR 
								(@RestrictToGLCompany = 1 AND vActionLog.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
								)
							)
						--case when @GLCompanyKey = X or Blank(0)
						 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
						)
		) AS ActionLogData	
	
		Order By ActionDate DESC
	END
GO
