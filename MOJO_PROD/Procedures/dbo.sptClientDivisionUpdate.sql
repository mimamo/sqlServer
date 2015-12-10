USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientDivisionUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClientDivisionUpdate]
	@ClientDivisionKey int,
	@CompanyKey int,
	@ClientKey int,
	@DivisionName varchar(300),
	@DivisionID varchar(50),
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int,
	@Active tinyint,
	@Action varchar(10)

AS --Encrypt

/*
|| When     Who Rel     What
|| 12/2/10  RLB 10.539  (95803) Only insert Division if there is a  Division Name
|| 09/16/14	MAS 10.5.8.3 Added DivisionID For Abelson Taylor
|| 10/01/14	WDF 10.5.8.4 Require DivisionID to be unique across all companies for Abelson Taylor
|| 01/30/15 GHL 10.5.8.8 When requiring a division ID, error out if ID is NULL
*/

declare @ReqUniqueID int
declare @DivID varchar(300)

if @Action = 'delete'
BEGIN
	Update tMediaEstimate Set ClientDivisionKey = NULL Where ClientDivisionKey = @ClientDivisionKey
	Update tClientProduct Set ClientDivisionKey = NULL Where ClientDivisionKey = @ClientDivisionKey
	Update tProject Set ClientDivisionKey = NULL Where ClientDivisionKey = @ClientDivisionKey
						
	DELETE
	FROM tClientDivision
	WHERE ClientDivisionKey = @ClientDivisionKey 
	
	Return 0

END
ELSE
BEGIN

	select @ReqUniqueID = ISNULL(RequireUniqueIDOnProdDiv, 0) from tPreference where CompanyKey = @CompanyKey
	
	if @ReqUniqueID = 1
	BEGIN
		if isnull(@DivisionID, '') = ''
			return -1

		if exists(select 1 from tClientDivision (NOLOCK) where DivisionID = @DivisionID and CompanyKey = @CompanyKey and ClientDivisionKey <> @ClientDivisionKey)
			return -1

	END
	
	if @ClientDivisionKey <= 0 AND @DivisionName IS NOT NULL
	BEGIN
		INSERT tClientDivision
			(
			CompanyKey,
			ClientKey,
			DivisionName,
			DivisionID,
			ProjectNumPrefix,
			NextProjectNum,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@ClientKey,
			@DivisionName,
			@DivisionID,
			@ProjectNumPrefix,
			@NextProjectNum,
			@Active
			)
		
		return @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE
			tClientDivision
		SET
			CompanyKey = @CompanyKey,
			ClientKey = @ClientKey,
			DivisionName = @DivisionName,
			DivisionID = @DivisionID,
			ProjectNumPrefix = @ProjectNumPrefix,
			NextProjectNum = @NextProjectNum,
			Active = @Active
		WHERE
			ClientDivisionKey = @ClientDivisionKey 
		
		return @ClientDivisionKey
	END

END



	RETURN 1
GO
