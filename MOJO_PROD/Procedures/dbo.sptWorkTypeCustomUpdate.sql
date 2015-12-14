USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeCustomUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeCustomUpdate]
	@Entity varchar(50),
	@EntityKey int,
	@WorkTypeKey int,
	@Subject varchar(1000),
	@Description text
AS

/*
|| When      Who Rel      What
|| 1/12/10   CRG 10.5.1.6 Created
*/

	DECLARE	@IsCustom tinyint
	
	IF EXISTS (
			SELECT	NULL
			FROM	tWorkType (nolock)
			WHERE	WorkTypeKey = @WorkTypeKey
			AND		WorkTypeName = @Subject 
			AND		ISNULL(Description, '') LIKE ISNULL(@Description, ''))
		SELECT @IsCustom = 0
	ELSE
		SELECT @IsCustom = 1

	IF EXISTS (SELECT NULL FROM tWorkTypeCustom (nolock) WHERE Entity = @Entity AND EntityKey = @EntityKey AND WorkTypeKey = @WorkTypeKey)
	BEGIN
		IF @IsCustom = 1
			UPDATE	tWorkTypeCustom
			SET		Subject = @Subject,
					Description = @Description
			WHERE	Entity = @Entity 
			AND		EntityKey = @EntityKey 
			AND		WorkTypeKey = @WorkTypeKey
		ELSE
			DELETE	tWorkTypeCustom
			WHERE	Entity = @Entity 
			AND		EntityKey = @EntityKey 
			AND		WorkTypeKey = @WorkTypeKey
	END			
	ELSE
	BEGIN
		IF @IsCustom = 1
			INSERT	tWorkTypeCustom
					(Entity,
					EntityKey,
					WorkTypeKey,
					Subject,
					Description)
			VALUES	(@Entity,
					@EntityKey,
					@WorkTypeKey,
					@Subject,
					@Description)
	END
GO
