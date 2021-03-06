USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserAssignToAllProjects]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserAssignToAllProjects]

	(
		@UserKey int
		,@Active int = 1	-- 1 Active, 0 Inactive, -1 All
		,@SpecificClientKey int = 0
		,@SpecificStatusKey int = 0
		,@ProjectTypeKey int = 0
		,@SameAsPersonKey int = 0
		,@ReplacePerson int = 0
	)

AS --Encrypt

/*
|| When      Who Rel		What
|| 10/24/09  MAS 10.5.1.3   Added additonal options for WMJ to assign to specific Client, Project or "Same As person"
|| 05/04/10  MAS 10.5.2.1   (79102)Fixed two issues;  Added "and tAssignment.UserKey <> @UserKey" to the tAssignment Join 
							replaced @ReplacePerson with @SameAsPersonKey in the spProjectReassignUser call
|| 12/1/10   RLB 10.5.3.9   (94833) Just adding default service for new user on projects
|| 02/6/12   RLB 10.5.6.5   (167736) Added by project type to list
*/

Declare @CompanyKey int, @Rate money, @DefaultServiceKey int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @Rate = HourlyRate, @DefaultServiceKey = DefaultServiceKey 
From tUser (nolock)
Where UserKey = @UserKey

if @ReplacePerson = 0 
	Begin
		if @DefaultServiceKey IS NOT NULL
				BEGIN
					Insert	tProjectUserServices (ProjectKey, UserKey, ServiceKey)
					Select ProjectKey, @UserKey, @DefaultServiceKey
					 From 
						(select	DISTINCT tProject.ProjectKey
							from	tProject (NOLOCK)
							Left Outer Join tAssignment (Nolock) on tProject.ProjectKey = tAssignment.ProjectKey
							Where	tProject.CompanyKey = @CompanyKey
							And tProject.ProjectKey NOT IN ( Select DISTINCT tProject.ProjectKey
							  from tProject (NOLOCK)
							  Join tAssignment (NOLOCK) on tAssignment.ProjectKey = tProject.ProjectKey And tAssignment.UserKey = @UserKey
							  Where CompanyKey = @CompanyKey )
							And	((@Active = 1 And tProject.Active = 1) Or (@Active = 0 And tProject.Active = 0) 
								Or (@Active = -1))
							And ( ISNULL(@SpecificClientKey,0) > 0 and tProject.ClientKey = ISNULL(@SpecificClientKey,0) 
								or (ISNULL(@SpecificClientKey,0) = 0 ))
							And ( ISNULL(@SpecificStatusKey,0) > 0 and tProject.ProjectStatusKey = ISNULL(@SpecificStatusKey,0) 
								or (ISNULL(@SpecificStatusKey,0) = 0 ))	
							And ( ISNULL(@ProjectTypeKey,0) > 0 and tProject.ProjectTypeKey = ISNULL(@ProjectTypeKey,0) 
								or (ISNULL(@ProjectTypeKey,0) = 0 ))	
							And ( ISNULL(@SameAsPersonKey,0) > 0 and tAssignment.UserKey = ISNULL(@SameAsPersonKey,0)
								or (ISNULL(@SameAsPersonKey,0) = 0  ))
						) as tAs2
				END

		Insert	tAssignment (ProjectKey, UserKey, HourlyRate)
		Select ProjectKey, @UserKey, @Rate
		 From 
			(select	DISTINCT tProject.ProjectKey
				from	tProject (NOLOCK)
				Left Outer Join tAssignment (Nolock) on tProject.ProjectKey = tAssignment.ProjectKey
				Where	tProject.CompanyKey = @CompanyKey
				And tProject.ProjectKey NOT IN ( Select DISTINCT tProject.ProjectKey
				  from tProject (NOLOCK)
				  Join tAssignment (NOLOCK) on tAssignment.ProjectKey = tProject.ProjectKey And tAssignment.UserKey = @UserKey
				  Where CompanyKey = @CompanyKey )
				And	((@Active = 1 And tProject.Active = 1) Or (@Active = 0 And tProject.Active = 0) 
					Or (@Active = -1))
				And ( ISNULL(@SpecificClientKey,0) > 0 and tProject.ClientKey = ISNULL(@SpecificClientKey,0) 
					or (ISNULL(@SpecificClientKey,0) = 0 ))
				And ( ISNULL(@SpecificStatusKey,0) > 0 and tProject.ProjectStatusKey = ISNULL(@SpecificStatusKey,0) 
					or (ISNULL(@SpecificStatusKey,0) = 0 ))
				And ( ISNULL(@ProjectTypeKey,0) > 0 and tProject.ProjectTypeKey = ISNULL(@ProjectTypeKey,0) 
								or (ISNULL(@ProjectTypeKey,0) = 0 ))		
				And ( ISNULL(@SameAsPersonKey,0) > 0 and tAssignment.UserKey = ISNULL(@SameAsPersonKey,0)
					or (ISNULL(@SameAsPersonKey,0) = 0  ))
			) as tAs

			
	End
    
Else
	Begin
	-- Replace @SameAsPersonKey records with @UserKey and @Rate
	Declare @CurKey int, @RetVal int
				 
		Select @CurKey = -1
			While 1=1
			begin
				Select @CurKey = Min(ProjectKey) from tProject (NOLOCK) Where ProjectKey > @CurKey and tProject.CompanyKey = @CompanyKey and tProject.Active = 1
				if @CurKey is null
					Break

				--             spProjectReassignUser ProjectKey, OldUserKey, NewUserKey
				exec @RetVal = spProjectReassignUser @CurKey, @SameAsPersonKey, @UserKey
				if @RetVal = -1
					return @CurKey
			end

		return 0	
	End
GO
