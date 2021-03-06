USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeUpdate]

	(
		@TimeKey uniqueidentifier,
		@ProjectKey int,
		@TaskKey int,
		@ServiceKey int,
		@RateLevel smallint,
		@ActualRate money,
		@Mode smallint = 1, -- 1 Loop, 2 edit popup
		@Comments varchar(2000) = NULL
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/15/07 GHL 8.4   Added Project Rollup for mode 2  
  || 02/04/13 GHL 10.564 (167256) Validate project on task  
  || 03/12/13 GHL 10.565 (171480) Cannot have RateLevel = 0
  || 04/24/13 GHL 10.567 (167212) Added ActualHours so that we can change hours in the Transactions flex screen
  || 12/05/13 RLB 10.575 (167212) removed option to change actual hours to match old screen 
  || 12/16/14 GHL 10.587 (239382) In a loop mode, do not update comments if comments = null   
  ||                              In a single use mode, update comments even if comments = null, we need ability to blank
  || 03/10/15 GHL 10.590 Added update of DepartmentKey for Abelson Taylor   
  */

 if isnull(@RateLevel, 0) = 0
	Select @RateLevel = 1

Declare @OldProjectKey int
Declare @OldServiceKey int
Declare @OldDepartmentKey int
Declare @DepartmentKey int
Declare @UserKey int

if @TaskKey > 0
begin
	if exists (select 1 from tTask (nolock)
				where TaskKey = @TaskKey
				and   ProjectKey <> @ProjectKey)
		return -1
end


if @Mode = 1
	begin
		select @OldServiceKey = ServiceKey
		      ,@OldDepartmentKey = DepartmentKey
			  ,@UserKey = UserKey
		from   tTime (nolock)
		where TimeKey = @TimeKey 

		if isnull(@OldServiceKey, 0) = isnull(@ServiceKey, 0)
			-- if the service has not changed and the user being the same, keep the same department
			select @DepartmentKey = @OldDepartmentKey
		else
			exec sptTimeGetDepartment @UserKey, @ServiceKey, @DepartmentKey output

		-- This is done in a Loop 
		if @Comments is not null
			Update tTime
			Set
				ProjectKey = @ProjectKey,
				TaskKey = @TaskKey,
				ServiceKey = @ServiceKey,
				RateLevel = @RateLevel,
				ActualRate = @ActualRate,
				Comments = @Comments,
				DepartmentKey = @DepartmentKey
			Where
				TimeKey = @TimeKey
		else
			Update tTime
			Set
				ProjectKey = @ProjectKey,
				TaskKey = @TaskKey,
				ServiceKey = @ServiceKey,
				RateLevel = @RateLevel,
				ActualRate = @ActualRate,
				DepartmentKey = @DepartmentKey
			Where
				TimeKey = @TimeKey
		
	end
else	
	Begin

		Select  @OldProjectKey = ISNULL(ProjectKey, 0)
				,@OldServiceKey = ServiceKey
		        ,@OldDepartmentKey = DepartmentKey
			    ,@UserKey = UserKey
		from   tTime (nolock)
		where TimeKey = @TimeKey 

		if isnull(@OldServiceKey, 0) = isnull(@ServiceKey, 0)
			-- if the service has not changed and the user being the same, keep the same department
			select @DepartmentKey = @OldDepartmentKey
		else
			exec sptTimeGetDepartment @UserKey, @ServiceKey, @DepartmentKey output

		Update tTime
		Set
			ProjectKey = @ProjectKey,
			TaskKey = @TaskKey,
			ServiceKey = @ServiceKey,
			RateLevel = @RateLevel,
			ActualRate = @ActualRate,
			Comments = @Comments,
			DepartmentKey = @DepartmentKey
		Where
			TimeKey = @TimeKey

		-- Safer to rollup everything for the labor trantype and this project
		EXEC sptProjectRollupUpdate @ProjectKey, 1, 1, 1, 1, 1
		
		IF @OldProjectKey <> @ProjectKey
			 EXEC sptProjectRollupUpdate @OldProjectKey, 1, 1, 1, 1, 1
	End 

	return 1
GO
