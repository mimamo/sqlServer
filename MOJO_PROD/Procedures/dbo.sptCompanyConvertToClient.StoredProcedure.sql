USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyConvertToClient]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyConvertToClient]
	@OwnerCompanyKey int,
	@CompanyKey int,
	@CustomerID varchar(50)
AS

/*
|| When      Who Rel      What
|| 3/16/10   CRG 10.5.2.0 Created to convert an existing company to a client
|| 4/23/10   GHL 10.5.2.2 (Punchlist DEV 1200) apply transaction prefs when setting customer ID
*/ 

	IF EXISTS(SELECT NULL 
			FROM	tCompany (nolock) 
			WHERE 	CompanyKey <> @CompanyKey 
			AND 	OwnerCompanyKey = @OwnerCompanyKey 
			AND		CustomerID = @CustomerID)
		RETURN -1
	
	 Declare
	 @GetRateFrom int,
	 @TimeRateSheetKey int,
	 @HourlyRate money,
	 @GetMarkupFrom int,
	 @ItemRateSheetKey int, 
	 @ItemMarkup decimal(24,4),
	 @IOCommission decimal(24,4),
	 @BCCommission decimal(24,4)
	 
	select @GetRateFrom = isnull(GetRateFrom, 1) 
		,@TimeRateSheetKey = isnull(TimeRateSheetKey, 0) 
		, @HourlyRate = isnull(HourlyRate, 0) 
		, @GetMarkupFrom = isnull(GetMarkupFrom, 1) 
		, @ItemRateSheetKey = isnull(ItemRateSheetKey, 0)
		, @ItemMarkup = isnull(ItemMarkup, 0) 
		, @IOCommission = isnull(IOCommission, 0) 
		, @BCCommission = isnull(BCCommission, 0) 
	from tPreference (nolock) where CompanyKey = @OwnerCompanyKey

	UPDATE	tCompany
	SET		BillableClient = 1
			,CustomerID = @CustomerID

			,GetRateFrom = @GetRateFrom
	    	,TimeRateSheetKey = @TimeRateSheetKey
		    ,HourlyRate = @HourlyRate 
		    ,GetMarkupFrom = @GetMarkupFrom 
		    ,ItemRateSheetKey = @ItemRateSheetKey
		    ,ItemMarkup = @ItemMarkup
		    ,IOCommission = @IOCommission 
		    ,BCCommission = @BCCommission
	WHERE	CompanyKey = @CompanyKey

	RETURN 1
GO
