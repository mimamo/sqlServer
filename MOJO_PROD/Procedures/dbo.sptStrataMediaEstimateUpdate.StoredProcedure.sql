USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataMediaEstimateUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataMediaEstimateUpdate]
(
	@OwnerCompanyKey int,
	@MediaEstimateKey int,
	@LinkID varchar(50),
	@ClientID varchar(50),
	@EstimateID varchar(50),
	@EstimateName varchar(200),
	@FlightStartDate smalldatetime,
	@FlightEndDate smalldatetime,
	@ProjectNumber varchar(100),
	@TaskID varchar(50),
	@EstimateType varchar(2),
	@ClassID varchar(50),
	@ClientProductLinkID varchar(100),
	@ClientProductName varchar(300),
	@ClientDivisionLinkID varchar(100),
	@ClientDivisionName varchar(300),
	@GLCompanyID varchar(50),
	@OfficeID varchar(50)
)

as --Encrypt

/*
|| When     Who Rel     What
|| 11/16/06 CRG 8.3571  Added ClassID parameter.
|| 12/19/06 RTC 8.4001  Added validation to prevent a Strata estimate from being inserted when a 
||                      manual estimate has been entered with the same estimate id.
|| 05/04/07	RTC	8.4.2.1 (9124) Added the automatic syncing and setting of client divisions and products on media estimates BC & IO.
|| 09/28/07 BSH 8.5     (9160) Updates for 8.5, GLCompanyID, OfficeID added.
|| 03/19/09 RTC 10.0.2.1 (48709) Relaxed restriction for updating Project, GLCompany, Office by only counting lines that have
||                       been pre-billed or have a vendor invoice applied against them, otherwise allow update.
|| 05/13/09 RTC 10.0.2.4 (52751) Project number is now validated regardless of the link to client system option.
||						 If a Strata estimate has a project specified, it must be valid.
|| 05/13/09 RTC 10.0.2.5 Project number is now updated for existing estimates
|| 05/24/11 MAS 10.0.4.4 (109450)Relax restriction on validating the Project Number.  Now only verify that the Project Number passed in
||	                     is valid unless we actually update something on the media estimate.  then we check the Project's ExpenseActive flag
||                       We'll then validate the status of individual lines if/when we need to perform an update on the line
|| 09/12/12 MAS 10.5.6.0 Added DFA changes
|| 04/15/13 MAS 10.5.6.7 (173150)Use the Client's PreBill Option if set, otherwise use the Company PreBill settings
|| 07/31/13 MAS 10.5.7.0 (184988)Allow users to update MediaEstimate, Purchase Order and Voucher header lines with the ProjectKey if it's not populated
*/

Declare @ClientKey int
Declare @IOOrderDisplayMode int
Declare @BCOrderDisplayMode int
Declare @ProjectKey int, @TaskKey int, @ClassKey int, @GLCompanyKey int, @OfficeKey int
declare @IOClientLink smallint
declare @BCClientLink smallint
declare @RequireTasks tinyint
declare @RequireClasses tinyint
declare @DFAEstimate tinyint
declare @RequireGLCompany tinyint
declare @RequireOffice tinyint
declare @LineCount int
declare @CurrentGLCKey int
declare @CurrentFlightStartDate smalldatetime
declare @CurrentFlightEndDate smalldatetime
declare @CurrentProjectKey int
declare @CurrentTaskKey int
declare @CurrentClassKey int
declare @CurrentClientProductKey int
declare @CurrentClientDivisionKey int
declare @CurrentOfficeKey int
declare @ClientProductKey int
declare @ClientDivisionKey int
declare @ProjectGLCompanyKey int
declare @ProjectOfficeKey int


select @IOClientLink = isnull(IOClientLink,1)
	  ,@BCClientLink = isnull(BCClientLink,1)
	  ,@RequireTasks = RequireTasks
	  ,@RequireClasses = isnull(RequireClasses, 0)
	  ,@RequireGLCompany  = isnull(RequireGLCompany, 0)
	  ,@RequireOffice = isnull(RequireOffice, 0)	 
  from tPreference (NOLOCK) 
 where CompanyKey = @OwnerCompanyKey

-- DFA Estimate?
if Left(ISNULL(@LinkID, ''), 3)= 'DFA'  
 Select @DFAEstimate = 1
