USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityTypeUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityTypeUpdate]
	@ActivityTypeKey int,
	@CompanyKey int,
	@TypeName varchar(200),
	@Active tinyint,
	@AutoRollDate tinyint,
	@TypeColor varchar(50),
	@DefaultStatusKey int = NULL,
	@Entity varchar(50) = NULL

AS --Encrypt

/*
|| When      Who Rel      What
|| 5/7/09    CRG 10.5.0.0 Added TypeColor
|| 09/15/09	 MAS 10.5.0.9 Added insert logic
|| 04/30/15  GWG 10.5.9.2 Added Entity to allow segmenting of types
*/

IF @ActivityTypeKey <= 0 
	BEGIN
		INSERT tActivityType
			(
			CompanyKey,
			TypeName,
			Active,
			AutoRollDate,
			LastModified,
			TypeColor,
			DefaultStatusKey,
			Entity
			)

		VALUES
			(
			@CompanyKey,
			@TypeName,
			@Active,
			@AutoRollDate,
			GetDate(),
			@TypeColor,
			@DefaultStatusKey,
			@Entity
			)
		RETURN @@IDENTITY	
	END	
ELSE
	BEGIN
		UPDATE
			tActivityType
		SET
			CompanyKey = @CompanyKey,
			TypeName = @TypeName,
			Active = @Active,
			LastModified = GetDate(),
			AutoRollDate = @AutoRollDate,
			TypeColor = @TypeColor,
			DefaultStatusKey = @DefaultStatusKey,
			Entity = @Entity
		WHERE
			ActivityTypeKey = @ActivityTypeKey 

		RETURN @ActivityTypeKey

	END
GO
