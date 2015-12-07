CREATE PROCEDURE sptClientProductInsert
	@CompanyKey int,
	@ClientKey int,
	@ProductName varchar(300),
	@ClientDivisionKey int,
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tClientProduct
		(
		CompanyKey,
		ClientKey,
		ProductName,
		ClientDivisionKey,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@ProductName,
		@ClientDivisionKey,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1