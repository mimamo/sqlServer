USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaBuyRevisionHistoryInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaBuyRevisionHistoryInsert]
	@Entity varchar(50),
	@EntityKey int,
	@CompanyKey int,
	@Action varchar(200),
	@Comments varchar(200),
	@UserKey int = NULL,
	-- these are for line specific logging
	@MediaPremiumKey int = null,
	@LineNumber int = null,
	@PremiumID varchar(50) = null

AS --Encrypt

/*
|| When     Who	Rel			What
|| 05/20/14 GHL 10.5.8.0	Creation for media buys
*/

	declare @Revision int
	declare @POKind int

	-- if we use other entities, modify query
	if @Entity = 'tPurchaseOrder'
		select @Revision = isnull(Revision, 0)
			  ,@POKind = isnull(POKind, 1)
		from   tPurchaseOrder (nolock)
		where  PurchaseOrderKey = @EntityKey
	else if @Entity = 'tMediaOrder'
		select @Revision = isnull(mo.Revision, 0)
			  ,@POKind = isnull(mws.POKind, 1)
		from   tMediaOrder mo (nolock)
			left outer join tMediaWorksheet mws (nolock) on mo.MediaWorksheetKey = mws.MediaWorksheetKey
		where  mo.MediaOrderKey = @EntityKey
	

	INSERT tMediaBuyRevisionHistory
		(
		Entity,
		EntityKey,
		CompanyKey,
		Action,
		Comments,
		UserKey,
		Revision,
		POKind,
		-- line specific
		MediaPremiumKey,
	    LineNumber,
	    PremiumID 
		)

	VALUES
		(
		@Entity,
		@EntityKey,
		@CompanyKey,
		@Action,
		@Comments,
		@UserKey,
		@Revision,
		@POKind,
		-- line specific
		@MediaPremiumKey,
	    @LineNumber,
	    @PremiumID 
		)
	
Return 1
GO
