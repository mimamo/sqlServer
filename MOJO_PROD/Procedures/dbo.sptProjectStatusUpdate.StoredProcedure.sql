USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectStatusUpdate]
	@ProjectStatusKey int,
	@CompanyKey int,
	@ProjectStatusID varchar(30),
	@ProjectStatus varchar(200),
	@DisplayOrder int,
	@StatusCategory smallint,
	@IsActive tinyint,
	@TimeActive tinyint,
	@ExpenseActive tinyint,
	@Locked tinyint,
	@OnHold tinyint,
	@IncludeInForecast tinyint

AS --Encrypt
  /*
  || When     Who Rel      What
  || 08/26/09 MAS 10.5.0.8 Added insert logic
  || 9/5/12   CRG 10.5.6.0 Added IncludeInForecast
  */
  
If @ProjectStatusKey <= 0
	BEGIN
		INSERT tProjectStatus
		(
		CompanyKey,
		ProjectStatusID,
		ProjectStatus,
		DisplayOrder,
		StatusCategory,
		IsActive,
		TimeActive,
		ExpenseActive,
		Locked,
		OnHold,
		IncludeInForecast
		)

		VALUES
		(
		@CompanyKey,
		@ProjectStatusID,
		@ProjectStatus,
		@DisplayOrder,
		@StatusCategory,
		@IsActive,
		@TimeActive,
		@ExpenseActive,
		@Locked,
		@OnHold,
		@IncludeInForecast
		)
					
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		IF EXISTS(
			SELECT 1
			FROM tProjectStatus (NOLOCK) 
			WHERE 
				ProjectStatusID = @ProjectStatusID AND
				CompanyKey = @CompanyKey AND
				ProjectStatusKey <> @ProjectStatusKey
		)

		RETURN -1
		
		UPDATE
			tProjectStatus
		SET
			CompanyKey = @CompanyKey,
			ProjectStatusID = @ProjectStatusID,
			ProjectStatus = @ProjectStatus,
			DisplayOrder = @DisplayOrder,
			StatusCategory = @StatusCategory,
			IsActive = @IsActive,
			TimeActive = @TimeActive,
			ExpenseActive = @ExpenseActive,
			Locked = @Locked,
			OnHold = @OnHold,
			IncludeInForecast = @IncludeInForecast
		WHERE
			ProjectStatusKey = @ProjectStatusKey 
		
		UPDATE
			tProject
		SET
			Active = @IsActive
		WHERE
			ProjectStatusKey = @ProjectStatusKey

		RETURN @ProjectStatusKey
	END

RETURN 1
GO
