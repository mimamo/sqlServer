USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityEmailUpdateFromDiary]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityEmailUpdateFromDiary]
	@ActivityKey int
AS

/*
|| When      Who Rel      What
|| 12/13/10  CRG 10.5.3.9 Created for new ToDo screen
|| 02/21/11  GHL 10.5.4.1 Cloned for Diary, added check for visible to client flag
|| 2/22/11   CRG 10.5.4.1 Replaced RETURN with BREAK in the two loops below...my mistake
|| 10/23/12  RLB 10.5.6.1 Only update the parent email to list because clients want to track who the email was sent to per reply
*/

	/* Assume crerated in VB
	CREATE TABLE #UserKeys (UserKey int NULL, IsClient int null)
	*/

	declare @VisibleToClient int

	select @VisibleToClient = VisibleToClient
	from   tActivity (nolock)
	where  ActivityKey = @ActivityKey

	select @VisibleToClient = isnull(@VisibleToClient, 0)
	if @VisibleToClient = 0
	begin
		update #UserKeys
		set    #UserKeys.IsClient = isnull(u.ClientVendorLogin, 0)
		from   tUser u (nolock)
		where  #UserKeys.UserKey = u.UserKey

		delete #UserKeys where isnull(IsClient, 0) = 1
	end


	--Get a list of all activities for this root (all child activities will get the same Email To list as the root)
	-- Only update the parent email to list because clients want to track who the email was sent to per reply
	SELECT	ActivityKey
	INTO	#ActivityKeys
	FROM	tActivity (nolock)
	WHERE	ActivityKey = @ActivityKey

	DELETE	tActivityEmail
	WHERE	ActivityKey IN (SELECT ActivityKey FROM #ActivityKeys)
	AND		UserKey NOT IN (SELECT UserKey FROM #UserKeys)
	AND		UserLeadKey IS NULL --Just in case there's a link to a Lead
	
	DECLARE	@LoopActivityKey int,
			@LoopUserKey int
	
	SELECT	@LoopActivityKey = 0

	WHILE (1=1)
	BEGIN
		SELECT	@LoopActivityKey = MIN(ActivityKey)
		FROM	#ActivityKeys
		WHERE	ActivityKey > @LoopActivityKey

		IF @LoopActivityKey IS NULL
			BREAK

		SELECT	@LoopUserKey = 0
	
		WHILE (1=1)
		BEGIN
			SELECT	@LoopUserKey = MIN(UserKey)
			FROM	#UserKeys
			WHERE	UserKey > @LoopUserKey

			IF @LoopUserKey IS NULL
				BREAK

			EXEC sptActivityEmailUpdate @LoopActivityKey, @LoopUserKey, null, 'insert'
		END	
	END
GO
