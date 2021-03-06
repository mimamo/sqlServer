USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormInsert]
	@FormDefKey int,
	@CompanyKey int,
	@ProjectKey int,
	@TaskKey int,
	@Author int,
	@AssignedTo int,
	@Subject varchar(150),
	@DueDate smalldatetime,
	@Priority smallint,
	@ContactCompanyKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

	Declare @FormNumber int,
			@UniqueNumbers tinyint
	 
	IF @ProjectKey IS NULL 
		Select	@FormNumber = MAX(FormNumber) + 1
		From	tForm (nolock)
		Where	FormDefKey = @FormDefKey
	ELSE
	BEGIN
		SELECT	@UniqueNumbers = ISNULL(UniqueNumbers,0)
		FROM	tFormDef
		WHERE	FormDefKey = @FormDefKey
		
		IF @UniqueNumbers = 1
			SELECT	@FormNumber = MAX(FormNumber) + 1
			FROM	tForm (nolock)
			WHERE	FormDefKey = @FormDefKey
		ELSE	
			SELECT	@FormNumber = MAX(FormNumber) + 1
			FROM	tForm (nolock)
			WHERE	FormDefKey = @FormDefKey 
			AND		ProjectKey = @ProjectKey
	END

	IF @FormNumber IS NULL
		Select @FormNumber = 1

	INSERT tForm
	(
	FormDefKey,
	CompanyKey,
	ProjectKey,
	TaskKey,
	FormNumber,
	Author,
	DateCreated,
	AssignedTo,
	Subject,
	DueDate,
	Priority,
	ContactCompanyKey
	)
	VALUES
	(
	@FormDefKey,
	@CompanyKey,
	@ProjectKey,
	@TaskKey,
	@FormNumber,
	@Author,
	CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
	@AssignedTo,
	@Subject,
	@DueDate,
	@Priority,
	@ContactCompanyKey
	)
	 
	SELECT @oIdentity = @@IDENTITY
	RETURN 1
GO
