USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutBillingInsertNewItem]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutBillingInsertNewItem]
	@Entity varchar(50),
	@EntityKey int
AS

/*
|| When      Who Rel      What
|| 5/5/11    CRG 10.5.4.4 (110628) Created to default new items into the tLayoutBilling table
|| 9/19/11   CRG 10.5.4.8 (121294) Modified to handle both Items and Services. Since this SP was only called in one place, I decided it was better to just change the parms.
*/

	DECLARE	@CompanyKey int,
			@WorkTypeKey int,
			@ParentEntityKey int,
			@ParentEntity varchar(50),
			@LayoutLevel smallint

	IF @Entity = 'tItem'
		SELECT	@CompanyKey = CompanyKey,
				@WorkTypeKey = WorkTypeKey
		FROM	tItem (nolock)
		WHERE	ItemKey = @EntityKey
	ELSE
		SELECT	@CompanyKey = CompanyKey,
				@WorkTypeKey = WorkTypeKey
		FROM	tService (nolock)
		WHERE	ServiceKey = @EntityKey

	IF ISNULL(@WorkTypeKey, 0) = 0
		SELECT	@ParentEntityKey = 0,
				@ParentEntity = 'tProject',
				@LayoutLevel = 1
	ELSE
		SELECT	@ParentEntityKey = @WorkTypeKey,
				@ParentEntity = 'tWorkType',
				@LayoutLevel = 2
	
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

		IF @LayoutOrder = 0
		BEGIN
			--We need to just put it at the bottom then
			--Change the Parent to the "Project" level and get the order values again
			SELECT	@ParentEntityKey = 0,
					@ParentEntity = 'tProject'

			SELECT	@DisplayOrder = MAX(DisplayOrder)
			FROM	tLayoutBilling (nolock)
			WHERE	LayoutKey = @LayoutKey
			AND		ParentEntity = @ParentEntity
			AND		ParentEntityKey = @ParentEntityKey

			SELECT	@DisplayOrder = ISNULL(@DisplayOrder, 0)

			SELECT	@LayoutOrder = LayoutOrder
			FROM	tLayoutBilling (nolock)
			WHERE	LayoutKey = @LayoutKey
			AND		ParentEntity = @ParentEntity
			AND		ParentEntityKey = @ParentEntityKey
			AND		DisplayOrder = @DisplayOrder

			SELECT @LayoutOrder = ISNULL(@LayoutOrder, 0)
		END

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
				@Entity,
				@EntityKey,
				@ParentEntity,
				@ParentEntityKey,
				1, --DisplayOption
				@DisplayOrder + 1,
				@LayoutOrder + 1,
				@LayoutLevel)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END

		COMMIT TRAN
		
	END

	RETURN 1
GO
