USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleUpdate]
	@TitleKey int,
	@CompanyKey int,
	@TitleID varchar(50),
	@TitleName varchar(500),
	@HourlyRate money,
	@HourlyCost money,
	@Active tinyint,
	@DepartmentKey int,
	@WorkTypeKey int,
	@GLAccountKey int,
	@Taxable tinyint,
	@Taxable2 tinyint

AS --Encrypt

/*
|| When       Who Rel	   What
|| 09/12/2014 WDF 10.5.8.4 New
*/

if exists(select 1 from tTitle (nolock)
		Where CompanyKey = @CompanyKey
		and TitleKey <> @TitleKey
		and TitleID = @TitleID)
	Return -1
	
	
IF @TitleKey <= 0
BEGIN
	INSERT tTitle
			(
			CompanyKey,
			TitleID,
			TitleName,
			HourlyRate,
			HourlyCost,
			Active,
			DepartmentKey,
		    WorkTypeKey,
	        GLAccountKey,
	        Taxable,
	        Taxable2
			)

		VALUES
			(
			@CompanyKey,
			@TitleID,
			@TitleName,
			@HourlyRate,
			@HourlyCost,
			@Active,
			@DepartmentKey,
		    @WorkTypeKey,
	        @GLAccountKey,
	        @Taxable,
	        @Taxable2
			)
		
		SELECT @TitleKey = @@IDENTITY
END
ELSE
BEGIN
		UPDATE
			tTitle
		SET
			CompanyKey = @CompanyKey,  
			TitleID = @TitleID,     
			TitleName = @TitleName,   
			HourlyRate = @HourlyRate,  
			HourlyCost = @HourlyCost,  
			Active = @Active,      
			DepartmentKey = @DepartmentKey,
		    WorkTypeKey = @WorkTypeKey,
	        GLAccountKey= @GLAccountKey,
	        Taxable = @Taxable,
	        Taxable2 = @Taxable2
		WHERE
			TitleKey = @TitleKey 
END

		RETURN @TitleKey
GO