else
 Select @DFAEstimate = 0
 	
--get client	
Select @ClientKey = CompanyKey from tCompany (NOLOCK) Where OwnerCompanyKey = @OwnerCompanyKey and
	CustomerID = @ClientID
	
if @ClientKey is null
	return -1

-- (173150) Use the Client's PreBill Option if set, otherwise use the Company settings 
select @IOOrderDisplayMode = isnull(c.IOBillAt, isnull(p.IOOrderDisplayMode, 1)),
	   @BCOrderDisplayMode = isnull(c.BCBillAt, isnull(p.BCOrderDisplayMode, 1))	   
from tCompany c (nolock)
Join tPreference p (nolock) on p.CompanyKey = c.OwnerCompanyKey
where c.CompanyKey = @ClientKey	

-- Allow DFA Estimates to sync without requiring these fields.  The user will need to fill them in after the sync		
if @DFAEstimate = 0  
BEGIN		
	if @ProjectNumber is not null
	BEGIN
		Select @ProjectKey = ProjectKey, @ProjectGLCompanyKey = GLCompanyKey, @ProjectOfficeKey = OfficeKey 
		from tProject p (NOLOCK) 
		Where p.CompanyKey = @OwnerCompanyKey and ProjectNumber = @ProjectNumber 
			
		if @TaskID is not null
			begin
				exec @TaskKey = spTaskIDValidate @TaskID, @ProjectKey, 2 -- Budget Tracking Task
				if @TaskKey < 0
					select @TaskKey = null
			end
			--Select @TaskKey = TaskKey from tTask (NOLOCK) Where ProjectKey = @ProjectKey and TaskID = @TaskID and MoneyTask = 1
	END

	--(52751)
	--if (@EstimateType = 'IO' and @IOClientLink = 1) or (@EstimateType = 'BC' and @BCClientLink = 1)
	if @ProjectNumber is not null
		begin
			if @ProjectKey is null
				return -2
			
			if @RequireTasks = 1
				if @TaskKey is null
					return -4
		end	

	IF @ClassID IS NOT NULL
	BEGIN
		SELECT	@ClassKey = ClassKey
		FROM	tClass (NOLOCK)
		WHERE	ClassID = @ClassID
		AND		CompanyKey = @OwnerCompanyKey

		IF @ClassKey IS NULL
			RETURN -5 --Invalid Class ID	
	END
	ELSE
		IF @RequireClasses = 1
			RETURN -6 --Class is Required

				
	IF @GLCompanyID IS NOT NULL
	BEGIN
		SELECT	@GLCompanyKey = GLCompanyKey
		FROM	tGLCompany (NOLOCK)
		WHERE	GLCompanyID = @GLCompanyID
		AND		CompanyKey = @OwnerCompanyKey

		IF @GLCompanyKey IS NULL
			RETURN -7 --Invalid GLCompany ID
		ELSE
			IF @ProjectKey is not null AND @GLCompanyKey <> @ProjectGLCompanyKey
				RETURN -12  --Project and Estimate do not belong to the same GLCompany. 
	END
	ELSE
		If @ProjectKey is not null
			SELECT @GLCompanyKey = @ProjectGLCompanyKey				--Default GLCompany if not entered, from Project.
		IF @GLCompanyKey is null AND @RequireGLCompany = 1
			RETURN -8 --GLCompany is Required

	IF @OfficeID IS NOT NULL
	BEGIN
		SELECT	@OfficeKey = OfficeKey
		FROM	tOffice (NOLOCK)
		WHERE	OfficeID = @OfficeID
		AND		CompanyKey = @OwnerCompanyKey

		IF @OfficeKey IS NULL
			RETURN -9 --Invalid Office ID
		ELSE
			IF @ProjectKey is not null AND @OfficeKey <> @ProjectOfficeKey 
				RETURN -13  --Project and Estimate do not belong to the same Office. 
	END
	ELSE
		if @ProjectKey is not null 
			SELECT @OfficeKey = @ProjectOfficeKey        --Default Office if not entered from Project.
		if @OfficeKey is null and @RequireOffice = 1
				RETURN -10 --Office is Required


	if @ClientDivisionLinkID is not null
		begin
			--find the division by link id
			select @ClientDivisionKey = ClientDivisionKey
			from tClientDivision (nolock)
			where LinkID = @ClientDivisionLinkID
			and ClientKey = @ClientKey
			and CompanyKey = @OwnerCompanyKey
			
			if @ClientDivisionKey is null
				begin
					--find division by name
					select @ClientDivisionKey = ClientDivisionKey
					from tClientDivision (nolock)
					where DivisionName = @ClientDivisionName
					and ClientKey = @ClientKey
					and CompanyKey = @OwnerCompanyKey
					
					--if found, update the link id
					if @ClientDivisionKey is not null
						update tClientDivision
						set LinkID = @ClientDivisionLinkID
						where ClientDivisionKey = @ClientDivisionKey 
					else
						begin
							--need to insert the division
							insert tClientDivision
									(CompanyKey
									,ClientKey
									,DivisionName
									,Active
									,LinkID
									)
							values  (@OwnerCompanyKey
									,@ClientKey
									,@ClientDivisionName
									,1
									,@ClientDivisionLinkID
									)
							select @ClientDivisionKey = @@IDENTITY
						end
				end
		end
		
		
	if @ClientProductLinkID is not null
		begin
			--find the product by link id
			select @ClientProductKey = ClientProductKey
			from tClientProduct (nolock)
			where LinkID = @ClientProductLinkID
			and ClientKey = @ClientKey
			and CompanyKey = @OwnerCompanyKey

			if @ClientProductKey is null
				begin
					--find prduct by name
					select @ClientProductKey = ClientProductKey
					from tClientProduct (nolock)
					where ProductName = @ClientProductName
					and ClientKey = @ClientKey
					and CompanyKey = @OwnerCompanyKey
					
					--if found, update the link id
					if @ClientProductKey is not null
						update tClientProduct
						set LinkID = @ClientProductLinkID
						where ClientProductKey = @ClientProductKey 
					else
						begin
							--need to insert the product
							insert tClientProduct
									(CompanyKey
									,ClientKey
									,ProductName
									,Active
									,LinkID
									,ClientDivisionKey
									)
							values  (@OwnerCompanyKey
									,@ClientKey
									,@ClientProductName
									,1
									,@ClientProductLinkID
									,@ClientDivisionKey
									)								
							select @ClientProductKey = @@IDENTITY
						end
				end
		end
