USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBInvoiceLineInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBInvoiceLineInsert]
		@CompanyKey int,
		@InvoiceKey int,
		@LineSubject varchar(100),
		@LineDescription varchar(500),
		@UnitAmount money,
		@Quantity decimal(9,3),
		@ItemID varchar(100)
		
						
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/19/07 GHL 8.5   Added OfficeKey + DepartmentKey
*/
declare @RetVal int
declare @InvoiceLineKey int
declare @ItemKey int
declare @EntityKey int
declare @ServiceKey int
declare @TotalAmount money
declare @Entity varchar(100)
 
	select @ItemKey = ItemKey
	  from tItem (nolock)
	 where LinkID = @ItemID
	   and CompanyKey = @CompanyKey
	   
	if @ItemKey is null
		begin
			select @ServiceKey = ServiceKey
			  from tService (nolock)
			 where LinkID = @ItemID
			   and CompanyKey = @CompanyKey
			
			if @ServiceKey is null
				return -10 
		end
		
	if @ItemKey is not null
		select @Entity = 'tItem',
			   @EntityKey = @ItemKey
	else
		select @Entity = 'tService',
			   @EntityKey = @ServiceKey
			   
	if @Quantity is null or @Quantity = 0
		select @Quantity = 1
		
	select @TotalAmount = isnull(@UnitAmount,0) * @Quantity
	
	exec @RetVal = sptInvoiceLineInsert
		 @InvoiceKey,
		 null,
		 null, 
		 @LineSubject,
		 @LineDescription,
		 1,
		 @Quantity,
		 @UnitAmount,
		 @TotalAmount,
		 2,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 0,
		 @Entity,
		 @EntityKey,
		 null, -- OfficeKey
		 null, -- DepartmentKey
		 @InvoiceLineKey output
		 
		 
	return @InvoiceLineKey
GO
