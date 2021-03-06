USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassUpdate]
	@ClassKey int,
	@CompanyKey int,
	@ClassID varchar(50),
	@ClassName varchar(200),
	@Description varchar(1000),
	@Active tinyint,
	@OfficeKey int,
	@DepartmentKey int

AS --Encrypt
  /*
  || When     Who Rel		What
  || 10/06/09 MAS 10.5.0.1  Added insert logic
  || 11/04/11 RLB 10.5.4.3  return the new ClassKey when inserting
  */
IF @ClassKey <= 0 
BEGIN
	if exists(select 1 from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey)
	return -1

	INSERT tClass
		(
		CompanyKey,
		ClassID,
		ClassName,
		Description,
		Active,
		DepartmentKey,
		OfficeKey
		)

	VALUES
		(
		@CompanyKey,
		@ClassID,
		@ClassName,
		@Description,
		@Active,
		@DepartmentKey,
		@OfficeKey
		)
	
	RETURN @@IDENTITY
END
ELSE
	BEGIN	
		if exists(select 1 from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey and ClassKey <> @ClassKey)
		return -1

		UPDATE
			tClass
		SET
			CompanyKey = @CompanyKey,
			ClassID = @ClassID,
			ClassName = @ClassName,
			Description = @Description,
			Active = @Active,
			OfficeKey = @OfficeKey,
			DepartmentKey = @DepartmentKey
		WHERE
			ClassKey = @ClassKey 

		RETURN @ClassKey
	END
GO