END	
	
		
-- does media estimate already exist with the LinkID?
select @MediaEstimateKey = MediaEstimateKey from tMediaEstimate (NOLOCK) Where CompanyKey = @OwnerCompanyKey and LinkID = @LinkID

IF @MediaEstimateKey is null
BEGIN

	if exists(Select 1 from tMediaEstimate (NOLOCK) Where CompanyKey = @OwnerCompanyKey and EstimateID = @EstimateID)
		return -3
		
	Insert tMediaEstimate
		(
		CompanyKey,
		LinkID,
		ClientKey,
		EstimateID,
		EstimateName,
		FlightStartDate,
		FlightEndDate,
		Active,
		ProjectKey,
		TaskKey,
		IOOrderDisplayMode,
		BCOrderDisplayMode,
		ClassKey,
		ClientProductKey,
		ClientDivisionKey,
		GLCompanyKey,
		OfficeKey
		)
		Values
		(
		@OwnerCompanyKey,
		@LinkID,
		@ClientKey,
		@EstimateID,
		@EstimateName,
		@FlightStartDate,
		@FlightEndDate,
		1,
		@ProjectKey,
		@TaskKey,
		@IOOrderDisplayMode,
		@BCOrderDisplayMode,
		@ClassKey,
		@ClientProductKey,
		@ClientDivisionKey,
		@GLCompanyKey,
		@OfficeKey
		)
