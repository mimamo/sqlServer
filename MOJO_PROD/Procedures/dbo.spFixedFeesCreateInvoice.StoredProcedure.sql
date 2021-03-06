USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCreateInvoice]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCreateInvoice]
	(
	@Entity varchar(50) -- tCampaign, tMediaEstimate
	,@EntityKey int     -- CampaignKey, etc
	,@InvoiceBy varchar(20) -- OneLine, Segment, Item/Service, Project
	,@UserKey int
	,@InvoiceAmount money
	,@AdvanceBilling tinyint = 1
	,@DefaultClassKey int = Null
	,@EstimateKey int = Null
	,@DefaultDepartmentKey int = NULL
	,@AddProjectDescription tinyint = 0
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/2/10 GHL 10.522 Creation for campaign FF billing
  ||                    Cloned fragments from following sps used in FF project billing:
  ||                    - sptInvoiceInsertProject
  ||                    - sptInvoiceInsertProjectOneLine
  ||                    - sptInvoiceLineProjectInsert  
  || 12/14/11 GHL 10.540 Made changes to support case InvoiceBy = Project
  ||                     Reviewed design because the Fixed Fee campaign grid show show projects only (i.e. no item/services)
  ||                     And this sp will call spFixedFeesCreateInvoiceLines to create lines for items/services 
  || 01/21/11 GHL 10.540 (101244) If AdvanceBilling = 1, do not show details under segments or projects
  ||                      else show details under segments or projects    
  || 02/08/11 GHL 10.540 (102053) Getting now GLCompanyKey from the client   
  || 05/27/11 GHL 10.544 (112126) Added AddProjectDescription to have the option to put the project desc on the lines 
  ||                      Note: when printing an invoice, there is already some logic to pull project description based 
  ||                      on line type.
  || 08/08/11 GHL 10.546  Added project rollup at the end of the stored proc
  || 10/21/11 GHL 10.549  (124337) When billing by project, added a check to make sure that all projects have the
  ||                      same GL company, if they have we take that company, if they dont, we error out 
  || 04/27/12 GHL 10.555  Made changes for ICT, lines may have a different GLCompanyKey now
  ||                      Also get GLCompanyKey from campaign rather than the client
  || 10/01/13 GHL 10.573  Added currency info when calling invoice insert
  || 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
  || 04/23/15 GHL 10.591 (254451) Added setting of OfficeKey from the project
  */
  
	SET NOCOUNT ON
	
	if isnull(@EntityKey, 0) = 0
		return 0
		 
	/* Assume
	CREATE TABLE #line (
		Entity VARCHAR(50) NULL -- tCampaignSegment, tItem, tService 
	   ,EntityKey INT NULL
	   ,EntityName VARCHAR(250) NULL
	   ,EntityDescription text null
	   ,BillAmt MONEY NULL
	   ,LineOrder INT NULL
	   
	   ,EntityAccountKey int null
	   ,EntityDepartmentKey int null
	   ,EntityClassKey int null	
	   ,Taxable int null
	   ,Taxable2 int null
	   
	   ,InvoiceLineKey int null
		)
	*/
	
-- General vars
declare @NewInvoiceKey int	
declare @NewInvoiceLineKey int	
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContact varchar(100)
declare @PrimaryContactKey int 
declare @DefaultSalesAccountKey int
declare @SalesAccountKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @DefaultARAccountKey int
declare @InvoiceTemplateKey int, @SalesTaxKey int, @SalesTax2Key int, @PaymentTermsKey int
declare @AdvBillAccountKey int
declare @DueDate smalldatetime
declare @DueDays int
declare @UseGLCompany int
declare @GLCompanyKey int
declare @OfficeKey int
declare @LayoutKey int
declare @EntityName varchar(250)
declare @RequireClasses int
declare @MultipleSegments int
declare @SegmentKey int
	
-- vars for line info
declare @LineKey int
declare @LineType int
declare @LineEntity varchar(50)
declare @LineEntityKey int
declare @LineBillAmt money
declare @LineOrder money
declare @LineEntityName varchar(250)
declare @LineAccountKey int 
declare @LineDepartmentKey int
declare @LineClassKey int 	
declare @Taxable int
declare @Taxable2 int
declare @CurrencyID varchar(10)

-- need to know which sp is failing
declare @kErrMissingClass int				select @kErrMissingClass = -1
declare @kErrProjectDiffGLCompany int		select @kErrProjectDiffGLCompany = -2

declare @kErrInvoiceBase int				select @kErrInvoiceBase = -1000
declare @kErrInvoiceLineBase int			select @kErrInvoiceLineBase = -2000

declare @DisplayOption int 
declare @kDisplayOptionNoDetail int			select @kDisplayOptionNoDetail = 1
declare @kDisplayOptionSubItemDetail int	select @kDisplayOptionSubItemDetail = 2
declare @kDisplayOptionTransactions int		select @kDisplayOptionTransactions = 3

	if @Entity = 'tCampaign'
	begin
		select @CompanyKey = c.CompanyKey
		       ,@ClientKey = c.ClientKey
               ,@LayoutKey = c.LayoutKey
               ,@BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
			   ,@PrimaryContactKey = u.UserKey 
		       ,@EntityName = c.CampaignName
			   ,@MultipleSegments = isnull(c.MultipleSegments, 0)
			   ,@GLCompanyKey = c.GLCompanyKey 
		from   tCampaign c (nolock)
			left outer join tUser u (nolock) on c.ContactKey = u.UserKey
		where  c.CampaignKey = @EntityKey 
		
		-- no defaults for GLCompanyKey, OfficeKey
	end

	Select @InvoiceTemplateKey = ISNULL(c.InvoiceTemplateKey, 0)
		 , @SalesTaxKey = c.SalesTaxKey
		 , @SalesTax2Key = c.SalesTax2Key
		 , @PaymentTermsKey = c.PaymentTermsKey
		 , @DefaultSalesAccountKey = ISNULL(c.DefaultSalesAccountKey, 0)
		 , @CurrencyID = CurrencyID
	from tCompany c (nolock) 
	where c.CompanyKey = @ClientKey
	
	SELECT @UseGLCompany = ISNULL(pref.UseGLCompany, 0)
	FROM   tPreference pref (NOLOCK)  
	WHERE  pref.CompanyKey = @CompanyKey

	IF @UseGLCompany = 0
		SELECT @GLCompanyKey = null

	select @TodaysDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)
	IF ISNULL(@PaymentTermsKey, 0) > 0
	BEGIN
		SELECT @DueDays = DueDays
		FROM   tPaymentTerms (NOLOCK)
		WHERE  PaymentTermsKey = @PaymentTermsKey
		 	
		SELECT @DueDate = DATEADD(d, @DueDays, @TodaysDate) 	
	END
	ELSE
		SELECT @DueDate = @TodaysDate

	--get default AR and advanced billing accont key
	select @DefaultARAccountKey = DefaultARAccountKey
			,@AdvBillAccountKey = AdvBillAccountKey
			,@RequireClasses = isnull(RequireClasses, 1)
	  from tPreference (nolock)
	 where CompanyKey = @CompanyKey

	if @DefaultSalesAccountKey = 0
		Select @DefaultSalesAccountKey = DefaultSalesAccountKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey		

	If @AdvanceBilling = 1 And isnull(@AdvBillAccountKey, 0) > 0
		Select @DefaultSalesAccountKey = @AdvBillAccountKey


	if @DefaultSalesAccountKey = 0
		select @DefaultSalesAccountKey = null
	if @DefaultClassKey = 0
		select @DefaultClassKey = null
	if @DefaultDepartmentKey = 0
		select @DefaultDepartmentKey = null
	if @AdvBillAccountKey = 0
		select @AdvBillAccountKey = null	

	if @InvoiceBy = 'Segment'
	begin
		if @AdvanceBilling = 1
			select @LineType = 2 -- We do not show detail lines, so the campaign segment is a detail line
		else
			-- Not an advance bill
			select @LineType = 1 -- We show detail lines, so the campaign segment is a summary line
		
		update #line
		set    #line.Entity = 'tCampaignSegment'
			  ,#line.EntityName = cs.SegmentName
			  ,#line.EntityDescription = cs.SegmentDescription
			  ,#line.LineKey = #line.LineOrder -- we do not have a LineKey yet, so set it to LineOrder
			  ,#line.ParentLineKey = 0 
			  ,#line.LineType = @LineType
	    from   tCampaignSegment cs (nolock)
	    where  #line.EntityKey = cs.CampaignSegmentKey
		and    cs.CampaignKey = @EntityKey

		-- now create the missing items/services
		select @LineKey = 0
		while (@AdvanceBilling = 0) -- only do this if this is NOT an advance billing
		begin
			select @LineKey = min(LineKey)
			from   #line
			where  LineKey > @LineKey
			and    Entity = 'tCampaignSegment'
 			 
			if @LineKey is null
				break
				
			select @LineEntityKey = EntityKey
			      ,@LineBillAmt = BillAmt
			from   #line 
			where  Entity = 'tCampaignSegment'
			and    LineKey = @LineKey

			-- CampaignKey = EntityKey, CampaignSegmentKey = @LineEntityKey, ProjectKey = 0, ParentLineKey = @LineKey
			-- these lines are still created in #line
			exec spFixedFeesCreateInvoiceLines @EntityKey, @LineEntityKey, 0, @LineKey, @LineBillAmt

			-- if no underlying line was created, this is a detail line, not a summary line
			if (select count(*) from #line where ParentLineKey = @LineKey and Entity <> 'tCampaignSegment') = 0
				update #line set LineType = 2 where LineKey = @LineKey and Entity = 'tCampaignSegment'

		end


	end

	declare @GLCompanyCount int
	if @InvoiceBy = 'Project'
	begin
		if @AdvanceBilling = 1
			select @LineType = 2 -- We do not show detail lines, so the project is a detail line
		else
			-- Not an advance bill
			select @LineType = 1 -- We show detail lines, so the project is a summary line
		
		-- here we inserted all lines regardless of Selected status 
		-- so delete lines which are not selected 
		delete #line where Entity = 'tProject' and Selected = 0


		-- determine if the projects have different GLCompanyKeys
		
		if @UseGLCompany = 1
		begin
			select @GLCompanyCount =  count(distinct isnull(p.GLCompanyKey, 0)) from tProject p (nolock)
			inner join #line b on b.Entity = 'tProject' and b.EntityKey = p.ProjectKey

			-- return error if GL company count > 1 and this is an advance bill, we do not allow this
			if @GLCompanyCount > 1 And @AdvanceBilling = 1
				return @kErrProjectDiffGLCompany

			/* commented out because we get the GLCompany from the camapign now
			select @GLCompanyKey = GLCompanyKey from tProject p (nolock)
			inner join #line b on b.Entity = 'tProject' and b.EntityKey = p.ProjectKey
			
			if @GLCompanyKey = 0
				select @GLCompanyKey = null
			*/
				
		end
		
		update #line 
		set    #line.Selected =0
		where  #line.Entity = 'tCampaignSegment'

		update #line 
		set    #line.Selected = 1
		where  #line.Entity = 'tCampaignSegment'
		and    exists (select 1 from #line b where b.Entity = 'tProject' and b.ParentLineKey = #line.LineKey)     

		delete #line where Entity = 'tCampaignSegment' and Selected = 0

		update #line
		set    #line.EntityName = cs.SegmentName
			  ,#line.EntityDescription = cs.SegmentDescription
			  ,#line.LineType = 1 -- Summary line
	    from   tCampaignSegment cs (nolock)
	    where  #line.EntityKey = cs.CampaignSegmentKey
		and    cs.CampaignKey = @EntityKey
		and    #line.Entity = 'tCampaignSegment'

		-- this is debatable, should we have an extra 'No Segment' line when projects do not have segments
		update #line
		set    #line.EntityName = 'No Segment'
			  ,#line.LineType = 1 -- Summary line by default
	    from   #line (nolock)
	    where  #line.EntityKey = 0
		and    #line.Entity = 'tCampaignSegment'

		-- LineKey and ProjectKey should be set
		update #line
		set    #line.EntityName = p.ProjectNumber + ' - ' + p.ProjectName
		      ,#line.LineType = @LineType
			  ,#line.ProjectKey = #line.EntityKey -- was not set initially, must be set to be on the invoice line 
			  ,#line.EntityDescription = case when @AddProjectDescription = 1 then p.Description else null end
		from   tProject p (nolock)
	    where  #line.EntityKey = p.ProjectKey
		and    #line.Entity = 'tProject'
		
		-- now create the missing items/services
		select @LineKey = 0
		while (@AdvanceBilling = 0) -- only do this if this is NOT an advance billing
		begin
			select @LineKey = min(LineKey)
			from   #line
			where  LineKey > @LineKey
			and    Entity = 'tProject'
 			 
			if @LineKey is null
				break
				
			select @LineEntityKey = EntityKey
			      ,@LineBillAmt = BillAmt
			from   #line 
			where  Entity = 'tProject'
			and    LineKey = @LineKey

			-- CampaignKey = EntityKey, CampaignSegmentKey = 0, ProjectKey = @LineEntityKey, ParentLineKey = @LineKey
			-- these lines are still created in #line
			exec spFixedFeesCreateInvoiceLines @EntityKey, 0, @LineEntityKey, @LineKey, @LineBillAmt

			-- if no underlying line was created, this is a detail line, not a summary line
			if (select count(*) from #line where ParentLineKey = @LineKey) = 0
				update #line set LineType = 2 where LineKey = @LineKey and Entity = 'tProject'


			-- update the project key
			update #line set ProjectKey = @LineEntityKey where ParentLineKey = @LineKey

		end

	end
	
	-- only if 1 line or segment
	if @InvoiceBy in ('OneLine')
	begin	
		If @DefaultClassKey is null and @RequireClasses = 1
			return @kErrMissingClass
	end
	
	--select * from #line

	-- validation and defaults 
	--if @InvoiceBy in ( 'Item/Service')
	--begin
			update #line
			set    #line.EntityName = i.ItemName
				  ,#line.EntityDescription = i.StandardDescription
				  ,#line.EntityAccountKey = i.SalesAccountKey
			      ,#line.EntityDepartmentKey = i.DepartmentKey
				  ,#line.EntityClassKey = i.ClassKey
				  ,#line.Taxable = i.Taxable	
				  ,#line.Taxable2 = i.Taxable2	
			from   tItem i (nolock)
			where  #line.EntityKey = i.ItemKey
			and    #line.Entity = 'tItem'
			
			update #line
			set    #line.EntityName = s.Description
				  ,#line.EntityDescription = s.InvoiceDescription
				  ,#line.EntityAccountKey = s.GLAccountKey
			      ,#line.EntityDepartmentKey = s.DepartmentKey
				  ,#line.EntityClassKey = s.ClassKey
				  ,#line.Taxable = s.Taxable	
				  ,#line.Taxable2 = s.Taxable2	
			from   tService s (nolock)
			where  #line.EntityKey = s.ServiceKey
			and    #line.Entity = 'tService'
			
			-- departments			
			update #line
			set    #line.EntityDepartmentKey = null
			where  #line.EntityDepartmentKey = 0

			update #line
			set    #line.EntityDepartmentKey = @DefaultDepartmentKey
			where  #line.EntityDepartmentKey is null
			
			-- classes
			update #line
			set    #line.EntityClassKey = null
			where  #line.EntityClassKey = 0
				
			update #line
			set    #line.EntityClassKey = @DefaultClassKey
			where  #line.EntityClassKey is null
				
			if @RequireClasses = 1 
			begin	
				if exists (select 1 from #line where EntityClassKey is null and isnull(LineType, 2) = 2)
					return -1	
			end
				
			-- sales account	
			update #line
			set    #line.EntityAccountKey = null
			where  #line.EntityAccountKey = 0
				
			if @AdvanceBilling = 1
			begin
				if @AdvBillAccountKey is not null
					update #line
					set    #line.EntityAccountKey = @AdvBillAccountKey
				
				update #line
				set    #line.EntityAccountKey = @DefaultSalesAccountKey
				where  #line.EntityAccountKey = null
			end		
			else
			begin
				update #line
				set    #line.EntityAccountKey = @DefaultSalesAccountKey
				where  #line.EntityAccountKey = null
			end	

			update #line
			set    #line.EntityName = '[No Item]'
				  ,#line.EntityDescription ='[No Item]'
			where  #line.Entity = 'tItem'
			and    #line.EntityKey = 0	   

			update #line
			set    #line.EntityName = '[No Service]'
				  ,#line.EntityDescription ='[No Service]'
			where  #line.Entity = 'tService'
			and    #line.EntityKey = 0	   


	--end

	--select * from #line 
	--return 1
		
	exec @RetVal = sptInvoiceInsert
						@CompanyKey
						,@ClientKey
						,@BillingContact
						,@PrimaryContactKey
						,NULL									-- AddressKey
						,@AdvanceBilling
						,null               					--InvoiceNbumber
						,@TodaysDate        					--InvoiceDate
						,@DueDate					        	--Due Date
						,@TodaysDate				        	--Posting Date
						,@PaymentTermsKey  						--TermsKey
						,@DefaultARAccountKey					--Default AR Account
						,@DefaultClassKey								--ClassKey
						,NULL									--ProjectKey
						,null               					--HeaderComment
						,@SalesTaxKey					 		--SalesTaxKey
						,@SalesTax2Key					 		--SalesTax2Key
						,@InvoiceTemplateKey					--Invoice Template Key
						,@UserKey								--ApprovedBy Key
						,NULL									--User Defined 1
						,NULL									--User Defined 2
						,NULL									--User Defined 3
						,NULL									--User Defined 4
						,NULL									--User Defined 5
						,NULL									--User Defined 6
						,NULL									--User Defined 7
						,NULL									--User Defined 8
						,NULL									--User Defined 9
						,NULL									--User Defined 10
						,0
						,0
						,0
						,0										--Emailed
						,@UserKey								--CreatedByKey
						,@GLCompanyKey
						,@OfficeKey
						,0										--OpeningTransaction
						,@LayoutKey                             --LayoutKey
						,@CurrencyID 
						,1 -- exch rate
						,1 -- get a new rate
						,@NewInvoiceKey output

		if @RetVal <> 1
			return @kErrInvoiceBase + @RetVal
			
		if @Entity = 'tCampaign'
			update tInvoice
			set    CampaignKey = @EntityKey
			where  InvoiceKey = @NewInvoiceKey
			
		if @InvoiceBy = 'OneLine'
		begin
			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,NULL							-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@EntityName					-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,1							-- Quantity
						  ,@InvoiceAmount				-- Unit Amount
						  ,@InvoiceAmount				-- Line Amount
						  ,2							-- line type
						  ,0							-- parent line key
						  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
						  ,@DefaultClassKey                    -- Class Key
						  ,0							-- Taxable
						  ,0							-- Taxable2
						  ,NULL							-- Work TypeKey
						  ,0							-- PostInDetail
						  ,NULL							-- Entity
						  ,NULL							-- EntityKey
						  ,@OfficeKey
						  ,@DefaultDepartmentKey
						  ,@NewInvoiceLineKey output
			if @RetVal <> 1 
			begin
				exec sptInvoiceDelete @NewInvoiceKey
				return @kErrInvoiceLineBase + @RetVal
			end
		end	
			

		if @InvoiceBy = 'Item/Service'
		begin
			-- eliminate lines which are for the billing items, they are displayed, but we are going to recreate them
			 
			select @LineOrder = -1
			while (1=1)
			begin
				select @LineOrder = min(LineOrder)
				from   #line
				where  LineOrder > @LineOrder
				and    Entity <> 'tWorkType'

				if @LineOrder is null
					break
			
				select @LineEntity = Entity
				       ,@LineEntityKey = EntityKey
				       ,@LineEntityName = EntityName
					   ,@LineBillAmt = BillAmt	
                       ,@LineAccountKey = EntityAccountKey 
                       ,@LineDepartmentKey = EntityDepartmentKey
                       ,@LineClassKey = EntityClassKey
                       ,@Taxable = Taxable
                       ,@Taxable2 = Taxable2
				from   #line
				where  LineOrder = @LineOrder
				
			--create invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,NULL							-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineEntityName				-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,1							-- Quantity
						  ,@LineBillAmt					-- Unit Amount
						  ,@LineBillAmt					-- Line Amount
						  ,2							-- line type
						  ,0							-- parent line key
						  ,@LineAccountKey				-- Default Sales AccountKey
						  ,@LineClassKey                -- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable						-- Taxable2
						  ,NULL							-- Work TypeKey -- will be updated by the grouping by bi
						  ,0							-- PostInDetail
						  ,@LineEntity					-- Entity
						  ,@LineEntityKey				-- EntityKey
						  ,@OfficeKey
						  ,@LineDepartmentKey
						  ,@NewInvoiceLineKey output
				
				if @RetVal <> 1 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return @kErrInvoiceLineBase + @RetVal
				end				
			
				update #line 
				set    InvoiceLineKey = @NewInvoiceLineKey
				where  LineOrder = @LineOrder
					
			end

			-- can only do it here because it is a text
			update tInvoiceLine
			set    tInvoiceLine.LineDescription = #line.EntityDescription
			from   #line
			where  tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey  	
			and    tInvoiceLine.InvoiceKey = @NewInvoiceKey
			
			-- now perform the grouping by billing item, top of invoice, do not recalc invoice order
			exec sptInvoiceLineGroupFFByBillingItem @NewInvoiceKey, 0, 0 		
		end

		declare @ProjectKey int
		declare @ParentLineKey int
		declare @ParentInvoiceLineKey int
		declare @GrandParentLineKey int

		if @InvoiceBy in ( 'Segment', 'Project')
		begin

			-- do segment first
			select @LineKey = -1
			while (1=1)
			begin
				select @LineKey = min(LineKey)
				from   #line
				where  LineKey > @LineKey
				and    Entity = 'tCampaignSegment'

				if @LineKey is null
					break
			
				select @LineEntity = Entity
				       ,@LineEntityKey = EntityKey
				       ,@LineEntityName = EntityName
					   ,@LineType = LineType
					   ,@LineBillAmt = BillAmt
				from   #line
				where  LineKey = @LineKey
				
				--create single invoice line  

				if @LineType = 1 
				begin
					-- summary
					exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,Null					        -- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineEntityName				-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,0							-- Quantity
						  ,0					        -- Unit Amount
						  ,0					        -- Line Amount
						  ,1							-- line type
						  ,0							-- parent line key
						  ,null				            -- Default Sales AccountKey
						  ,null                         -- Class Key
						  ,0						    -- Taxable
						  ,0						    -- Taxable2
						  ,null							-- Work TypeKey -- will be updated by the grouping by bi
						  ,0							-- PostInDetail
						  ,null					        -- Entity
						  ,0				            -- EntityKey
						  ,null                         --@OfficeKey
						  ,null                        --@LineDepartmentKey
						  ,@NewInvoiceLineKey output
				end
				else
				begin
					-- detail line because there probably was no budget
					exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,NULL					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineEntityName				-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,1							-- Quantity
						  ,@LineBillAmt					-- Unit Amount
						  ,@LineBillAmt					-- Line Amount
						  ,2							-- line type
						  ,0		                    -- parent line key
						  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
						  ,@DefaultClassKey             -- Class Key
						  ,0						    -- Taxable
						  ,0						    -- Taxable2
						  ,NULL							-- Work TypeKey -- will be updated by the grouping by bi
						  ,0							-- PostInDetail
						  ,@LineEntity					-- Entity
						  ,@LineEntityKey				-- EntityKey
						  ,null
						  ,null
						  ,@NewInvoiceLineKey output
				end -- Line Type

				if @RetVal <> 1 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return @kErrInvoiceLineBase + @RetVal
				end				
			
				update #line 
				set    InvoiceLineKey = @NewInvoiceLineKey
				where  LineKey = @LineKey
					
			end -- segment loop

			if @InvoiceBy = 'Project'
				select @DisplayOption = @kDisplayOptionSubItemDetail
			else
				-- by segment
				select @DisplayOption = @kDisplayOptionNoDetail
			
			If @MultipleSegments = 1 
			update tInvoiceLine
			set    tInvoiceLine.LineDescription = #line.EntityDescription -- text field, cannot be in a variable
			      ,tInvoiceLine.CampaignSegmentKey = #line.EntityKey
				  ,tInvoiceLine.DisplayOption = @DisplayOption
			from   #line
			where  tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey  			
			and    #line.Entity = 'tCampaignSegment'
		    and    tInvoiceLine.InvoiceKey = @NewInvoiceKey
			

			-- next do projects
			select @LineKey = -1
			while (1=1)
			begin
				select @LineKey = min(LineKey)
				from   #line
				where  LineKey > @LineKey
				and    Entity = 'tProject'

				if @LineKey is null
					break
			
				select @LineEntity = Entity
				       ,@LineEntityKey = EntityKey
				       ,@LineEntityName = EntityName
					   ,@LineType = LineType
					   ,@LineBillAmt = BillAmt
					   ,@ParentLineKey = ParentLineKey
					   ,@ProjectKey = ProjectKey
				from   #line
				where  LineKey = @LineKey
				
				select @ParentLineKey = isnull(@ParentLineKey, 0)

				select @ParentInvoiceLineKey = InvoiceLineKey
				from   #line
				where  LineKey =@ParentLineKey

				select @ParentInvoiceLineKey = isnull(@ParentInvoiceLineKey, 0)
				
				SELECT @OfficeKey = OfficeKey FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey

				--create single invoice line 

				If @LineType = 1
				begin
					-- summary
					exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineEntityName				-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,0							-- Quantity
						  ,0					        -- Unit Amount
						  ,0					        -- Line Amount
						  ,1							-- line type
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,null				            -- Default Sales AccountKey
						  ,null                         -- Class Key
						  ,0						    -- Taxable
						  ,0						    -- Taxable2
						  ,null							-- Work TypeKey -- will be updated by the grouping by bi
						  ,0							-- PostInDetail
						  ,null					        -- Entity
						  ,0				            -- EntityKey
						  ,@OfficeKey
						  ,null                        --@LineDepartmentKey
						  ,@NewInvoiceLineKey output
				end
				else
				begin
					-- detail line because there probably was no budget
					exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineEntityName				-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,1							-- Quantity
						  ,@LineBillAmt					-- Unit Amount
						  ,@LineBillAmt					-- Line Amount
						  ,2							-- line type
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
						  ,@DefaultClassKey             -- Class Key
						  ,0						    -- Taxable
						  ,0						    -- Taxable2
						  ,NULL							-- Work TypeKey -- will be updated by the grouping by bi
						  ,0							-- PostInDetail
						  ,@LineEntity					-- Entity
						  ,@LineEntityKey				-- EntityKey
						  ,@OfficeKey
						  ,null
						  ,@NewInvoiceLineKey output
				end

				if @RetVal <> 1 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return @kErrInvoiceLineBase + @RetVal
				end				
			
				update #line 
				set    InvoiceLineKey = @NewInvoiceLineKey
				where  LineKey = @LineKey
					
			end -- project loop
		
			-- only do this if by project
			if @InvoiceBy = 'Project'
			begin
				select @DisplayOption = @kDisplayOptionNoDetail
			
				
				update tInvoiceLine
				set    tInvoiceLine.DisplayOption = @DisplayOption
				      ,tInvoiceLine.LineDescription = #line.EntityDescription
				from   #line
				where  tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey  			
				and    #line.Entity = 'tProject'
				and    tInvoiceLine.InvoiceKey = @NewInvoiceKey
			
			end

			-- next do items and services
			select @LineKey = -1
			while (1=1)
			begin
				select @LineKey = min(LineKey)
				from   #line
				where  LineKey > @LineKey
				and    LineType = 2
				and    Entity in ('tItem', 'tService')

				if @LineKey is null
					break
			
				select @LineEntity = Entity
				       ,@LineEntityKey = EntityKey
				       ,@LineEntityName = EntityName
					   ,@LineBillAmt = BillAmt	
                       ,@LineAccountKey = EntityAccountKey 
                       ,@LineDepartmentKey = EntityDepartmentKey
                       ,@LineClassKey = EntityClassKey
                       ,@Taxable = Taxable
                       ,@Taxable2 = Taxable2
					   ,@ProjectKey = ProjectKey
					   ,@ParentLineKey = ParentLineKey
				from   #line
				where  LineKey = @LineKey
				
				if @InvoiceBy = 'Project'
				begin
					select @ParentInvoiceLineKey = InvoiceLineKey
						  ,@ProjectKey = EntityKey
					from   #line
					where  LineKey = @ParentLineKey
				
					SELECT @OfficeKey = OfficeKey FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey
				END
				else
					select @ParentInvoiceLineKey = InvoiceLineKey
						  ,@ProjectKey = NULL
                          ,@OfficeKey = null
					from   #line
					where  LineKey = @ParentLineKey
				
				select @ParentInvoiceLineKey = isnull(@ParentInvoiceLineKey, 0)

				-- we will try to propagate the segment key down
				select @SegmentKey = 0
				
				if @MultipleSegments = 1
				begin
					if @InvoiceBy = 'Segment'
						select @SegmentKey = EntityKey
						from   #line
						where  LineKey = @ParentLineKey
					else
					begin
						select @GrandParentLineKey = ParentLineKey
						from   #line
						where  LineKey = @ParentLineKey

						select @SegmentKey = EntityKey
						from   #line
						where  LineKey = @GrandParentLineKey
					
					end
				end
				 
				--create invoice line
				exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineEntityName				-- Line Subject
						  ,null                 		-- Line description
						  ,1                    		-- Bill From 
						  ,1							-- Quantity
						  ,@LineBillAmt					-- Unit Amount
						  ,@LineBillAmt					-- Line Amount
						  ,2							-- line type
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@LineAccountKey				-- Default Sales AccountKey
						  ,@LineClassKey                -- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable						-- Taxable2
						  ,NULL							-- Work TypeKey -- will be updated by the grouping by bi
						  ,0							-- PostInDetail
						  ,@LineEntity					-- Entity
						  ,@LineEntityKey				-- EntityKey
						  ,@OfficeKey
						  ,@LineDepartmentKey
						  ,@NewInvoiceLineKey output
				
				if @RetVal <> 1 
				begin
					exec sptInvoiceDelete @NewInvoiceKey
					return @kErrInvoiceLineBase + @RetVal
				end				
			
				-- do we need to propagate the segment key down?? 
				update #line 
				set    InvoiceLineKey = @NewInvoiceLineKey
				      ,GPFlag = @SegmentKey
				where  LineOrder = @LineOrder
					
			end

			-- propagate CampaignSegmentKey down the lines so that we can find out what is billed next time we bill 
			update tInvoiceLine
			set    tInvoiceLine.LineDescription = #line.EntityDescription
			      ,tInvoiceLine.CampaignSegmentKey = #line.GPFlag
			from   #line
			where  tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey  	
			and    #line.Entity in ('tItem', 'tService')
		    and    tInvoiceLine.InvoiceKey = @NewInvoiceKey



			-- now perform the grouping by billing item, do not recalc invoice order
			
			if @InvoiceBy = 'Segment' and @AdvanceBilling = 0
			begin
				select @LineKey = -1
				while (1=1)
				begin
					select @LineKey = min(LineKey)
					from   #line
					where  Entity='tCampaignSegment'
					and    LineKey > @LineKey

					if @LineKey is null
						break

					select @NewInvoiceLineKey = InvoiceLineKey from #line where LineKey = @LineKey

					exec sptInvoiceLineGroupFFByBillingItem @NewInvoiceKey, @NewInvoiceLineKey, 0 		
				
				end
			end

			if @InvoiceBy = 'Project' and @AdvanceBilling = 0
			begin
				select @LineKey = -1
				while (1=1)
				begin
					select @LineKey = min(LineKey)
					from   #line
					where  Entity='tProject'
					and    LineKey > @LineKey

					if @LineKey is null
						break

					select @NewInvoiceLineKey = InvoiceLineKey from #line where LineKey = @LineKey

					exec sptInvoiceLineGroupFFByBillingItem @NewInvoiceKey, @NewInvoiceLineKey, 0 		
				
				end
			end


		end

	If ISNULL(@EstimateKey, 0) > 0
		Update tInvoiceLine 
		Set EstimateKey = @EstimateKey
		Where InvoiceKey = @NewInvoiceKey
		
	-- before we leave, recalc the amounts in the header  
	exec sptInvoiceRecalcAmounts @NewInvoiceKey 
	
	-- Calculate the line order and position
	exec sptInvoiceOrder @NewInvoiceKey, 0, 0, 0
	  	
    --select * from #line

	-- now do rollups on projects
	exec sptProjectRollupUpdateEntity 'tInvoice', @NewInvoiceKey, 0, 0
	
	return @NewInvoiceKey
GO
