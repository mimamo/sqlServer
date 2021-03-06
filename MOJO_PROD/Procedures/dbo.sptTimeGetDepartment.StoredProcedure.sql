USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetDepartment]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetDepartment] 
	(
	@UserKey int
	,@ServiceKey int
	,@oDepartmentKey int output
	)
AS --Encrypt
BEGIN
	
  /*
  || When     Who Rel    What
  || 03/10/15 GHL 10.590 Creation for Abelson Taylor   
  ||                     We must now set the department on tTime
  ||                     This sp will get the department from the user or the service   
  */

	SET NOCOUNT ON

	declare @DepartmentKey int
	declare @DefaultDepartmentFromUser int

	select @DefaultDepartmentFromUser = pref.DefaultDepartmentFromUser 
	      ,@DepartmentKey = u.DepartmentKey
	from tUser u (nolock)
	inner join tPreference pref (nolock) on isnull(u.OwnerCompanyKey, u.CompanyKey) = pref.CompanyKey
	where u.UserKey = @UserKey
	
	if isnull(@DefaultDepartmentFromUser, 0) = 1
	begin
		if @DepartmentKey = 0
			select @DepartmentKey = null

		select @oDepartmentKey = @DepartmentKey
	end
	else
	begin
		select @DepartmentKey = DepartmentKey
		from   tService (nolock)
		where  ServiceKey = @ServiceKey

		if @DepartmentKey = 0
			select @DepartmentKey = null

		select @oDepartmentKey = @DepartmentKey
	end

	return 1

END
GO
