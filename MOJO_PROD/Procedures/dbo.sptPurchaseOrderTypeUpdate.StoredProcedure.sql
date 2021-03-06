USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderTypeUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderTypeUpdate]
	@PurchaseOrderTypeKey int,
	@CompanyKey int,
	@PurchaseOrderTypeName varchar(200),
	@Description varchar(1000),
	@HeaderFieldSetKey int,
	@DetailFieldSetKey int,
	@StandardHeaderTextKey int,
	@StandardFooterTextKey int,
	@MarkupType smallint,
	@SubjectLabel varchar(50),
	@QtyLabel varchar(50),
	@UnitCostLabel varchar(50),
	@UserDate1Label varchar(50),
	@UserDate2Label varchar(50),
	@UserDate3Label varchar(50),
	@UserDate4Label varchar(50),
	@UserDate5Label varchar(50),
	@UserDate6Label varchar(50),
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 11/28/12  WDF 10.6.6.2 Added StandardHeaderTextKey and StandardFooterTextKey
*/
	if exists(select 1 from tPurchaseOrderType (NOLOCK) where PurchaseOrderTypeName = @PurchaseOrderTypeName and 
			PurchaseOrderTypeKey <> @PurchaseOrderTypeKey and CompanyKey = @CompanyKey)
		return -1

	UPDATE
		tPurchaseOrderType
	SET
		CompanyKey = @CompanyKey,
		PurchaseOrderTypeName = @PurchaseOrderTypeName,
		Description = @Description,
		HeaderFieldSetKey = @HeaderFieldSetKey,
		DetailFieldSetKey = @DetailFieldSetKey,
		StandardHeaderTextKey = @StandardHeaderTextKey,
		StandardFooterTextKey = @StandardFooterTextKey,
		Active = @Active
/*		MarkupType = @MarkupType,
		SubjectLabel = @SubjectLabel,
		QtyLabel = @QtyLabel,
		UnitCostLabel = @UnitCostLabel,
		UserDate1Label = @UserDate1Label,
		UserDate2Label = @UserDate2Label,
		UserDate3Label = @UserDate3Label,
		UserDate4Label = @UserDate4Label,
		UserDate5Label = @UserDate5Label,
		UserDate6Label = @UserDate6Label
		*/
	WHERE
		PurchaseOrderTypeKey = @PurchaseOrderTypeKey 

	RETURN 1
GO
