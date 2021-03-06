USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityMoveToFromToDo]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityMoveToFromToDo]
	(
	@ActivityKey int
	)
AS
	SET NOCOUNT ON

/*
|| When      Who Rel      What
|| 05/07/12  GHL 10.556   Convert an Activity to a ToDo and vice versa 
|| 10/31/14  GAR 10.585   (234763) If a to do item is moved from a task to the diary, we need to link it to the project so
||						  it shows up in the diary.  Right now it is only linking as a tTask which doesn't get seen.
||                        
*/

	declare @ActivityEntity varchar(50) 
	declare @NewActivityEntity varchar(50) 
	declare @RootActivityKey int

	select @ActivityEntity = ActivityEntity
	      ,@RootActivityKey = RootActivityKey
	from   tActivity (nolock)
	where  ActivityKey = @ActivityKey

	if @ActivityEntity = 'Diary'
		select @NewActivityEntity = 'ToDo'
	else if @ActivityEntity = 'ToDo'
		select @NewActivityEntity = 'Diary'
	
	if @NewActivityEntity is not null
	begin
		update tActivity
		set    ActivityEntity = @NewActivityEntity
			  ,TaskKey = case when TaskKey = 0 then null else TaskKey end -- cleanup of all diary activities
		where  RootActivityKey = @RootActivityKey 
		
		if @NewActivityEntity = 'Diary'
		begin
			insert into tActivityLink (ActivityKey, Entity, EntityKey)
			
		    -- This will pull all tActivity entries under a root activity key that do not exist as tProject entity links in tActivityLink.
			select a.ActivityKey, 'tProject', a.ProjectKey 
			from tActivity a (nolock)
				left outer join tActivityLink al (nolock) ON a.ActivityKey = al.ActivityKey and al.Entity = 'tProject'
				where RootActivityKey = @RootActivityKey and al.ActivityKey is null
		end
	end


	RETURN 1
GO
