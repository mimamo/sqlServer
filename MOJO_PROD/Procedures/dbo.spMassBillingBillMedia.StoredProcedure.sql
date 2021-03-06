USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingBillMedia]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMassBillingBillMedia]
	 @UserKey int,
	 @InvoiceBy int,
	 @Rollup int,
	 @PercentOfActual decimal(15,8),
	 @InvoiceDate smalldatetime,
	 @PostingDate smalldatetime,
	 @DefaultClassKey INT = NULL,	-- This is already validated on the screen for all InvoiceBy types
	 @DefaultOfficeKey INT = NULL,	-- This is already validated on the screen when by client/client parent
	 @CreateAsApproved INT = 0
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/23/07 GHL 8.4   Added Project Rollup sections
  || 05/03/07 GHL 8.4.2.1 Added ClassKey for Partners Napier 
  || 07/03/07 GHL 8.5   Added logic for GLCompanyKey and OfficeKey   
  || 04/08/08 GHL 8.508 (23712) Added new logic for classes 
  || 10/30/09 GHL 10.513 (66720) Added return with error when GLCompanyKey NULL and Required
  || 04/01/11 RLB 10.542 (107714) Added a check when invoicing by Estimate that there is a media estimate 
  || 04/26/12 GHL 10.555 (141647) Added CreateAsApproved param  
  || 10/04/13 GHL 10.573 Added support for multi currency
  */
  
	-- Note: Simulate code in WIP page before calling spProcessWIPWorksheet

