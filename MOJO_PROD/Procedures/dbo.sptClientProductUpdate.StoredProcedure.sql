USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientProductUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientProductUpdate]
	@ClientProductKey int,
	@CompanyKey int,
	@ClientKey int,
	@ProductName varchar(300),
	@ProductID varchar(50),
	@ClientDivisionKey int,
	@Active tinyint,
	@Action varchar(10)

AS --Encrypt

/*
|| When     Who Rel     What
|| 12/2/10  RLB 10.539  (95803) Only insert Product if there is a name
|| 09/16/14	MAS 10.5.8.3 Added ProductID For Abelson Taylor
|| 10/01/14	WDF 10.5.8.4 Require ProductID to be unique across all companies for Abelson Taylor
|| 01/30/15 GHL 10.5.8.8 When requiring a product ID, error out if ID is NULL
*/

declare @ReqUniqueID int
declare @ProdID varchar(50)

if @Action = 'delete'
BEGIN
	Update tMediaEstimate Set ClientProductKey = NULL Where ClientProductKey = @ClientProductKey
	Update tProject Set ClientProductKey = NULL Where ClientProductKey = @ClientProductKey
	
	DELETE
	FROM tClientProduct
	WHERE
		ClientProductKey = @ClientProductKey 
END
ELSE
BEGIN

	select @ReqUniqueID = ISNULL(RequireUniqueIDOnProdDiv, 0) from tPreference where CompanyKey = @CompanyKey
	
	if @ReqUniqueID = 1
	BEGIN
		if isnull(@ProductID, '') = ''
			return -1

		if exists(select 1 from tClientProduct (NOLOCK) where ProductID = @ProductID and CompanyKey = @CompanyKey and ClientProductKey <> @ClientProductKey)
			return -1
	END

	if @ClientProductKey < 0 AND @ProductName IS NOT NULL
	BEGIN
		INSERT tClientProduct
			(
			CompanyKey,
			ClientKey,
			ProductName,
			ProductID,
			ClientDivisionKey,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@ClientKey,
			@ProductName,
			@ProductID,
			@ClientDivisionKey,
			@Active
			)
		
		return @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE
			tClientProduct
		SET
			CompanyKey = @CompanyKey,
			ClientKey = @ClientKey,
			ProductName = @ProductName,
			ProductID = @ProductID,
			ClientDivisionKey = @ClientDivisionKey,
			Active = @Active
		WHERE
			ClientProductKey = @ClientProductKey
			
			return @ClientProductKey
	END
END
	

	RETURN 1
GO
