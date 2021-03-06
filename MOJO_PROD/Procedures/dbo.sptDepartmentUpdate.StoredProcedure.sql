USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepartmentUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepartmentUpdate]
	@DepartmentKey int,
	@CompanyKey int,
	@DepartmentName varchar(200),
	@Active tinyint

AS --Encrypt

  /*
  || When     Who Rel      What
  || 08/26/09 MAS 10.5.0.8 Added insert logic
  */

IF @DepartmentKey <= 0
	BEGIN
		INSERT tDepartment
			(
			CompanyKey,
			DepartmentName,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@DepartmentName,
			@Active
			)
		
		RETURN @@IDENTITY	
	END
ELSE
	BEGIN
		IF EXISTS (SELECT 1
		   FROM   tDepartment (NOLOCK)
		   WHERE  CompanyKey = @CompanyKey
		   AND    UPPER(LTRIM(RTRIM(DepartmentName))) = UPPER(LTRIM(RTRIM(@DepartmentName)))
					 AND    DepartmentKey <> @DepartmentKey
		   )
		   RETURN -1
		   
		UPDATE
			tDepartment
		SET
			CompanyKey = @CompanyKey,
			DepartmentName = @DepartmentName,
			Active = @Active
		WHERE
			DepartmentKey = @DepartmentKey 

		RETURN @DepartmentKey		
	END
GO
