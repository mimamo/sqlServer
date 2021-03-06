USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineProjectInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineProjectInsert]
	 @InvoiceKey int
	,@ProjectKey int
	,@Description varchar(100) -- Line Subject
	,@LineType int
	,@WorkTypeKey int
	,@ParentLineKey int
	,@LineAmount money
	,@Taxable tinyint
	,@Taxable2 tinyint
	,@AdvanceBilling tinyint
	,@TaskKey int = NULL
	,@Entity varchar(100) = NULL 
	,@EntityKey int = NULL
	,@DefaultClassKey int = NULL
	,@EstimateKey int = NULL
	,@DepartmentKey int = NULL
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/27/06 GHL 8.4   Added support of fixed fee billing by billing item  
  || 07/06/07 GHL 8.5   Added OfficeKey + DepartmentKey     
  || 07/10/07 QMD 8.5   (+GHL) Expense Type reference changed to tItem             
  || 04/07/08 GHL 8.508 (23712) The logic is now	
  ||
  ||                    Assign first the class on the Project if not blank
  ||                    If blank
  ||                        Assign the class from item/service/billing item
  ||                    If class from item/service/billing item is blank
  ||                        Assign the class from preferences
  ||
  ||                    Remove reading of FixedFeeBillingClassDetail 
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 11/05/08 GHL 10.012 (39611) Rolled back change for 37465       
  || 07/14/09 GHL 10.505 (56484) Added support of No Billing Item/No Item/No Service/No Task billing
  || 09/15/09 GHL 10.510 (61782) Getting now DepartmentKey from tWorkType
  || 09/12/12 GHL 10.560 (151932) Set task description if tTask.ShowDescOnEst = 1
  || 01/17/13 RLB 10.564 (164847) Add error for no default advance billing default when creating AB invoices
 */

