USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteInsert]
	@CompanyKey int,
	@PurchaseOrderTypeKey int,
	@ProjectKey int,
	@Subject varchar(200),
	@QuoteDate smalldatetime,
	@DueDate smalldatetime,
	@Description varchar(1000),
	@ApprovedReplyKey int,
	@Status smallint,
	@CustomFieldKey int,
	@SendRepliesTo int,
	@HeaderTextKey int,
	@FooterTextKey int,
	@TaskKey int,
	@ItemKey int,
	@MultipleQty tinyint,
	@Quote1 varchar(100),
	@Quote2 varchar(100),
	@Quote3 varchar(100),
	@Quote4 varchar(100),
	@Quote5 varchar(100),
	@Quote6 varchar(100),
	@GLCompanyKey int,
	@CompanyAddressKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/06/07 BSH 8.5     (9659)Update GLCompanyKey
|| 10/22/08 GHL 10.5    (37963) Added CompanyAddressKey
*/

Declare @NextNum int

Select @NextNum = ISNULL(MAX(QuoteNumber) + 1, 1) from tQuote (NOLOCK) WHERE CompanyKey = @CompanyKey


	INSERT tQuote
		(
		CompanyKey,
		PurchaseOrderTypeKey,
		ProjectKey,
		QuoteNumber,
		Subject,
		QuoteDate,
		DueDate,
		Description,
		ApprovedReplyKey,
		Status,
		CustomFieldKey,
		SendRepliesTo,
		HeaderTextKey,
		FooterTextKey,
		TaskKey,
		ItemKey,
		MultipleQty,
		Quote1,
		Quote2,
		Quote3,
		Quote4,
		Quote5,
		Quote6,
		GLCompanyKey,
		CompanyAddressKey
		)

	VALUES
		(
		@CompanyKey,
		@PurchaseOrderTypeKey,
		@ProjectKey,
		@NextNum,
		@Subject,
		@QuoteDate,
		@DueDate,
		@Description,
		@ApprovedReplyKey,
		@Status,
		@CustomFieldKey,
		@SendRepliesTo,
		@HeaderTextKey,
		@FooterTextKey,
		@TaskKey,
		@ItemKey,
		@MultipleQty,
		@Quote1,
		@Quote2,
		@Quote3,
		@Quote4,
		@Quote5,
		@Quote6,
		@GLCompanyKey,
		@CompanyAddressKey		
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
