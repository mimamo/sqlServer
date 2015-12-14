USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportInvoiceLine]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportInvoiceLine]
	@InvoiceKey int,
	@ProjectNumber varchar(50),
	@TaskID varchar(30),
	@LineSubject varchar(100),
	@LineDescription varchar(500),
	@Quantity decimal(9,3),
	@UnitAmount money,
	@TotalAmount money,
	@SalesAccountNumber varchar(100),
	@ClassID varchar(50),
	@OfficeID varchar(50),
	@Taxable tinyint,
	@WorkTypeID varchar(100)
AS --Encrypt

	DECLARE @DisplayOrder int,
			@ProjectKey int,
			@ProjectClientKey int,
			@TaskKey int,
			@SalesAccountKey int,
			@ClassKey int,
			@OfficeKey int,
			@WorkTypeKey int,
			@CompanyKey int,
			@ClientKey int,
			@Closed tinyint
			
	SELECT	@CompanyKey = CompanyKey, @ClientKey = ClientKey
	FROM	tInvoice (nolock)
	WHERE	InvoiceKey = @InvoiceKey

	select @DisplayOrder = (select count(*)+1
	                            from tInvoiceLine (nolock)
	                           where InvoiceKey = @InvoiceKey)

	IF @ProjectNumber IS NOT NULL
	BEGIN			
		SELECT	@ProjectKey = ProjectKey, @ProjectClientKey = ClientKey, @Closed = Closed
		FROM	tProject (nolock)
		WHERE	ProjectNumber = @ProjectNumber
		AND		CompanyKey = @CompanyKey
		
		IF @ProjectKey IS NULL
			RETURN -1
	
		if ISNULL(@ProjectClientKey, 0) <> ISNULL(@ClientKey, 0)
			Return -6
			
		If @Closed = 1
			Return -7
	END
	
	
	IF @TaskID IS NOT NULL
	BEGIN
		SELECT	@TaskKey = TaskKey
		FROM	tTask (nolock)
		WHERE	TaskID = @TaskID
		AND		ProjectKey = @ProjectKey
		
		IF @TaskKey IS NULL
			RETURN -2
	END
	
	if @ProjectNumber is null
		Select @TaskKey = null
	
	IF @SalesAccountNumber IS NOT NULL
	BEGIN
		SELECT	@SalesAccountKey = GLAccountKey
		FROM	tGLAccount (nolock)
		WHERE	AccountNumber = @SalesAccountNumber
		AND		CompanyKey = @CompanyKey
		
		IF @SalesAccountKey IS NULL
			RETURN -3
	END		
	
	IF @ClassID IS NOT NULL
	BEGIN
		SELECT	@ClassKey = ClassKey
		FROM	tClass (nolock)
		WHERE	ClassID = @ClassID
		AND		CompanyKey = @CompanyKey
		
		IF @ClassKey IS NULL
			RETURN -4
	END		
	
	if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		Return -4

	IF @OfficeID IS NOT NULL
	BEGIN
		SELECT	@OfficeKey = OfficeKey
		FROM	tOffice (nolock)
		WHERE	OfficeID = @OfficeID
		AND		CompanyKey = @CompanyKey
		
		IF @OfficeKey IS NULL
			RETURN -7
	END		
	
	if @OfficeKey is null and (select isnull(RequireOffice, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		Return -7

	IF @WorkTypeID IS NOT NULL
	BEGIN
		SELECT	@WorkTypeKey = WorkTypeKey
		FROM	tWorkType (nolock)
		WHERE	WorkTypeID = @WorkTypeID
		AND		CompanyKey = @CompanyKey
		
		IF @WorkTypeKey IS NULL
			RETURN -5
	END		
	
	
	INSERT tInvoiceLine
	(
	InvoiceKey,
	ProjectKey,
	TaskKey,
	LineType,
	ParentLineKey,
	LineSubject,
	LineDescription,
	BillFrom,
	Quantity,
	UnitAmount,
	TotalAmount,
	PostSalesUsingDetail,
	SalesAccountKey,
	ClassKey,
	OfficeKey,
	DisplayOrder,
	InvoiceOrder,
	LineLevel,
	Taxable,
	WorkTypeKey
	)
	VALUES
	(
	@InvoiceKey,
	@ProjectKey,
	@TaskKey,
	2,
	0,
	@LineSubject,
	@LineDescription,
	1,
	@Quantity,
	@UnitAmount,
	@TotalAmount,
	0,
	@SalesAccountKey,
	@ClassKey,
	@OfficeKey,
	@DisplayOrder,
	@DisplayOrder,
	0,
	@Taxable,
	@WorkTypeKey
	)
	 
 RETURN 1
GO
