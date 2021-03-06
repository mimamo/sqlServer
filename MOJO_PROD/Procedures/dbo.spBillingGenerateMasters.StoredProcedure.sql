USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateMasters]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingGenerateMasters]
	@CompanyKey int
	,@UserKey int
	,@DueDate DATETIME
	,@DefaultAsOfDate DATETIME
	,@WMJMode int = 0
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/27/06 CRG 8.35 Modified to get the default ClassKey from tPreference. 
|| 07/06/07 GHL 8.5  Added GLCompanyKey when grouping
|| 04/12/10 GHL 10.521 When grouping by campaign/client, assign contact and approver = Account manager
|| 09/26/11 RLB 10.548 (122103) When grouping by Client pull the Client Default GLCompany and Office
|| 10/11/11 GHL 10.548 Rolledback changes made for 122103
|| 02/08/12 GHL 10.552 (123900) Added @DefaultAsOfDate for WriteOffs, Mark  As Billed and Transfer actions
|| 05/21/12 GHL 10.556 Get the line format from the campaign
|| 05/23/12 GHL 10.556 (144563) If we group by campaign but there was only one project (i.e. no masters)
||                     copy some line format + info from the campaign to the single project
|| 05/23/12 GHL 10.556 Only read tCampaign.OneLinePer if tCampaign.BillBy = 2 By Campaign 
|| 05/30/12 GHL 10.556 (144891) Added pulling of BillingAddressKey from client
|| 07/06/12 GHL 10.557 (148330) Attach the project WS to a master WS if:
||                     - the number of project WS still unattached is > 1
||                     - OR a master WS for the group already exists
||                     this will allow the users to run the billing by campaign several times (1 per project status)
|| 07/10/12 GHL 10.557 Added cleanup of worksheet comment for campaigns, divisions, product because it could be set 
||                     in clients loop and thus be incorrect 
|| 07/17/12 GHL 10.558 Added support of tProject.BillingGroupCode (override of tCompany.OneInvoicePer)
|| 09/26/12 GHL 10.560 Changed BillingGroupCode to BillingGroupKey
|| 01/15/13 MAS 10.564 Added @UserKey param to EXEC sptBillingInsert 
|| 02/13/13 GHL 10.565 (167832) If the project is the only one for a campaign, do not copy the AE from the campaign
|| 05/06/13 MFT 10.567 Added BillingManagerKey override for @Approver
|| 07/03/13 GHL 10.569 Added ThruDate  = null for sptBillingInsert
|| 08/26/13 RLB 10.571 removed BillingManagerKey override
*/

	-- Get a list of orphan (no parent) projects which are not invoiced yet	
	CREATE TABLE #tBilling (BillingKey int null, GroupEntity varchar(50), GroupEntityKey int null
		, GLCompanyKey int null, ClientKey int null, CurrencyID varchar(10) null, CurrencyKey int null)	
	
	INSERT #tBilling (BillingKey, GroupEntity, GroupEntityKey, GLCompanyKey, ClientKey, CurrencyID, CurrencyKey )
	SELECT BillingKey, GroupEntity, GroupEntityKey, ISNULL(GLCompanyKey, 0), ClientKey, CurrencyID, 0
	FROM   tBilling (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    Status < 5						-- not invoiced yet
	AND    ISNULL(AdvanceBill, 0) = 0 		-- Do not include Advanced Billing 
	AND    GroupEntity <> 'Project'			-- When grouped by project, they should be left alone
	AND	   ParentWorksheet = 0				-- Not a Master
	AND    ParentWorksheetKey is null		-- Is orphan
		
	update #tBilling set CurrencyID = null where CurrencyID = ''

	DECLARE @Ret INT
			,@ProjectKey INT
			,@ClientKey INT
			,@BillingKey INT
			,@MasterBillingKey INT
			,@ParentWorksheet TINYINT
			,@GroupEntity VARCHAR(50)
			,@GroupEntityKey INT			
			,@ClassKey INT
			,@WorkSheetComment VARCHAR(4000)
			,@BillingKeyCount INT
			,@GeneratedLabor MONEY
			,@GeneratedExpense MONEY
			,@GLCompanyKey INT
			,@MasterGLCompanyKey INT
			,@ClientLayoutKey INT
			,@LayoutKey INT
			,@PrimaryContactKey INT
			,@Approver INT
			,@DefaultARLineFormat int
			,@BillBy int
			,@BillingAddressKey INT
			,@BillingGroupCode varchar(200)
			,@CurrencyID varchar(10)
			,@CurrencyKey int
		
	-- Possible values for GroupEntity:
	-- BillingGroup
	-- Project		
	-- Client
	-- ParentClient
	-- ClientDivision
	-- ClientProduct
	-- Campaign

	/*
	If we group by Project, we are done
	If we do not group by Project
	Try to find a master billing worksheet 
		which is not approved yet and has the same type of grouping and link to it
	If none, create one
	*/
	
	--Get the DefaultClassKey for the Company
	SELECT	@ClassKey = DefaultClassKey
	FROM	tPreference (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	
	IF (SELECT COUNT(*) FROM #tBilling) = 0 
		RETURN 1
		
	-- Inits
	SELECT @ParentWorksheet = 1
	
	-- We must manufacture CurrencyKey
	-- CurrencyKey initialized at 0 -- Home Currency
	select @CurrencyID = ''
	Select @CurrencyKey = 1
	while (1=1)
	begin
		select @CurrencyID = min(CurrencyID)
		from   #tBilling 
		where  CurrencyID is not null
		and    CurrencyID > @CurrencyID

		if @CurrencyID is null
			break

		update #tBilling
		set    CurrencyKey = @CurrencyKey 
		where  CurrencyID = @CurrencyID

		select @CurrencyKey = @CurrencyKey + 1
	end

	-- By BillingGroupCode (override of tCompany.InvoicePer)
	-- Billing worksheets are grouped by Billing Group Code and by client 
	
	SELECT @GroupEntity = 'BillingGroup'

	SELECT @GroupEntityKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GroupEntityKey = MIN(GroupEntityKey)
		FROM   #tBilling 
		WHERE  GroupEntity = @GroupEntity
		AND    GroupEntityKey >  @GroupEntityKey 

		IF @GroupEntityKey IS NULL
			BREAK

		select @BillingGroupCode = BillingGroupCode
		from   tBillingGroup (nolock)
		where  BillingGroupKey = @GroupEntityKey 

		SELECT @ClientKey = -1 
		WHILE (1=1)
		BEGIN
			SELECT @ClientKey = MIN(ClientKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity = @GroupEntity
			AND    ClientKey > @ClientKey

			IF @ClientKey IS NULL
				BREAK

			SELECT @GLCompanyKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @GLCompanyKey = MIN(GLCompanyKey)
				FROM   #tBilling 
				WHERE  GroupEntityKey = @GroupEntityKey
				AND    GroupEntity    = @GroupEntity
				AND    ClientKey    = @ClientKey
				AND	   GLCompanyKey   >  @GLCompanyKey	
					
				IF @GLCompanyKey IS NULL
					BREAK

	SELECT @CurrencyKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrencyKey = MIN(CurrencyKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey = @GroupEntityKey
		AND    GroupEntity    = @GroupEntity
		AND    ClientKey      = @ClientKey
		AND	   GLCompanyKey   =  @GLCompanyKey	
		AND    CurrencyKey    >  @CurrencyKey
					
		IF @CurrencyKey IS NULL
			BREAK

		select @CurrencyID = CurrencyID from #tBilling
		where  CurrencyKey =  @CurrencyKey -- All currency IDs should have same key

				SELECT @BillingKeyCount = COUNT(BillingKey)
				FROM   #tBilling 
				WHERE  GroupEntity = @GroupEntity
				AND    GroupEntityKey = @GroupEntityKey
				AND    GLCompanyKey = @GLCompanyKey
				AND    ClientKey = @ClientKey
				AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

				SELECT @MasterBillingKey = NULL
				
				SELECT @MasterBillingKey = BillingKey 
				FROM   tBilling (NOLOCK)
				WHERE  CompanyKey = @CompanyKey
				AND    Entity = @GroupEntity
				AND    EntityKey = @GroupEntityKey
				AND	   ParentWorksheet = 1			-- Master
				AND	   Status < 4					-- Not approved yet
				AND    ISNULL(GLCompanyKey, 0) = @GLCompanyKey
				AND    ClientKey = @ClientKey
				AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
	
				IF @BillingKeyCount > 1 Or @MasterBillingKey is not null
				BEGIN
					
					SELECT @WorkSheetComment = 'Master billing worksheet created for customer: '+CustomerID + ' and billing group code ' + @BillingGroupCode
						   ,@ClientLayoutKey = LayoutKey
						   ,@Approver = ISNULL(AccountManagerKey, @UserKey)
						   ,@PrimaryContactKey = PrimaryContact
						   ,@BillingAddressKey = BillingAddressKey
					FROM   tCompany (NOLOCK)
					WHERE  CompanyKey = @ClientKey
				
					IF ISNULL(@Approver, 0) = 0
						SELECT @Approver = @UserKey 
													
					IF @MasterBillingKey IS NULL
					BEGIN
						SELECT @MasterGLCompanyKey = @GLCompanyKey
						IF @MasterGLCompanyKey = 0
							SELECT @MasterGLCompanyKey = NULL	
				
						if @ClientLayoutKey = 0
							select @ClientLayoutKey = null
						
						IF @WMJMode = 0
							select @ClientLayoutKey = null
							
						EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
						,@ParentWorksheet, NULL, @GroupEntity, @GroupEntityKey, NULL, NULL, NULL, NULL, @Approver, 0, null 
						,@DueDate, @DefaultAsOfDate, @PrimaryContactKey, @BillingAddressKey, @MasterGLCompanyKey, NULL, @ClientLayoutKey, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT 

						IF @Ret < 0 
							CONTINUE
								
						IF @MasterBillingKey IS NULL
							CONTINUE
									
					END		

					-- If we have a master, now tie the regular worksheets to it	
					-- Loop through them
					IF @MasterBillingKey IS NOT NULL 
					BEGIN		
						SELECT @BillingKey = -1
						WHILE (1=1)
						BEGIN
							SELECT @BillingKey = MIN(BillingKey)
							FROM   #tBilling 
							WHERE  GroupEntityKey = @GroupEntityKey
							AND    GroupEntity = @GroupEntity
							AND    GLCompanyKey = @GLCompanyKey
							AND    ClientKey = @ClientKey
							AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
							AND    BillingKey > @BillingKey
							
							IF @BillingKey IS NULL
								BREAK

							EXEC sptBillingAddChild @MasterBillingKey, @BillingKey

							EXEC sptBillingRecalcTotals @BillingKey
						
						END	
					
						Select @GeneratedLabor = NULL
							,@GeneratedExpense = NULL
						  
						Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
						Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
					
						Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
						Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

						UPDATE tBilling
						SET    GeneratedLabor = @GeneratedLabor
							,GeneratedExpense = @GeneratedExpense
						WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
				
					END -- @MasterBillingKey not null
				END	-- @BillingKeyCount > 0			
			
			END -- @CurrencyKey loop
		
			END -- @GLCompanyKey loop
		END -- @ClientKey loop 
	
	END -- @GroupEntityKey 

	-- By Client
	SELECT @GroupEntity = 'Client'

	SELECT @GroupEntityKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GroupEntityKey = MIN(GroupEntityKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey > @GroupEntityKey
		AND    GroupEntity = @GroupEntity
		
		IF @GroupEntityKey IS NULL
			BREAK

		SELECT @GLCompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @GLCompanyKey = MIN(GLCompanyKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity    = @GroupEntity
			AND	   GLCompanyKey   >  @GLCompanyKey	
					
			IF @GLCompanyKey IS NULL
				BREAK

		SELECT @CurrencyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CurrencyKey = MIN(CurrencyKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity    = @GroupEntity
			AND	   GLCompanyKey   =  @GLCompanyKey	
			AND    CurrencyKey    >  @CurrencyKey
					
			IF @CurrencyKey IS NULL
				BREAK

			select @CurrencyID = CurrencyID from #tBilling
			where  CurrencyKey =  @CurrencyKey -- All currency IDs should have same key

			SELECT @BillingKeyCount = COUNT(BillingKey)
			FROM   #tBilling 
			WHERE  GroupEntity = @GroupEntity
			AND    GroupEntityKey = @GroupEntityKey
			AND    GLCompanyKey = @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			SELECT @MasterBillingKey = NULL
				
			SELECT @MasterBillingKey = BillingKey 
			FROM   tBilling (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Entity = @GroupEntity
			AND    EntityKey = @GroupEntityKey
			AND	   ParentWorksheet = 1			-- Master
			AND	   Status < 4					-- Not approved yet
			AND    ISNULL(GLCompanyKey, 0) = @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
					
			IF @BillingKeyCount > 1 Or @MasterBillingKey is not null
			BEGIN
					
				SELECT @ClientKey = @GroupEntityKey
				
				SELECT @WorkSheetComment = 'Master billing worksheet created for customer: '+CustomerID
				       ,@ClientLayoutKey = LayoutKey
				       ,@Approver = AccountManagerKey
				       ,@PrimaryContactKey = PrimaryContact
					   ,@BillingAddressKey = BillingAddressKey
				FROM   tCompany (NOLOCK)
				WHERE  CompanyKey = @ClientKey
				
				IF ISNULL(@Approver, 0) = 0
					SELECT @Approver = @UserKey 
													
				IF @MasterBillingKey IS NULL
				BEGIN
					SELECT @MasterGLCompanyKey = @GLCompanyKey
					IF @MasterGLCompanyKey = 0
						SELECT @MasterGLCompanyKey = NULL	
				
					if @ClientLayoutKey = 0
						select @ClientLayoutKey = null
						
					IF @WMJMode = 0
						select @ClientLayoutKey = null
							
					-- Must create one
					EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
					,@ParentWorksheet, NULL, @GroupEntity, @GroupEntityKey, NULL, NULL, NULL, NULL, @Approver, 0 , null
					,@DueDate, @DefaultAsOfDate, @PrimaryContactKey, @BillingAddressKey, @MasterGLCompanyKey, NULL, @ClientLayoutKey, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT 

					IF @Ret < 0 
						CONTINUE
								
					IF @MasterBillingKey IS NULL
						CONTINUE
									
				END		

				-- If we have a master, now tie the regular worksheets to it	
				-- Loop through them
				IF @MasterBillingKey IS NOT NULL 
				BEGIN		
					SELECT @BillingKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @BillingKey = MIN(BillingKey)
						FROM   #tBilling 
						WHERE  GroupEntityKey = @GroupEntityKey
						AND    GroupEntity = @GroupEntity
						AND    GLCompanyKey = @GLCompanyKey
						AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
						AND    BillingKey > @BillingKey
						
						IF @BillingKey IS NULL
							BREAK

						EXEC sptBillingAddChild @MasterBillingKey, @BillingKey

						EXEC sptBillingRecalcTotals @BillingKey
						
					END	
					
					Select @GeneratedLabor = NULL
						,@GeneratedExpense = NULL
						  
					Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
					
					Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

					UPDATE tBilling
					SET    GeneratedLabor = @GeneratedLabor
						,GeneratedExpense = @GeneratedExpense
					WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
				
				END -- @MasterBillingKey not null
			END	-- @BillingKeyCount > 0	
			END -- @CurrencyKey loop		
		END -- @GLCompanyKey loop
	END -- @GroupEntityKey loop 
	
	-- By ParentClient
	SELECT @GroupEntity = 'ParentClient'

	SELECT @GroupEntityKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GroupEntityKey = MIN(GroupEntityKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey > @GroupEntityKey
		AND    GroupEntity = @GroupEntity
		
		IF @GroupEntityKey IS NULL
			BREAK

		SELECT @GLCompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @GLCompanyKey = MIN(GLCompanyKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity    = @GroupEntity
			AND	   GLCompanyKey   >  @GLCompanyKey	
					
			IF @GLCompanyKey IS NULL
				BREAK

			SELECT @CurrencyKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @CurrencyKey = MIN(CurrencyKey)
				FROM   #tBilling 
				WHERE  GroupEntityKey = @GroupEntityKey
				AND    GroupEntity    = @GroupEntity
				AND	   GLCompanyKey   =  @GLCompanyKey	
				AND    CurrencyKey    >  @CurrencyKey
					
				IF @CurrencyKey IS NULL
					BREAK

				select @CurrencyID = CurrencyID from #tBilling
				where  CurrencyKey =  @CurrencyKey -- All currency IDs should have same key

			SELECT @BillingKeyCount = COUNT(BillingKey)
			FROM   #tBilling 
			WHERE  GroupEntity = @GroupEntity
			AND    GroupEntityKey = @GroupEntityKey
			AND	   GLCompanyKey   =  @GLCompanyKey	
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			SELECT @MasterBillingKey = NULL
				
			SELECT @MasterBillingKey = BillingKey 
			FROM   tBilling (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Entity = @GroupEntity
			AND    EntityKey = @GroupEntityKey
			AND	   ParentWorksheet = 1			-- Master
			AND	   Status < 4					-- Not approved yet
			AND	   ISNULL(GLCompanyKey, 0) = @GLCompanyKey	
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			IF @BillingKeyCount > 1 Or @MasterBillingKey is not null
			BEGIN
				SELECT @ClientKey = @GroupEntityKey

				SELECT @WorkSheetComment = 'Master billing worksheet created for customer : '+CustomerID
				       ,@ClientLayoutKey = LayoutKey
				       ,@Approver = AccountManagerKey
				       ,@PrimaryContactKey = PrimaryContact
					   ,@BillingAddressKey = BillingAddressKey
				FROM   tCompany (NOLOCK)
				WHERE  CompanyKey = @ClientKey

				IF ISNULL(@Approver, 0) = 0
					SELECT @Approver = @UserKey 
												
				IF @MasterBillingKey IS NULL
				BEGIN
					-- Must create one
					
					SELECT @MasterGLCompanyKey = @GLCompanyKey
					IF @MasterGLCompanyKey = 0
						SELECT @MasterGLCompanyKey = NULL

					IF @ClientLayoutKey = 0
						SELECT @ClientLayoutKey = NULL

					IF @WMJMode = 0
						select @ClientLayoutKey = null
						
					EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
					, @ParentWorksheet, NULL, @GroupEntity, @GroupEntityKey, NULL, NULL, NULL, NULL, @Approver, 0, null
					, @DueDate, @DefaultAsOfDate, @PrimaryContactKey, @BillingAddressKey, @MasterGLCompanyKey, NULL, @ClientLayoutKey, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT

					IF @Ret < 0 
						CONTINUE
								
					IF @MasterBillingKey IS NULL
						CONTINUE
							
					UPDATE tBilling
					SET	   Entity = @GroupEntity
						  ,EntityKey = @GroupEntityKey
					WHERE  BillingKey = @MasterBillingKey		

				END		

				-- If we have a master, now tie the regular worksheets to it	
				-- Loop through them
				IF @MasterBillingKey IS NOT NULL
				BEGIN		
					SELECT @BillingKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @BillingKey = MIN(BillingKey)
						FROM   #tBilling 
						WHERE  GroupEntityKey = @GroupEntityKey
						AND    GroupEntity = @GroupEntity
						AND    GLCompanyKey = @GLCompanyKey
						AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
						AND    BillingKey > @BillingKey
						
						IF @BillingKey IS NULL
							BREAK

						EXEC sptBillingAddChild @MasterBillingKey, @BillingKey

						EXEC sptBillingRecalcTotals @BillingKey

					END
					
					Select @GeneratedLabor = NULL
						,@GeneratedExpense = NULL

					Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
					
					Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

					UPDATE tBilling
					SET    GeneratedLabor = @GeneratedLabor
						,GeneratedExpense = @GeneratedExpense
					WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
		
				END -- @MasterBillingKey not null
			END	-- @BillingKeyCount > 0	
			END -- @CurrencyKey loop							
		END -- @GLCompanyKey loop
	END -- @GroupEntityKey loop

	-- By Client Product
	SELECT @GroupEntity = 'Product'

	SELECT @GroupEntityKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GroupEntityKey = MIN(GroupEntityKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey > @GroupEntityKey
		AND    GroupEntity = @GroupEntity
		
		IF @GroupEntityKey IS NULL
			BREAK

		SELECT @GLCompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @GLCompanyKey = MIN(GLCompanyKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity    = @GroupEntity
			AND	   GLCompanyKey   >  @GLCompanyKey	
					
			IF @GLCompanyKey IS NULL
				BREAK

			SELECT @CurrencyKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @CurrencyKey = MIN(CurrencyKey)
				FROM   #tBilling 
				WHERE  GroupEntityKey = @GroupEntityKey
				AND    GroupEntity    = @GroupEntity
				AND	   GLCompanyKey   =  @GLCompanyKey	
				AND    CurrencyKey    >  @CurrencyKey
					
				IF @CurrencyKey IS NULL
					BREAK

				select @CurrencyID = CurrencyID from #tBilling
				where  CurrencyKey =  @CurrencyKey -- All currency IDs should have same key

			SELECT @BillingKeyCount = COUNT(BillingKey)
			FROM   #tBilling 
			WHERE  GroupEntity = @GroupEntity
			AND    GroupEntityKey = @GroupEntityKey
			AND    GLCompanyKey = @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			SELECT @MasterBillingKey = NULL
				
			SELECT @MasterBillingKey = BillingKey 
			FROM   tBilling (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND	   Entity = @GroupEntity
			AND    EntityKey = @GroupEntityKey
			AND	   ParentWorksheet = 1			-- Master
			AND	   Status < 4					-- Not approved yet
			AND    ISNULL(GLCompanyKey, 0) = @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			IF @BillingKeyCount > 1 Or @MasterBillingKey is not null
			BEGIN
			
				SELECT @ClientKey = ClientKey
				      ,@WorkSheetComment = null -- 7/10/12 GHL cleanup because it could have been set in other loop 
					--,@WorkSheetComment = 'Master billing worksheet generated for product: '+ProductName
				FROM   tClientProduct (NOLOCK)
				WHERE  ClientProductKey = @GroupEntityKey
				
				SELECT @ClientLayoutKey = LayoutKey
				       ,@Approver = AccountManagerKey
				       ,@PrimaryContactKey = PrimaryContact
					   ,@BillingAddressKey = BillingAddressKey
				FROM   tCompany (NOLOCK)
				WHERE  CompanyKey = @ClientKey
										
				IF @MasterBillingKey IS NULL 
				BEGIN
					-- Must create one
					
					SELECT @MasterGLCompanyKey = @GLCompanyKey
					IF @MasterGLCompanyKey = 0
						SELECT @MasterGLCompanyKey = NULL
						
					IF @ClientLayoutKey = 0
						SELECT @ClientLayoutKey = null

					IF @WMJMode = 0
						select @ClientLayoutKey = null
							
					EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
					, @ParentWorksheet, NULL, @GroupEntity, @GroupEntityKey, NULL, NULL, NULL, NULL, @Approver, 0, null
					, @DueDate, @DefaultAsOfDate, @PrimaryContactKey, @BillingAddressKey, @MasterGLCompanyKey, NULL, @ClientLayoutKey, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT

					IF @Ret < 0 
						CONTINUE
								
					IF @MasterBillingKey IS NULL
						CONTINUE
							
					UPDATE tBilling
					SET	  Entity = @GroupEntity
						,EntityKey = @GroupEntityKey
					WHERE  BillingKey = @MasterBillingKey		

				END		

				-- If we have a master, now tie the regular worksheets to it	
				-- Loop through them
				IF @MasterBillingKey IS NOT NULL
				BEGIN		
					SELECT @BillingKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @BillingKey = MIN(BillingKey)
						FROM   #tBilling 
						WHERE  GroupEntityKey = @GroupEntityKey
						AND    GroupEntity = @GroupEntity
						AND    GLCompanyKey = @GLCompanyKey
						AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
						AND    BillingKey > @BillingKey
						
						IF @BillingKey IS NULL
							BREAK

						EXEC sptBillingAddChild @MasterBillingKey, @BillingKey

						EXEC sptBillingRecalcTotals @BillingKey

					END

					Select @GeneratedLabor = NULL
						,@GeneratedExpense = NULL
					
					Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
					
					Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

					Select @GeneratedLabor = ISNULL(@GeneratedLabor, 0)
						,@GeneratedExpense = ISNULL(@GeneratedExpense, 0)

					UPDATE tBilling
					SET    GeneratedLabor = @GeneratedLabor
						,GeneratedExpense = @GeneratedExpense
					WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
		
				END	-- @MasterBillingKey not null
			END	-- @BillingKeyCount > 0	
			END -- @CurrencyKey loop					
		END -- @GLCompanyKey loop
	END -- @GroupEntityKey loop
	
	-- By Client Division
	SELECT @GroupEntity = 'Division'

	SELECT @GroupEntityKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GroupEntityKey = MIN(GroupEntityKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey > @GroupEntityKey
		AND    GroupEntity = @GroupEntity
		
		IF @GroupEntityKey IS NULL
			BREAK

		SELECT @GLCompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @GLCompanyKey = MIN(GLCompanyKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity    = @GroupEntity
			AND	   GLCompanyKey   >  @GLCompanyKey	
					
			IF @GLCompanyKey IS NULL
				BREAK
				
			SELECT @CurrencyKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @CurrencyKey = MIN(CurrencyKey)
				FROM   #tBilling 
				WHERE  GroupEntityKey = @GroupEntityKey
				AND    GroupEntity    = @GroupEntity
				AND	   GLCompanyKey   =  @GLCompanyKey	
				AND    CurrencyKey    >  @CurrencyKey
					
				IF @CurrencyKey IS NULL
					BREAK

				select @CurrencyID = CurrencyID from #tBilling
				where  CurrencyKey =  @CurrencyKey -- All currency IDs should have same key

			SELECT @BillingKeyCount = COUNT(BillingKey)
			FROM   #tBilling 
			WHERE  GroupEntity = @GroupEntity
			AND    GroupEntityKey = @GroupEntityKey
			AND	   GLCompanyKey   =  @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			SELECT @MasterBillingKey = NULL
				
			SELECT @MasterBillingKey = BillingKey 
			FROM   tBilling (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Entity = @GroupEntity
			AND	   EntityKey = @GroupEntityKey
			AND	   ParentWorksheet = 1			-- Master
			AND	   Status < 4					-- Not approved yet
			AND    ISNULL(GLCompanyKey, 0) = @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			IF @BillingKeyCount > 1 Or @MasterBillingKey is not null
			BEGIN
			
				SELECT @ClientKey = ClientKey
					  ,@WorkSheetComment = null -- 7/10/12 GHL cleanup because it could have been set in other loop 
					--,@WorkSheetComment = 'Master billing worksheet generated for division: '+DivisionName
				FROM   tClientDivision (NOLOCK)
				WHERE  ClientDivisionKey = @GroupEntityKey
				
				SELECT @ClientLayoutKey = LayoutKey
				       ,@Approver = AccountManagerKey
				       ,@PrimaryContactKey = PrimaryContact
					   ,@BillingAddressKey = BillingAddressKey
				FROM   tCompany (NOLOCK)
				WHERE  CompanyKey = @ClientKey
				
									
				IF @MasterBillingKey IS NULL 
				BEGIN
					-- Must create one
					
					SELECT @MasterGLCompanyKey = @GLCompanyKey
					IF @MasterGLCompanyKey = 0
						SELECT @MasterGLCompanyKey = NULL
					
					IF @ClientLayoutKey = 0
						SELECT @ClientLayoutKey = NULL

					IF @WMJMode = 0
						select @ClientLayoutKey = null
							
					EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
					, @ParentWorksheet, NULL, @GroupEntity, @GroupEntityKey, NULL, NULL, NULL, NULL, @Approver, 0, null
					, @DueDate, @DefaultAsOfDate, @PrimaryContactKey, @BillingAddressKey, @MasterGLCompanyKey, NULL, @ClientLayoutKey, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT

					IF @Ret < 0 
						CONTINUE
								
					IF @MasterBillingKey IS NULL
						CONTINUE
							
					UPDATE tBilling
					SET	  Entity = @GroupEntity
						,EntityKey = @GroupEntityKey
					WHERE  BillingKey = @MasterBillingKey		

				END		

				-- If we have a master, now tie the regular worksheets to it	
				-- Loop through them
				IF @MasterBillingKey IS NOT NULL
				BEGIN		
					SELECT @BillingKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @BillingKey = MIN(BillingKey)
						FROM   #tBilling 
						WHERE  GroupEntityKey = @GroupEntityKey
						AND    GroupEntity = @GroupEntity
						AND    BillingKey > @BillingKey
						AND    GLCompanyKey = @GLCompanyKey
						AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

						IF @BillingKey IS NULL
							BREAK

						EXEC sptBillingAddChild @MasterBillingKey, @BillingKey

						EXEC sptBillingRecalcTotals @BillingKey

					END
					
					Select @GeneratedLabor = NULL
						,@GeneratedExpense = NULL

					Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
					
					Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

					Select @GeneratedLabor = ISNULL(@GeneratedLabor, 0)
						,@GeneratedExpense = ISNULL(@GeneratedExpense, 0)

					UPDATE tBilling
					SET    GeneratedLabor = @GeneratedLabor
						,GeneratedExpense = @GeneratedExpense
					WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
		
				END	-- @MasterBillingKey not null
			END	-- @BillingKeyCount > 0		
			END -- @CurrencyKey loop
		END -- @GLCompanyKey loop					
	END -- @GroupEntityKey loop

	-- By Campaign
	SELECT @GroupEntity = 'Campaign'

	SELECT @GroupEntityKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @GroupEntityKey = MIN(GroupEntityKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey > @GroupEntityKey
		AND    GroupEntity = @GroupEntity
		
		IF @GroupEntityKey IS NULL
			BREAK

		SELECT @GLCompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @GLCompanyKey = MIN(GLCompanyKey)
			FROM   #tBilling 
			WHERE  GroupEntityKey = @GroupEntityKey
			AND    GroupEntity    = @GroupEntity
			AND	   GLCompanyKey   >  @GLCompanyKey	
					
			IF @GLCompanyKey IS NULL
				BREAK
	
	SELECT @CurrencyKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrencyKey = MIN(CurrencyKey)
		FROM   #tBilling 
		WHERE  GroupEntityKey = @GroupEntityKey
		AND    GroupEntity    = @GroupEntity
		AND	   GLCompanyKey   =  @GLCompanyKey	
		AND    CurrencyKey    >  @CurrencyKey
					
		IF @CurrencyKey IS NULL
			BREAK

		select @CurrencyID = CurrencyID from #tBilling
		where  CurrencyKey =  @CurrencyKey -- All currency IDs should have same key
				
			SELECT @ClientKey = ClientKey
			       ,@WorkSheetComment = null -- 7/10/12 GHL cleanup because it could have been set in other loop 
				  --,@WorkSheetComment = 'Master billing worksheet generated for campaign: '+CampaignName
					,@LayoutKey = LayoutKey
					,@Approver = AEKey
					,@PrimaryContactKey = ContactKey
					,@DefaultARLineFormat = OneLinePer
					,@BillBy = isnull(BillBy, 1)
			FROM   tCampaign (NOLOCK)
			WHERE  CampaignKey = @GroupEntityKey
				
			-- If we bill by project, get line format from client	
			IF @BillBy = 1
				select @DefaultARLineFormat = null

			IF ISNULL(@Approver, 0) = 0
				SELECT @Approver = @UserKey 

			SELECT @ClientLayoutKey = LayoutKey
			      ,@BillingAddressKey = BillingAddressKey
			FROM   tCompany (NOLOCK)
			WHERE  CompanyKey = @ClientKey

			-- How many are waiting to be grouped?
			SELECT @BillingKeyCount = COUNT(BillingKey)
			FROM   #tBilling 
			WHERE  GroupEntity = @GroupEntity
			AND    GroupEntityKey = @GroupEntityKey
			AND	   GLCompanyKey   =  @GLCompanyKey	
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 

			-- Is there already a group?
			SELECT @MasterBillingKey = NULL
				
			SELECT @MasterBillingKey = BillingKey 
			FROM   tBilling (NOLOCK)
			WHERE  CompanyKey = @CompanyKey
			AND    Entity = @GroupEntity
			AND    EntityKey = @GroupEntityKey
			AND	   ParentWorksheet = 1			-- Master
			AND	   Status < 4					-- Not approved yet
			AND    ISNULL(GLCompanyKey, 0) = @GLCompanyKey
			AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
				
			-- If we have several projects to group OR the group already exists
			-- add the project(s) to the group
			IF @BillingKeyCount > 1 Or @MasterBillingKey IS NOT NULL
			BEGIN						
				IF @MasterBillingKey IS NULL
				BEGIN
					-- Must create one
					
					SELECT @MasterGLCompanyKey = @GLCompanyKey
					IF @MasterGLCompanyKey = 0
						SELECT @MasterGLCompanyKey = NULL	

					IF ISNULL(@LayoutKey, 0) = 0
						SELECT @LayoutKey = @ClientLayoutKey
						
					IF @LayoutKey = 0
						SELECT @LayoutKey = NULL

					IF @WMJMode = 0
						select @LayoutKey = null

											
					EXEC @Ret = sptBillingInsert @CompanyKey, @ClientKey, NULL, @ClassKey, 0, @WorkSheetComment, NULL
					, @ParentWorksheet, NULL, @GroupEntity, @GroupEntityKey, NULL, NULL, NULL, NULL, @Approver, 0, null
					, @DueDate, @DefaultAsOfDate, @PrimaryContactKey, @BillingAddressKey, @MasterGLCompanyKey, NULL, @LayoutKey, @UserKey, @CurrencyID, @MasterBillingKey OUTPUT

					IF @Ret < 0 
						CONTINUE
								
					IF @MasterBillingKey IS NULL
						CONTINUE
							
					UPDATE tBilling
					SET	  Entity = @GroupEntity
						,EntityKey = @GroupEntityKey
                        ,DefaultARLineFormat = 
								case 
									-- if the OneLinePer from the campaign is not null, then set it
						            when @DefaultARLineFormat is not null then @DefaultARLineFormat
									-- else keep the one from the client 
									else DefaultARLineFormat 
								end
					WHERE  BillingKey = @MasterBillingKey		

				END		

				-- If we have a master, now tie the regular worksheets to it	
				-- Loop through them
				IF @MasterBillingKey IS NOT NULL
				BEGIN		
					SELECT @BillingKey = -1
					WHILE (1=1)
					BEGIN
						SELECT @BillingKey = MIN(BillingKey)
						FROM   #tBilling 
						WHERE  GroupEntityKey = @GroupEntityKey
						AND    GroupEntity = @GroupEntity
						AND    GLCompanyKey = @GLCompanyKey
						AND    isnull(CurrencyID, '') = isnull(@CurrencyID, '') 
						AND    BillingKey > @BillingKey
						
						IF @BillingKey IS NULL
							BREAK

						EXEC sptBillingAddChild @MasterBillingKey, @BillingKey

						EXEC sptBillingRecalcTotals @BillingKey

					END
					
					Select @GeneratedLabor = NULL
						,@GeneratedExpense = NULL

					Select @GeneratedLabor = Sum(GeneratedLabor) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey
					
					Select @GeneratedExpense = Sum(GeneratedExpense) from tBilling (nolock) 
					Where ParentWorksheetKey = @MasterBillingKey And CompanyKey = @CompanyKey

					Select @GeneratedLabor = ISNULL(@GeneratedLabor, 0)
						,@GeneratedExpense = ISNULL(@GeneratedExpense, 0)

					UPDATE tBilling
					SET    GeneratedLabor = @GeneratedLabor
						,GeneratedExpense = @GeneratedExpense
					WHERE  BillingKey = @MasterBillingKey And CompanyKey = @CompanyKey	  
		
				END -- @MasterBillingKey not null
			END	-- @BillingKeyCount > 1
			ELSE
			BEGIN
				-- @BillingKeyCount	<= 1 AND Not exists a master for the group
				-- If we have 1 single project, copy some settings from the campaign to the project
				
				IF @LayoutKey = 0
					SELECT @LayoutKey = NULL

				IF @WMJMode = 0
					select @LayoutKey = null

				update tBilling
				set    tBilling.DefaultARLineFormat = 
								case 
									-- if the OneLinePer from the campaign is not null, then set it
									when @DefaultARLineFormat is not null then @DefaultARLineFormat
									-- else keep the one from the project 
									else tBilling.DefaultARLineFormat 
								end
						--,tBilling.Approver =@Approver
						,tBilling.LayoutKey = 
								case 
									when @LayoutKey is not null then @LayoutKey
									else tBilling.LayoutKey 
								end
						--,tBilling.PrimaryContactKey = @PrimaryContactKey
				from   #tBilling b
				WHERE  b.GroupEntityKey = @GroupEntityKey
				AND    b.GroupEntity = @GroupEntity
				AND    b.GLCompanyKey = @GLCompanyKey
				AND    b.BillingKey = tBilling.BillingKey 
				AND    isnull(b.CurrencyID, '') = isnull(@CurrencyID, '') 
			END	
			END -- @CurrencyKey loop	
		END -- @GLCompanyKey loop						
	END	-- @GroupEntityKey loop	
										
	RETURN 1
GO
