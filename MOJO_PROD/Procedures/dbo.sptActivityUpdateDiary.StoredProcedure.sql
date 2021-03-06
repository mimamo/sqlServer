USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateDiary]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateDiary]
	@ActivityKey int,
	@CompanyKey int,
	@UserKey int,
	@ProjectKey int,
	@TaskKey int,
	@ActivityTypeKey int,
	@VisibleToClient int,
	@Subject varchar(2000),
	@Notes text,
	@RootActivityKey int
AS

/*
|| When      Who Rel      What
|| 12/9/10   CRG 10.5.3.9 Created to update To Dos
|| 12/15/10  GHL 10.5.3.9 Cloned this sp for Diary
|| 12/16/10  GHL 10.5.3.9 Added update of UpdatedByKey on insert 
|| 12/29/10  GHL 10.5.3.9 Added pushing down of VisibleToClient + some other fields to the whole thread 
|| 01/17/11  GHL 10.5.4.0 Added update of DateUpdated
|| 06/01/11  GHL 10.5.4.5 (112280) Added logic for saving links
|| 06/13/11  GHL 10.5.4.5 (114211) Should be able to handle all types of links
|| 02/20/12  GWG 10.5.5.3 Modified the addition of diary entries to insert them as completed
|| 06/22/12  GHL 10.5.5.7 Added GL company update
|| 07/23/12  GHL 10.5.5.8 Only pull GL company if we restrict to gl company
|| 10/2/12   CRG 10.5.6.0 Added WebDavPath and WebDavFileName to the Link inserts
|| 03/04/14  RLB 10.5.7.8 Adding task link if their is a task key passed in since we are allowing Tasks on diary
|| 03/03/14 GWG 10.5.7.8 Added support for clearing the read flag
*/

	/*
	Assume done in VB
	create table #links(Entity varchar(50) null, EntityKey int null, UpdateFlag int null, WebDavPath varchar(2000) NULL, WebDavFileName varchar(500) NULL) 	
	*/

	DECLARE @ActivityDate DATETIME
	DECLARE	@OldTaskKey int
	DECLARE @GLCompanyKey int
	DECLARE @RestrictToGLCompany int

	SELECT @ActivityDate = convert(datetime, convert(varchar(10), getdate(), 101), 101)
	SELECT	@OldTaskKey = 0

	select @TaskKey = isnull(@TaskKey,0) 

	select @RestrictToGLCompany = RestrictToGLCompany from tPreference (nolock) where CompanyKey = @CompanyKey

	IF ISNULL(@ActivityKey, 0) = 0
	BEGIN
		-- New Diary Post

		-- only if we restrict
		if isnull(@RestrictToGLCompany, 0) = 1
		begin
			select @GLCompanyKey = GLCompanyKey from tProject (nolock) where ProjectKey = @ProjectKey

			if isnull(@GLCompanyKey, 0) = 0
				select @GLCompanyKey = GLCompanyKey from tUser (nolock) where UserKey = @UserKey

			if @GLCompanyKey = 0
				select @GLCompanyKey = null
		end

		INSERT	tActivity
				(ActivityEntity,
				CompanyKey,
				ProjectKey,
				TaskKey,
				Subject,
				Notes,
				VisibleToClient,
				ActivityTypeKey,
				ActivityDate,
				Completed,
				DateCompleted,
				AddedByKey,
				UpdatedByKey,
				OriginatorUserKey,
				RootActivityKey,
				GLCompanyKey
				)
		VALUES	('Diary',
		        @CompanyKey,
				@ProjectKey,
				@TaskKey,
				@Subject,
				@Notes,
				@VisibleToClient,
				@ActivityTypeKey,
				@ActivityDate,
				1,
				@ActivityDate,
				@UserKey,
				@UserKey,
				@UserKey,
				@RootActivityKey,
				@GLCompanyKey
				)

		SELECT	@ActivityKey = @@IDENTITY

		IF @RootActivityKey = 0
			UPDATE	tActivity 
			SET		RootActivityKey = @ActivityKey 
			WHERE	ActivityKey = @ActivityKey

		
		if not exists (select 1 from #links where Entity = 'tProject' and EntityKey = @ProjectKey)
		insert #links (Entity, EntityKey)
		select 'tProject', @ProjectKey

		if @TaskKey > 0
		begin
			if not exists (select 1 from #links where Entity = 'tTask' and EntityKey = @TaskKey)
			insert #links (Entity, EntityKey)
			select 'tTask', @TaskKey

		end
		 
		insert tActivityLink (ActivityKey, Entity, EntityKey, WebDavPath, WebDavFileName) 
		select @ActivityKey, Entity, EntityKey, WebDavPath, WebDavFileName
		from   #links

	END
	ELSE
	BEGIN
		-- Existing Diary Post

		SELECT	@OldTaskKey = TaskKey
		FROM	tActivity (nolock)
		WHERE	ActivityKey = @ActivityKey

		select @OldTaskKey = isnull(@OldTaskKey, 0)

		UPDATE	tActivity
		SET		ActivityEntity = 'Diary', --just to make sure
				ProjectKey = @ProjectKey,
				TaskKey = @TaskKey,
				Subject = @Subject,
				Notes = @Notes,
				VisibleToClient=@VisibleToClient,
				ActivityTypeKey=@ActivityTypeKey,
				UpdatedByKey=@UserKey,
				DateUpdated=GetUTCDate()
		WHERE	ActivityKey = @ActivityKey

		-- Links
		if not exists (select 1 from #links where Entity = 'tProject' and EntityKey = @ProjectKey)
		insert #links (Entity, EntityKey)
		select 'tProject', @ProjectKey
		
		if @TaskKey > 0
		begin
			if not exists (select 1 from #links where Entity = 'tTask' and EntityKey = @TaskKey)
			insert #links (Entity, EntityKey)
			select 'tTask', @TaskKey

		end

		-- delete them all here
		delete tActivityLink 
		where  ActivityKey in (select ActivityKey from tActivity (nolock) 
				where RootActivityKey = @ActivityKey 
				and   RootActivityKey <> 0
				)  
				
		-- cartesian product here
		insert tActivityLink (ActivityKey, Entity, EntityKey, WebDavPath, WebDavFileName) 
		select a.ActivityKey, Entity, EntityKey, WebDavPath, WebDavFileName
		from   #links
		      ,tActivity a (nolock)
		where a.RootActivityKey = @ActivityKey
	
  
		-- Push down VisibleToClient and other fields to the whole thread

		update tActivity
		set    VisibleToClient = @VisibleToClient
		       ,Subject = @Subject
			   ,ActivityTypeKey=@ActivityTypeKey
		where  RootActivityKey = @ActivityKey
		and    ActivityKey <> @ActivityKey


		-- if TaskKey changed update all the taskkeys on the replies

		If @TaskKey <> @OldTaskKey
			update tActivity 
			set TaskKey = @TaskKey 
			where  RootActivityKey = @ActivityKey
			and    ActivityKey <> @ActivityKey


		--Clear any read flags
		exec sptAppReadClearRead @UserKey, 'tActivity', @ActivityKey
		
	END



	RETURN @ActivityKey
GO
