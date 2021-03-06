USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserReasignAll]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserReasignAll]
	(
		@CompanyKey int,
		@UserKey int,
		@NewUserKey int
	)
AS



Declare @CurKey int, @RetVal int


Select @CurKey = -1
While 1=1
begin
	Select @CurKey = Min(ProjectKey) from tProject (NOLOCK) Where ProjectKey > @CurKey and tProject.CompanyKey = @CompanyKey and tProject.Active = 1
	if @CurKey is null
		Break


	exec @RetVal = spProjectReassignUser @CurKey, @UserKey, @NewUserKey
	if @RetVal = -1
		return @CurKey

end

return 0
GO
