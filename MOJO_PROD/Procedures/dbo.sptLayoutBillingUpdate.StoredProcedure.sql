USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutBillingUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutBillingUpdate]
	@LayoutKey int,
	@Entity varchar(50),
	@EntityKey int,
	@ParentEntity varchar(50),
	@ParentEntityKey int,
	@DisplayOption smallint,
	@DisplayOrder int,
	@LayoutOrder int,
	@LayoutLevel smallint
AS

/*
|| When      Who Rel      What
|| 1/4/10    CRG 10.5.1.6 Created
*/

	IF EXISTS(
			SELECT	NULL
			FROM	tLayoutBilling (nolock)
			WHERE	LayoutKey = @LayoutKey
			AND		Entity = @Entity
			AND		EntityKey = @EntityKey)
		UPDATE	tLayoutBilling
		SET		ParentEntity = @ParentEntity,
				ParentEntityKey = @ParentEntityKey,
				DisplayOption = @DisplayOption,
				DisplayOrder = @DisplayOrder,
				LayoutOrder = @LayoutOrder,
				LayoutLevel = @LayoutLevel
		WHERE	LayoutKey = @LayoutKey
		AND		Entity = @Entity
		AND		EntityKey = @EntityKey
	ELSE
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
				@DisplayOption,
				@DisplayOrder,
				@LayoutOrder,
				@LayoutLevel)
GO
