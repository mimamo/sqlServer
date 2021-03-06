USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutBillingInsertNewWorkType]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutBillingInsertNewWorkType]
	@WorkTypeKey int
AS

/*
|| When      Who Rel      What
|| 5/6/11    CRG 10.5.4.4 (110628) Created to default new billing items into the tLayoutBilling table
*/

	DECLARE	@CompanyKey int,
			@ParentEntityKey int,
			@ParentEntity varchar(50)
			
	SELECT	@CompanyKey = CompanyKey
	FROM	tWorkType (nolock)
	WHERE	WorkTypeKey = @WorkTypeKey

	SELECT	@ParentEntityKey = 0,
			@ParentEntity = 'tProject'
	
	DECLARE @LayoutKey int
	SELECT	@LayoutKey = 0

	DECLARE	@DisplayOrder int,
			@LayoutOrder int

	WHILE(1=1)
	BEGIN
		SELECT	@LayoutKey = MIN(LayoutKey)
		FROM	tLayout (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		LayoutKey > @LayoutKey

		IF @LayoutKey IS NULL
			BREAK
		
		SELECT	@DisplayOrder = MAX(DisplayOrder)
		FROM	tLayoutBilling (nolock)
		WHERE	LayoutKey = @LayoutKey
		AND		ParentEntity = @ParentEntity
		AND		ParentEntityKey = @ParentEntityKey

		SELECT	@DisplayOrder = ISNULL(@DisplayOrder, 0)

		IF @DisplayOrder = 0
			SELECT	@LayoutOrder = LayoutOrder
			FROM	tLayoutBilling (nolock)
			WHERE	LayoutKey = @LayoutKey
			AND		Entity = @ParentEntity
			AND		EntityKey = @ParentEntityKey
		ELSE
			SELECT	@LayoutOrder = LayoutOrder
			FROM	tLayoutBilling (nolock)
			WHERE	LayoutKey = @LayoutKey
			AND		ParentEntity = @ParentEntity
			AND		ParentEntityKey = @ParentEntityKey
			AND		DisplayOrder = @DisplayOrder

		SELECT @LayoutOrder = ISNULL(@LayoutOrder, 0)

		BEGIN TRAN

		--Slide down the ones below to make room for this new one
		UPDATE	tLayoutBilling
		SET		LayoutOrder = LayoutOrder + 1
		WHERE	LayoutKey = @LayoutKey
		AND		LayoutOrder > @LayoutOrder

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END

		INSERT	tLayoutBilling
				(LayoutKey,
				Entity,
				EntityKey,
				ParentEntity,
				ParentEntityKey,
				DisplayOption,
				DisplayOrder,
				LayoutOrder,
				LayoutLevel)
		VALUES	(@LayoutKey,
				'tWorkType',
				@WorkTypeKey,
				@ParentEntity,
				@ParentEntityKey,
				2, --DisplayOption
				@DisplayOrder + 1,
				@LayoutOrder + 1,
				1)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END

		COMMIT TRAN
		
	END

	RETURN 1
GO
