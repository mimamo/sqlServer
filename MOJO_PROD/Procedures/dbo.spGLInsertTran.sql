USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLInsertTran]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLInsertTran]

	(
		@CompanyKey int,
		@Type char(1),
		@TransactionDate smalldatetime,
		@Entity varchar(50),
		@EntityKey int,
		@Reference varchar(100),
		@GLAccountKey int,
		@Amount money,
		@ClassKey int,
		@Memo varchar(500),
		@ClientKey int,
		@ProjectKey int,
		@SourceCompanyKey int,
		@DepositKey int = NULL,
		@GLCompanyKey int = NULL,
		@OfficeKey int = NULL,
		@DepartmentKey int = NULL,
		@DetailLineKey int = NULL,
		@Section int = NULL,
		@Overhead tinyint = 0,
		@CurrencyID varchar(10) = null,
		@ExchangeRate decimal(24,7) = 1,
		@HAmount money = null
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 06/18/07 GHL 8.5    Added OfficeKey, DepartmentKey and GLCompanyKey
  ||                     We still need this stored proc for spGLPostWIP
  || 09/17/07 GHL 8.5    Added Overhead parameter
  || 08/05/13 GHL 10.571 Changes for multi currency...temporary:
  ||                     i.e CurrencyID = null, ExchangeRate = 1, HAmount = Amount
  || 09/25/13 GHL 10.572 Added CurrencyID, ExchangeRate, HAmount parameters
  */  

Declare @PostMonth int
Declare @PostYear int
Declare @TransactionKey int

Select @PostMonth = cast(DatePart(mm, @TransactionDate) as int)
Select @PostYear = cast(DatePart(yyyy, @TransactionDate) as int)

IF @ClassKey = 0
	SELECT @ClassKey = NULL
IF @ClientKey = 0
	SELECT @ClientKey = NULL
IF @OfficeKey = 0
	SELECT @OfficeKey = NULL
IF @DepartmentKey = 0
	SELECT @DepartmentKey = NULL
IF @SourceCompanyKey = 0
	SELECT @SourceCompanyKey = NULL
IF @GLCompanyKey = 0
	SELECT @GLCompanyKey = NULL	
IF @ProjectKey = 0
	SELECT @ProjectKey = NULL	

if @HAmount is null
	select @HAmount = @Amount

IF @Type = 'D'
BEGIN
	INSERT tTransaction
			(
			CompanyKey,
			DateCreated,
			TransactionDate,
			Entity,
			EntityKey,
			Reference,
			GLAccountKey,
			Debit,
			Credit,
			HDebit,
			HCredit,
			ClassKey,
			Memo,
			PostMonth,
			PostYear,
			ClientKey,
			ProjectKey,
			SourceCompanyKey,
			Cleared,
			DepositKey,
			PostSide,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,
			DetailLineKey,
			Section,
			Overhead,
			CurrencyID,
			ExchangeRate
			)

		VALUES
			(
			@CompanyKey,
			Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as datetime),
			@TransactionDate,
			@Entity,
			@EntityKey,
			@Reference,
			@GLAccountKey,
			ROUND(@Amount, 2),
			0,
			ROUND(@HAmount, 2),
			0,
			@ClassKey,
			@Memo,
			@PostMonth,
			@PostYear,
			@ClientKey,
			@ProjectKey,
			@SourceCompanyKey,
			0,
			@DepositKey,
			@Type,
			@GLCompanyKey,
			@OfficeKey,
			@DepartmentKey,			
			@DetailLineKey,
			@Section,
			@Overhead,
			@CurrencyID,
			@ExchangeRate
			)
			
		SELECT @TransactionKey = @@IDENTITY
END		
else
BEGIN
	INSERT tTransaction
			(
			CompanyKey,
			DateCreated,
			TransactionDate,
			Entity,
			EntityKey,
			Reference,
			GLAccountKey,
			Debit,
			Credit,
			HDebit,
			HCredit,
			ClassKey,
			Memo,
			PostMonth,
			PostYear,
			ClientKey,
			ProjectKey,
			SourceCompanyKey,
			Cleared,
			DepositKey,
			PostSide,
			GLCompanyKey,
			OfficeKey,
			DepartmentKey,			
			DetailLineKey,
			Section,
			Overhead,
			CurrencyID,
			ExchangeRate
			)

		VALUES
			(
			@CompanyKey,
			Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as datetime),
			@TransactionDate,
			@Entity,
			@EntityKey,
			@Reference,
			@GLAccountKey,
			0,
			ROUND(@Amount, 2),
			0,
			ROUND(@HAmount, 2),
			@ClassKey,
			@Memo,
			@PostMonth,
			@PostYear,
			@ClientKey,
			@ProjectKey,
			@SourceCompanyKey,
			0,
			@DepositKey,
			@Type,
			@GLCompanyKey,
			@OfficeKey,
			@DepartmentKey,
			@DetailLineKey,
			@Section,
			@Overhead,
			@CurrencyID,
			@ExchangeRate
			)

		SELECT @TransactionKey = @@IDENTITY
END

RETURN @TransactionKey
GO
