USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10565]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10565]
AS
	
	-- seed tMediaEstimate new fields from the client
	update tMediaEstimate
	set    tMediaEstimate.IOBillAt = isnull(c.IOBillAt, 0)
			,tMediaEstimate.BCBillAt = isnull(c.BCBillAt, 0)
	from   tCompany c (nolock)
	where  tMediaEstimate.ClientKey = c.CompanyKey 

	-- seed VoucherID for Spark44
	declare @CompanyKey int
	declare @VoucherID int

	update tVoucher
	set    CreditCard = isnull(CreditCard, 0)

	select @CompanyKey = -1
	while (1=1)
	begin
		select @CompanyKey = min(CompanyKey) from tPreference (nolock) where CompanyKey > @CompanyKey

		if @CompanyKey is null
			break

		select @VoucherID = 0

		update tVoucher
		set    VoucherID = @VoucherID
		      ,@VoucherID = @VoucherID + 1
		where CompanyKey = @CompanyKey
		and   CreditCard = 0

	end

	-- create missing tCashTransactionLine for Client and Vendor Invoices
	select @CompanyKey = -1
	while (1=1)
	begin
		select @CompanyKey = min(CompanyKey)
		from   tPreference (nolock)
		where  CompanyKey > @CompanyKey
		and    upper(isnull(Customizations, '')) NOT LIKE '%TRACKCASH%'

		if @CompanyKey is null
			break

		exec spGLPostConvertCashInvoiceCompany @CompanyKey
		exec spGLPostConvertCashVoucherCompany @CompanyKey

	end 

	--Check for duplicate Names in tWebDavServer
	SELECT	WebDavServerKey
	INTO	#webdav
	FROM	tWebDavServer (nolock)
	WHERE	[Name] IS NOT NULL

	DECLARE	@WebDavServerKey int
	SELECT	@WebDavServerKey = -1

	DECLARE @Name varchar(200),
			@Counter int

	WHILE(1=1)
	BEGIN
		SELECT	@WebDavServerKey = MIN(WebDavServerKey)
		FROM	#webdav
		WHERE	WebDavServerKey > @WebDavServerKey

		IF @WebDavServerKey IS NULL
			BREAK

		SELECT	@Name = [Name]
		FROM	tWebDavServer (nolock)
		WHERE	WebDavServerKey = @WebDavServerKey

		SELECT	@Counter = 0

		WHILE(1=1)
		BEGIN
			--Protect from an infinite loop just in case
			SELECT	@Counter = @Counter + 1
			IF @Counter > 20
				BREAK

			IF NOT EXISTS (SELECT NULL FROM tWebDavServer (nolock) WHERE WebDavServerKey <> @WebDavServerKey AND UPPER([Name]) = UPPER(@Name))
			BEGIN
				UPDATE  tWebDavServer
				SET		[Name] = @Name
				WHERE	WebDavServerKey = @WebDavServerKey

				BREAK
			END
			
			SELECT	@Name = ISNULL(@Name, '') + '_'
		END
	END

	-- seed new field in tPreference
	UPDATE tPreference
	SET EmailSubjectFormat = ISNULL(EmailSubjectFormat, 0)
GO
