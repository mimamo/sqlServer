USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityLinkUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityLinkUpdate]

	(
		@ActivityKey int,
		@Entity varchar(50),
		@EntityKey int,
		@Action varchar(10),
		@WebDavPath varchar(2000) = NULL,
		@WebDavFileName varchar(500) = NULL
	)

AS

/*
|| When      Who Rel      What
|| 10/2/12   CRG 10.5.6.0 (154738) Added WebDavPath and WebDavFileName
|| 01/31/12  RLB 10.5.6.4 (166825) If adding Project link and the Activity is not a dairy make it one so it displays on the diary
*/

DECLARE @ActivityEntity varchar(50)

if @Action = 'insert'
BEGIN
	if not exists(Select 1 from tActivityLink (nolock) Where ActivityKey = @ActivityKey and Entity = @Entity and EntityKey = @EntityKey)

	INSERT tActivityLink
		(
		ActivityKey,
		Entity,
		EntityKey,
		WebDavPath,
		WebDavFileName
		)

	VALUES
		(
		@ActivityKey,
		@Entity,
		@EntityKey,
		@WebDavPath,
		@WebDavFileName
		)


	IF @Entity = 'tProject'
	BEGIN
		SELECT @ActivityEntity = ActivityEntity FROM tActivity (NOLOCK) WHERE ActivityKey = @ActivityKey

		IF @ActivityEntity = 'Activity'
			UPDATE tActivity SET ActivityEntity = 'Diary' WHERE ActivityKey = @ActivityKey
	END
END

if @Action = 'delete'
BEGIN
	DELETE
	FROM tActivityLink
	WHERE
		ActivityKey = @ActivityKey 
		AND Entity = @Entity 
		AND EntityKey = @EntityKey 


END
GO
