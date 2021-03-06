USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteUpdate]
	@QuoteKey int,
	@PurchaseOrderTypeKey int,
	@Subject varchar(200),
	@QuoteDate smalldatetime,
	@DueDate smalldatetime,
	@Description varchar(1000),
	@ApprovedReplyKey int,
	@CustomFieldKey int,
	@SendRepliesTo int,
	@HeaderTextKey int,
	@FooterTextKey int,
	@ProjectKey int,
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
	@CompanyAddressKey int	

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/06/07 BSH 8.5     (9659)Update GLCompanyKey
|| 01/18/08 BSH 8.5     (18369)Validate that Project on line and header belong to same GLC.
|| 10/22/08 GHL 10.5    (37963) Added CompanyAddressKey
*/

	IF EXISTS(SELECT 1 from tQuoteDetail qd (nolock) inner join tProject p on qd.ProjectKey = p.ProjectKey
		Where qd.QuoteKey = @QuoteKey and ISNULL(p.GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0))
		Return -1

	UPDATE
		tQuote
	SET
		PurchaseOrderTypeKey = @PurchaseOrderTypeKey,
		Subject = @Subject,
		QuoteDate = @QuoteDate,
		DueDate = @DueDate,
		Description = @Description,
		ApprovedReplyKey = @ApprovedReplyKey,
		CustomFieldKey = @CustomFieldKey,
		SendRepliesTo = @SendRepliesTo,
		HeaderTextKey = @HeaderTextKey,
		FooterTextKey = @FooterTextKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		ItemKey = @ItemKey,
		MultipleQty = @MultipleQty,
		Quote1 = @Quote1,
		Quote2 = @Quote2,
		Quote3 = @Quote3,
		Quote4 = @Quote4,
		Quote5 = @Quote5,
		Quote6 = @Quote6,
		GLCompanyKey = @GLCompanyKey,		
		CompanyAddressKey = @CompanyAddressKey
	WHERE
		QuoteKey = @QuoteKey 

	exec sptQuoteUpdateStatus @QuoteKey, 1

	RETURN 1
GO
