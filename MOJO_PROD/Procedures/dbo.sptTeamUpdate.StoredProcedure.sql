USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTeamUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTeamUpdate]
	@TeamKey int,
	@CompanyKey int,
	@TeamName varchar(200),
	@Active tinyint

AS -- Encrypt
/*  
|| When      Who Rel       What  
|| 09/14/09  MAS 10.5.0.9  Added insert logic
*/

IF @TeamKey <= 0 
	BEGIN
		if exists(select 1 from tTeam (nolock)
			Where CompanyKey = @CompanyKey
			and rtrim(ltrim(lower(TeamName))) = rtrim(ltrim(lower(@TeamName))) )
		Return -1
	
		IF @Active IS NULL
			SELECT @Active = 1

		INSERT tTeam
			(
			CompanyKey,
			TeamName,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@TeamName,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE	
	BEGIN	
		if exists(select 1 from tTeam (nolock)
		Where CompanyKey = @CompanyKey
		and rtrim(ltrim(lower(TeamName))) = rtrim(ltrim(lower(@TeamName)))
		and TeamKey <> @TeamKey )
		Return -1
		
		UPDATE
			tTeam
		SET
			CompanyKey = @CompanyKey,
			TeamName = @TeamName,
			Active = @Active
		WHERE
			TeamKey = @TeamKey 

		RETURN @TeamKey
	END
GO