declare @NewInvoiceKey int	
declare @NewInvoiceLineKey int
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContact varchar(100) 
declare @DefaultSalesAccountKey int
declare @RetVal int
declare @ProjectName varchar(100)
declare @AdvBillAccountKey int
declare @RequireClasses int
declare @OfficeKey int
declare @ProjectClassKey int
declare @ClassKey int
declare @EntityAccountKey int
declare @EntityDepartmentKey int
declare @EntityClassKey int
declare @LineDescription varchar(6000)
declare @ShowDescOnEst int

	--init
	--get client key
	select @ClientKey = ClientKey
	  from tProject (nolock)
	 where ProjectKey = @ProjectKey
	if @ClientKey is null
	  return -1
		
	--get invoice defaults
	select @CompanyKey = p.CompanyKey
		  ,@BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
	      ,@ProjectName = p.ProjectName
	      ,@DefaultSalesAccountKey = ISNULL(c.DefaultSalesAccountKey, 0)
	      ,@OfficeKey = p.OfficeKey
	      ,@ProjectClassKey = p.ClassKey
	  from tProject p (nolock) 
			inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
			left outer join tUser u (nolock) on p.BillingContact = u.UserKey
	 where p.ProjectKey = @ProjectKey
	
	-- pull defaults from various tables
	
	if @Entity is null
	-- @Entity null will cover the 2 cases: billing by Task and billing by Billing Item
	-- in both cases, query tWorkType OK since there is nothing to get from tTask, ie no class, gl account, department
	begin
	    if isnull(@WorkTypeKey, 0) > 0
			select @EntityAccountKey = GLAccountKey
			      ,@EntityDepartmentKey = DepartmentKey
				  ,@EntityClassKey = ClassKey 
			from tWorkType (nolock) 
			where WorkTypeKey = @WorkTypeKey
	end
	else if @Entity = 'tItem'
	begin
	    if isnull(@EntityKey, 0) > 0
			select @EntityAccountKey = SalesAccountKey
				  ,@EntityDepartmentKey = DepartmentKey
				  ,@EntityClassKey = ClassKey
			from   tItem (nolock)
			where  ItemKey = @EntityKey
	end
	else if @Entity = 'tService'
	begin
	    if isnull(@EntityKey, 0) > 0
			select @EntityAccountKey = GLAccountKey
				  ,@EntityDepartmentKey = DepartmentKey
				  ,@EntityClassKey = ClassKey
			from   tService (nolock)
			where  ServiceKey = @EntityKey
	end


	-- Avoid 0, NULL values are valid 
	IF @EntityAccountKey = 0
		SELECT @EntityAccountKey = NULL
	IF @EntityDepartmentKey = 0
		SELECT @EntityDepartmentKey = NULL
	IF @EntityClassKey = 0
		SELECT @EntityClassKey = NULL
		
	-- department	
	IF @EntityDepartmentKey IS NOT NULL
		SELECT @DepartmentKey = @EntityDepartmentKey

	-- GL Account
	IF @EntityAccountKey is not null
		Select @DefaultSalesAccountKey = @EntityAccountKey
	ELSE
	BEGIN
		if @DefaultSalesAccountKey = 0
			Select @DefaultSalesAccountKey = DefaultSalesAccountKey
			From tPreference (nolock)
			Where CompanyKey = @CompanyKey
	END

	if @LineType = 1
		Select @DefaultSalesAccountKey = NULL
		 
	if @AdvanceBilling = 1
	begin
		Select @AdvBillAccountKey = AdvBillAccountKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey

		if @AdvBillAccountKey is not null
			Select @DefaultSalesAccountKey = @AdvBillAccountKey
		else
			return -3
	end
	
	Select @RequireClasses = isnull(RequireClasses, 1)
	From tPreference (nolock)
	Where CompanyKey = @CompanyKey

	--class
	IF ISNULL(@ProjectClassKey, 0) > 0
		SELECT @ClassKey = @ProjectClassKey
	ELSE IF ISNULL(@EntityClassKey, 0) > 0
		SELECT @ClassKey = @EntityClassKey
	ELSE
		SELECT @ClassKey = @DefaultClassKey
	
	If @ClassKey is null and @RequireClasses = 1
		return -2

	If @OfficeKey = 0
		Select @OfficeKey = null
				
	if @TaskKey <= 0 -- could be -1 on the UI because of rollup problems
		select @TaskKey = null
	
	if isnull(@TaskKey, 0) > 0
	begin 
		select @ShowDescOnEst = isnull(ShowDescOnEst, 0)
		      ,@LineDescription = Description
		from  tTask (nolock)
		where TaskKey = @TaskKey	
		
		if 	@ShowDescOnEst = 0
			select @LineDescription = null	
	end

	--create single invoice line
	exec @RetVal = sptInvoiceLineInsert
				   @InvoiceKey				-- Invoice Key
				  ,@ProjectKey					-- ProjectKey
				  ,@TaskKey						-- TaskKey
				  ,@Description					-- Line Subject
				  ,@LineDescription				-- Line description
				  ,1                    		-- Bill From 
				  ,1							-- Quantity
				  ,@LineAmount					-- Unit Amount
				  ,@LineAmount					-- Line Amount
				  ,@LineType					-- line type
				  ,@ParentLineKey				-- parent line key
				  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
				  ,@ClassKey                    -- Class Key
				  ,@Taxable						-- Taxable
				  ,@Taxable2					-- Taxable
				  ,@WorkTypeKey					-- Work TypeKey
				  ,0
				  ,@Entity
				  ,@EntityKey
				  ,@OfficeKey
				  ,@DepartmentKey
				  ,@NewInvoiceLineKey output				  
  

	IF ISNULL(@EstimateKey, 0) > 0
		UPDATE tInvoiceLine
		SET    EstimateKey = @EstimateKey
		WHERE  InvoiceLineKey = @NewInvoiceLineKey
			
	return @NewInvoiceLineKey
GO
