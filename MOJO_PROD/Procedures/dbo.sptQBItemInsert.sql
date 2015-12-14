USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBItemInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBItemInsert]
	@CompanyKey int,
	@ItemID varchar(50),
	@ItemName varchar(200),
	@StandardDescription varchar(1000),
	@UnitCost money,
	@UnitRate money,
    @ExpenseAccountLinkID varchar(100),
	@SalesAccountLinkID varchar(100),
	@LinkID varchar(100)
	
	
AS --Encrypt

/*
|| When     Who Rel   What
|| 08/28/07 CRG 8.5   Added UseUnitRate to the sptItemInsert call.
|| 02/21/11 QMD 10.5.4.1	Updated parms for sptItemInsert
*/

declare @RetVal int
declare @ItemKey int
declare @Markup decimal(24,4)
declare @SalesAccountKey int
declare @ExpenseAccountKey int


	if @UnitCost <> 0
		select @Markup = round((@UnitRate/@UnitCost)-1,2)
	else
		select @Markup = 0
	select @SalesAccountKey = GLAccountKey from tGLAccount (nolock) where LinkID = @SalesAccountLinkID
	select @ExpenseAccountKey = GLAccountKey from tGLAccount (nolock) where LinkID = @ExpenseAccountLinkID

	select @ItemKey = ItemKey
	  from tItem (nolock)
	 where LinkID = @LinkID
	   and CompanyKey = @CompanyKey
	 
if @ItemKey is null
  begin	  
	exec @RetVal = sptItemInsert
	     @CompanyKey,
		 0,
		 @ItemID,
		 @ItemName,
		 @UnitCost,
		 @UnitRate,
		 @Markup,
		 null,
		 @StandardDescription,
		 null,
		 null,
		 @ExpenseAccountKey,
		 @SalesAccountKey,
		 null,
		 null,
		 1,
		 null,
	 	 null,
	 	 0, --UseUnitRate
		 0,
		 0,
		 0,
		 @ItemKey output


	
	if @RetVal < 0
		return -1
		
	update tItem
	   set LinkID = @LinkID
	 where ItemKey = @ItemKey
	 
  end
else
	update tItem
       set ItemID = @ItemID,
           ItemName = @ItemName,
           UnitCost = @UnitCost,
           UnitRate = @UnitRate,
           Markup = @Markup,
           StandardDescription = @StandardDescription,
           ExpenseAccountKey = @ExpenseAccountKey,
           SalesAccountKey = @SalesAccountKey
	 where LinkID = @LinkID           
	
	return @ItemKey
GO
