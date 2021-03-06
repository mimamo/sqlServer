USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityDeleteForEntity]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityDeleteForEntity]
	(
	@ActivityKey int,
	@Entity varchar(50),
	@EntityKey int,
	@UserKey int,
	@CanDelete tinyint,
	@CanEditOthers tinyint
	)

AS

-- First just delete the link

Delete tActivityLink Where ActivityKey = @ActivityKey and Entity = @Entity and EntityKey = @EntityKey
Declare @AssignedKey int, @OriginatorKey int
-- Figure out if we even need to delete

declare @rowcount as int
Select @rowcount = count(*) from tActivityLink (nolock) Where ActivityKey = @ActivityKey

	-- if any links exists, leave
	if @rowcount > 0 
		return -1
	
	if @CanDelete = 0
		return -1

	if @CanEditOthers = 0
	-- if you can only edit your activities, then check if you are the owner or assigned person
		if not exists(Select 1 from tActivity (nolock) Where AssignedUserKey = @UserKey or OriginatorUserKey = @UserKey and ActivityKey = @ActivityKey)
			return -1
			
			
	Delete tActivity Where ActivityKey = @ActivityKey
	Delete tActivityEmail Where ActivityKey = @ActivityKey
	
	
	return 1
GO