END
ELSE
BEGIN
	if exists(Select 1 from tMediaEstimate (NOLOCK) Where CompanyKey = @OwnerCompanyKey and MediaEstimateKey <> @MediaEstimateKey and EstimateID = @EstimateID)
		return -3

	Select	@CurrentGLCKey = GLCompanyKey,
			@CurrentFlightStartDate = FlightStartDate,
			@CurrentFlightEndDate = FlightEndDate,
			@CurrentProjectKey = ProjectKey,
			@CurrentTaskKey = TaskKey,
			@CurrentClassKey = ClassKey,
			@CurrentClientProductKey = ClientProductKey,
			@CurrentClientDivisionKey = ClientDivisionKey,
			@CurrentOfficeKey = OfficeKey
	from tMediaEstimate (NOLOCK) 
	Where MediaEstimateKey = @MediaEstimateKey
		
	-- Don't overwrite the Project/Task settings since they have to manaully enter them for DFA  Estimates 
	if @DFAEstimate = 1
	  Begin
		Set @ProjectKey = @CurrentProjectKey
		Set @TaskKey = @CurrentTaskKey
	  End
	  	
    Select @LineCount = Count(*)
	From tPurchaseOrder po (nolock) inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
	where po.MediaEstimateKey = @MediaEstimateKey
	and (isnull(pod.AppliedCost, 0) <> 0 or pod.InvoiceLineKey is not null)
		
	--Show error if @GLC is different from existing GLC on Estimate and there exist transactions.
	If @CurrentGLCKey <> @GLCompanyKey and @LineCount > 0
		return -11
	
	-- Check to see if something has changed
	if @CurrentFlightStartDate <> @FlightStartDate 
		or @CurrentFlightEndDate <> @FlightEndDate
		or @CurrentProjectKey <> @ProjectKey
		or @CurrentTaskKey <> @TaskKey
		or @CurrentClientProductKey <> @ClientProductKey
		or @CurrentClientDivisionKey <> @ClientDivisionKey
		or @CurrentOfficeKey <> @OfficeKey
	begin
		if @ProjectKey is not null
			begin
				-- if something has changed, can we update the order based on project status
				if not exists(Select 1 from tProject p (NOLOCK) 
						  inner join tProjectStatus ps (NOLOCK) on p.ProjectStatusKey = ps.ProjectStatusKey
						  Where p.ProjectKey = @ProjectKey and  ps.ExpenseActive = 1 )
					return -2
			end
	end		
		
	If @LineCount > 0
		begin
		--If transactions exist, do not update GLCompany or Office. 
			Update tMediaEstimate
			Set
				EstimateID = @EstimateID,
				EstimateName = @EstimateName,
				FlightStartDate = @FlightStartDate,
				FlightEndDate = @FlightEndDate,
				ProjectKey = @ProjectKey,
				TaskKey = @TaskKey,
				ClassKey = @ClassKey,
				ClientProductKey = @ClientProductKey,
				ClientDivisionKey = @ClientDivisionKey
			Where
				MediaEstimateKey = @MediaEstimateKey
				
			-- Allow users to update PurchaseOrder and Voucher Header lines with the ProjectKey if they are not populated
			if @CurrentProjectKey IS NULL AND @ProjectKey IS NOT NULL
				begin
					-- Update the MediaEstimate since the original ProjectKey was NULL
					Update tMediaEstimate
					Set ProjectKey = @ProjectKey
					Where MediaEstimateKey = @MediaEstimateKey AND ProjectKey IS NULL
			
					-- Update PurchaseOrders
					Update tPurchaseOrder 
					Set ProjectKey = @ProjectKey
					Where MediaEstimateKey = @MediaEstimateKey AND ProjectKey IS NULL
					
					-- Update Vouchers
					Update tVoucher Set tVoucher.ProjectKey = @ProjectKey
					from tMediaEstimate e (nolock)
					Join tPurchaseOrder po (nolock) on po.MediaEstimateKey = e.MediaEstimateKey
					Join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
					Join tVoucherDetail vd (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
					Join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey 
					Where e.MediaEstimateKey = @MediaEstimateKey AND v.ProjectKey IS NULL
				end 			
		end			
	else
			Update tMediaEstimate
			Set
				EstimateID = @EstimateID,
				EstimateName = @EstimateName,
				FlightStartDate = @FlightStartDate,
				FlightEndDate = @FlightEndDate,
				ProjectKey = @ProjectKey,
				TaskKey = @TaskKey,
				ClassKey = @ClassKey,
				ClientProductKey = @ClientProductKey,
				ClientDivisionKey = @ClientDivisionKey,
				GLCompanyKey = @GLCompanyKey,
				OfficeKey = @OfficeKey
			Where
				MediaEstimateKey = @MediaEstimateKey
		
END
GO
