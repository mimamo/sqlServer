USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerInsert]
	@CompanyKey int,
	@ClientKey int,
	@Title varchar(200),
	@StartDate smalldatetime,
	@Frequency smallint,
	@NumberOfPeriods int,
	@AmountPerPeriod money,
	@LastBillingDate smalldatetime,
	@IncludeLabor tinyint,
	@IncludeExpense tinyint,
	@CustomFieldKey int,
	@LineFormat smallint,
	@InvoiceApprovedBy int,
	@Active tinyint,
	@InvoiceExpensesSeperate tinyint,
	@SalesAccountKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@Description text,
	@ClassKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/05/07 GHL 8.5   Added GLCompanyKey + office          
  || 09/20/07 GHL 8.437 (Enh 13169) Added new field Description
  || 12/17/07 GHL 8.5   (Enh 17879) Added ClassKey       
  || 06/19/08 GHL 8.514 (13169) Changed description to text from varchar(1500)
  */

	INSERT tRetainer
		(
		CompanyKey,
		ClientKey,
		Title,
		StartDate,
		Frequency,
		NumberOfPeriods,
		AmountPerPeriod,
		LastBillingDate,
		IncludeLabor,
		IncludeExpense,
		CustomFieldKey,
		LineFormat,
		InvoiceApprovedBy,
		Active,
		InvoiceExpensesSeperate,
		SalesAccountKey,
		GLCompanyKey,
		OfficeKey,
		Description,
		ClassKey
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@Title,
		@StartDate,
		@Frequency,
		@NumberOfPeriods,
		@AmountPerPeriod,
		@LastBillingDate,
		@IncludeLabor,
		@IncludeExpense,
		@CustomFieldKey,
		@LineFormat,
		@InvoiceApprovedBy,
		@Active,
		@InvoiceExpensesSeperate,
		@SalesAccountKey,
		@GLCompanyKey,
		@OfficeKey,
		@Description,
		@ClassKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