declare @RetVal int
declare @ProjectKey int
declare @MediaEstimateKey int
declare @ClientKey int
declare @ParentCompanyKey int
declare @GLCompanyKey int
declare @OfficeKey int
declare @ClassKey int
declare @CreateInvoice int

	DECLARE @CompanyKey int, @UseGLCompany int, @RequireGLCompany int, @RetValue int

	SELECT @RetValue = 1
	

	SELECT @CompanyKey = CompanyKey
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey
			
	SELECT @UseGLCompany = ISNULL(UseGLCompany, 0), @RequireGLCompany = ISNULL(RequireGLCompany, 0)
	FROM tPreference (NOLOCK)
	WHERE CompanyKey = @CompanyKey			
 
 	DECLARE @CurrencyID varchar(10), @CurrencyKey int

	-- We must manufacture CurrencyKey to use in the loops
	-- CurrencyKey initialized at 0 -- Home Currency
	update #tMediaMassBillingDetail set CurrencyID = null where CurrencyID = ''
	update #tMediaMassBillingDetail set CurrencyKey = 0

	select @CurrencyID = ''
	Select @CurrencyKey = 1
	while (1=1)
	begin
		select @CurrencyID = min(CurrencyID)
		from   #tMediaMassBillingDetail
		where  CurrencyID is not null
		and    CurrencyID > @CurrencyID

		if @CurrencyID is null
			break

		update #tMediaMassBillingDetail
		set    CurrencyKey = @CurrencyKey 
		where  CurrencyID = @CurrencyID

		select @CurrencyKey = @CurrencyKey + 1
	end


    -- by project
	if @InvoiceBy = 0
	  begin
		  select @ProjectKey = -1
	      while (1=1)
		  begin
			  select @ProjectKey = min(m.ProjectKey)
				from (select distinct ProjectKey
				        from #tMediaMassBillingDetail)
				          as m
			   where ProjectKey > @ProjectKey
							     
			  if @ProjectKey is null
			      break
				     
			  truncate table #tProcWIPKeys
			  
			  insert #tProcWIPKeys (ClientKey, ProjectKey, MediaEstimateKey, EntityType, EntityKey, Action)
              select ClientKey, ProjectKey, MediaEstimateKey, Entity, cast(EntityKey as VARCHAR(50)), 1
                from #tMediaMassBillingDetail
               where ProjectKey = @ProjectKey
				 
			  SELECT @GLCompanyKey = GLCompanyKey
					,@OfficeKey = OfficeKey
					,@ClassKey = ClassKey
			  FROM   tProject (NOLOCK)
			  WHERE  ProjectKey = @ProjectKey 	 
			  IF @GLCompanyKey = 0 
				SELECT @GLCompanyKey = NULL	 
			  IF @OfficeKey = 0 
				SELECT @OfficeKey = NULL	 
			
			  SELECT @CreateInvoice = 1	
			  IF @GLCompanyKey IS NULL AND @UseGLCompany = 1 AND @RequireGLCompany = 1
				SELECT @CreateInvoice = 0
				
			  IF @CreateInvoice = 1
			  BEGIN		
				-- SP spProcessWIPWorksheet will extract currency
				exec @RetVal = spProcessWIPWorksheet @ProjectKey ,@InvoiceBy, @Rollup, @UserKey, NULL, 
				@PercentOfActual, @InvoiceDate, @PostingDate, @DefaultClassKey, @ClassKey, @GLCompanyKey, @OfficeKey, @CreateAsApproved
				  
				if @RetVal < 1
					return @RetVal
		
				-- If positive, this is an invoice key, not an error	
				IF @RetVal > 0
					EXEC sptProjectRollupUpdateEntity 'tInvoice', @RetVal
			  END
			  	
		  end    
      end

	-- by client
	if @InvoiceBy = 1 
	    begin
		    select @ClientKey = -1
	        while (1=1)
		    begin
			    select @ClientKey = min(ClientKey)
				  from (select distinct ClientKey
				        from #tMediaMassBillingDetail)
				          as m
				 where ClientKey > @ClientKey
				     
				 if @ClientKey is null
				     break
			
				select @GLCompanyKey = -1
				while (1=1)
				begin	
					select @GLCompanyKey = min(GLCompanyKey)
						from (select distinct GLCompanyKey
							from #tMediaMassBillingDetail
							where ClientKey = @ClientKey)
							as m
						where GLCompanyKey > @GLCompanyKey 
						    
					if @GLCompanyKey is null
						break
						
					SELECT @CurrencyKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @CurrencyKey = MIN(CurrencyKey)
						FROM   #tMediaMassBillingDetail 
						WHERE  ClientKey = @ClientKey
						AND    GLCompanyKey   =  @GLCompanyKey	
						AND    CurrencyKey    >  @CurrencyKey
					
						IF @CurrencyKey IS NULL
							BREAK

						select @CurrencyID = CurrencyID from #tMediaMassBillingDetail
						where  CurrencyKey =  @CurrencyKey -- All separate currency IDs should have same key

						truncate table #tProcWIPKeys
			   
						insert #tProcWIPKeys (ClientKey, ProjectKey, MediaEstimateKey, EntityType, EntityKey, Action)
						select ClientKey, ProjectKey, MediaEstimateKey, Entity, cast(EntityKey as VARCHAR(50)), 1
						from #tMediaMassBillingDetail
						where ClientKey = @ClientKey
						and GLCompanyKey = @GLCompanyKey
						and CurrencyKey =  @CurrencyKey

						if @GLCompanyKey = 0
							select @GLCompanyKey = NULL
			
						SELECT @CreateInvoice = 1	
						IF @GLCompanyKey IS NULL AND @UseGLCompany = 1 AND @RequireGLCompany = 1
						BEGIN
							SELECT @CreateInvoice = 0
							RETURN -1000 -- Added this because of silent failure causes issues with users
						END
				
						IF @CreateInvoice = 1
						BEGIN						 
							exec @RetVal = spProcessWIPWorksheet @ClientKey ,@InvoiceBy, @Rollup, @UserKey, NULL, 
							@PercentOfActual, @InvoiceDate, @PostingDate, @DefaultClassKey, NULL, @GLCompanyKey, @DefaultOfficeKey, @CreateAsApproved, NULL, @CurrencyID
						
							if @RetVal < 1
								return @RetVal
		                     
							-- If positive, this is an invoice key, not an error	
							IF @RetVal > 0
								EXEC sptProjectRollupUpdateEntity 'tInvoice', @RetVal
						END
				
						-- to continue our loop
						select @GLCompanyKey = ISNULL(@GLCompanyKey, 0)
					
					end -- Currency loop

					-- to continue our loop
					select @GLCompanyKey = ISNULL(@GLCompanyKey, 0)
										
				end -- GLCompany loop
					     	 
			end -- Client loop
			
		end -- InvoiceBy = Client      
		
	-- by client parent
	if @InvoiceBy = 2 
	    begin
			update #tMediaMassBillingDetail
			   set #tMediaMassBillingDetail.ParentCompanyKey = 
					case 
					    when c.ParentCompanyKey is null then c.CompanyKey	
						when c.ParentCompanyKey = 0 then c.CompanyKey
				        else c.ParentCompanyKey			   
					end
			  from tCompany c (nolock)
			 where c.CompanyKey = #tMediaMassBillingDetail.ClientKey
			 
		    select @ParentCompanyKey = -1
	        while (1=1)
		    begin
			    select @ParentCompanyKey = min(ParentCompanyKey)
				  from (select distinct ParentCompanyKey
				        from #tMediaMassBillingDetail)
				          as m
				 where ParentCompanyKey > @ParentCompanyKey
				     
				 if @ParentCompanyKey is null
				     break

				select @GLCompanyKey = -1
				while (1=1)
				begin	
					select @GLCompanyKey = min(GLCompanyKey)
						from (select distinct GLCompanyKey
							from #tMediaMassBillingDetail
							where ParentCompanyKey = @ParentCompanyKey)
							as m
						where GLCompanyKey > @GLCompanyKey 
						    
					if @GLCompanyKey is null
						break

					SELECT @CurrencyKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @CurrencyKey = MIN(CurrencyKey)
						FROM   #tMediaMassBillingDetail 
						WHERE  ParentCompanyKey = @ParentCompanyKey
						AND    GLCompanyKey   =  @GLCompanyKey	
						AND    CurrencyKey    >  @CurrencyKey
					
						IF @CurrencyKey IS NULL
							BREAK

						select @CurrencyID = CurrencyID from #tMediaMassBillingDetail
						where  CurrencyKey =  @CurrencyKey -- All separate currency IDs should have same key
				     
						truncate table #tProcWIPKeys
				  
						insert #tProcWIPKeys (ClientKey, ProjectKey, MediaEstimateKey, EntityType, EntityKey, Action)
						select ClientKey, ProjectKey, MediaEstimateKey, Entity, cast(EntityKey as VARCHAR(50)), 1
						from #tMediaMassBillingDetail
						where ParentCompanyKey = @ParentCompanyKey
						and GLCompanyKey = @GLCompanyKey
						and CurrencyKey = @CurrencyKey
						 
						if @GLCompanyKey = 0
							select @GLCompanyKey = NULL
					
						SELECT @CreateInvoice = 1	
						IF @GLCompanyKey IS NULL AND @UseGLCompany = 1 AND @RequireGLCompany = 1
						BEGIN
							SELECT @CreateInvoice = 0
							RETURN -1000 -- Added this because of silent failure causes issues with users
						END
				
						IF @CreateInvoice = 1
						BEGIN	 
							exec @RetVal = spProcessWIPWorksheet @ParentCompanyKey ,@InvoiceBy, @Rollup, @UserKey, NULL, 
							@PercentOfActual, @InvoiceDate, @PostingDate, @DefaultClassKey, NULL, @GLCompanyKey, @DefaultOfficeKey, @CreateAsApproved, NULL, @CurrencyID
						
							if @RetVal < 1
								return @RetVal
		                     
							-- If positive, this is an invoice key, not an error	
							IF @RetVal > 0
								EXEC sptProjectRollupUpdateEntity 'tInvoice', @RetVal
						END
				
						-- to continue our loop
						select @GLCompanyKey = ISNULL(@GLCompanyKey, 0)
										
					end -- Currency loop
	
					-- to continue our loop
					select @GLCompanyKey = ISNULL(@GLCompanyKey, 0)
										
				end -- Company loop
					    
			end -- Client Parent loop
			   
		end -- InvoiceBy Client Parent     

	-- by estimate
	if @InvoiceBy = 3 
	    begin
			if exists(Select 1 from #tMediaMassBillingDetail (nolock) where ISNULL(#tMediaMassBillingDetail.MediaEstimateKey, 0) = 0)
			BEGIN
				select @RetValue = 2
			END

		    select @MediaEstimateKey = -1
	        while (1=1)
		    begin
			    select @MediaEstimateKey = min(MediaEstimateKey)
				  from (select distinct MediaEstimateKey
				        from #tMediaMassBillingDetail)
				          as m
				 where MediaEstimateKey > @MediaEstimateKey
				     
				 if @MediaEstimateKey is null
				     break
				     
				SELECT @CurrencyKey = -1
				WHILE (1=1)
				BEGIN
					SELECT @CurrencyKey = MIN(CurrencyKey)
					FROM   #tMediaMassBillingDetail 
					WHERE  MediaEstimateKey = @MediaEstimateKey
					AND    CurrencyKey    >  @CurrencyKey
					
					IF @CurrencyKey IS NULL
						BREAK

					select @CurrencyID = CurrencyID from #tMediaMassBillingDetail
					where  CurrencyKey =  @CurrencyKey -- All separate currency IDs should have same key

						truncate table #tProcWIPKeys
			  
						insert #tProcWIPKeys (ClientKey, ProjectKey, MediaEstimateKey, EntityType, EntityKey, Action)
						select ClientKey, ProjectKey, MediaEstimateKey, Entity, cast(EntityKey as VARCHAR(50)), 1
						from #tMediaMassBillingDetail
						where MediaEstimateKey = @MediaEstimateKey
						AND    CurrencyKey   =  @CurrencyKey
					

					SELECT @GLCompanyKey = GLCompanyKey
							,@OfficeKey = OfficeKey
							,@ClassKey = ClassKey
					FROM   tMediaEstimate (NOLOCK)
					WHERE  MediaEstimateKey = @MediaEstimateKey
				 	 
					IF @GLCompanyKey = 0 
						SELECT @GLCompanyKey = NULL	 
					IF @OfficeKey = 0 
						SELECT @OfficeKey = NULL	 
				
						SELECT @CreateInvoice = 1	
					IF @GLCompanyKey IS NULL AND @UseGLCompany = 1 AND @RequireGLCompany = 1
					BEGIN
						SELECT @CreateInvoice = 0
						RETURN -1000 -- Added this because of silent failure causes issues with users
					END
					
					IF @CreateInvoice = 1
					BEGIN			 
						exec @RetVal = spProcessWIPWorksheet @MediaEstimateKey ,@InvoiceBy, @Rollup, @UserKey, NULL, 
						@PercentOfActual, @InvoiceDate, @PostingDate, @DefaultClassKey, @ClassKey, @GLCompanyKey, @OfficeKey, @CreateAsApproved
					
						if @RetVal < 1
							return @RetVal

						-- If positive, this is an invoice key, not an error	
						IF @RetVal > 0
						EXEC sptProjectRollupUpdateEntity 'tInvoice', @RetVal
					END
				                    
				end -- currency loop

			end   -- media estimate loop
			 
		end -- invoice by media estimate
				
	return @RetValue
GO
