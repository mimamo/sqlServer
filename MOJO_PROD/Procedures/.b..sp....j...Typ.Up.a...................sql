USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeUpdate]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeUpdate]
	@ProjectTypeKey int,
	@CompanyKey int,
	@ProjectTypeName varchar(100),
	@Description varchar(500),
	@Subject1 varchar(200),
	@Subject2 varchar(200),
	@Subject3 varchar(200),
	@Subject4 varchar(200),
	@Subject5 varchar(200),
	@Subject6 varchar(200),
	@Subject7 varchar(200),
	@Subject8 varchar(200),
	@Subject9 varchar(200),
	@Subject10 varchar(200),
	@Subject11 varchar(200),
	@Subject12 varchar(200),
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int,
	@Active tinyint


AS --Encrypt
/*
  || When		Who Rel			What
  || 09/29/09	MAS 10.5.0.9	Added insert logic
*/

IF @ProjectTypeKey <= 0 
	BEGIN
		INSERT tProjectType
			(
			CompanyKey,
			ProjectTypeName,
			Description,
			Subject1,
			Subject2,
			Subject3,
			Subject4,
			Subject5,
			Subject6,
			Subject7,
			Subject8,
			Subject9,
			Subject10,
			Subject11,
			Subject12,
			ProjectNumPrefix,
			NextProjectNum		
			)

		VALUES
			(
			@CompanyKey,
			@ProjectTypeName,
			@Description,
			@Subject1,
			@Subject2,
			@Subject3,
			@Subject4,
			@Subject5,
			@Subject6,
			@Subject7,
			@Subject8,
			@Subject9,
			@Subject10,
			@Subject11,
			@Subject12,
			@ProjectNumPrefix,
			@NextProjectNum		
			)
		RETURN @@IDENTITY
	END
ELSE
	BEGIN	
		UPDATE
			tProjectType
		SET
			CompanyKey = @CompanyKey,
			ProjectTypeName = @ProjectTypeName,
			Description = @Description,
			Subject1 = @Subject1,
			Subject2 = @Subject2,
			Subject3 = @Subject3,
			Subject4 = @Subject4,
			Subject5 = @Subject5,
			Subject6 = @Subject6,
			Subject7 = @Subject7,
			Subject8 = @Subject8,
			Subject9 = @Subject9,
			Subject10 = @Subject10,
			Subject11 = @Subject11,
			Subject12 = @Subject12,
			ProjectNumPrefix = @ProjectNumPrefix,
			NextProjectNum = @NextProjectNum,
			Active = @Active
		WHERE
			ProjectTypeKey = @ProjectTypeKey 

		RETURN @ProjectTypeKey
END
GO
