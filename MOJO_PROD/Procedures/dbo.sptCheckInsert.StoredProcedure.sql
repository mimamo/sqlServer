USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckInsert]
 @ClientKey int,
 @CheckAmount money,
 @CheckDate smalldatetime,
 @PostingDate smalldatetime,
 @ReferenceNumber varchar(100),
 @Description varchar(500),
 @CashAccountKey int,
 @ClassKey int,
 @PrepayAccountKey int,
 @DepositID varchar(50),
 @CheckMethodKey int,
 @GLCompanyKey int,
 @OpeningTransaction tinyint = 0,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/5/07   GWG 8.5      Added GL Company
|| 06/18/08  GHL 8.513    Added OpeningTransaction
|| 06/22/09  QMD 10.0.2.7 Modified Opening Transaction to default to 0 (Confirmed with Gil)
|| 02/10/10  GWG 10.5.1.8 Added CompanyKey to the insert
*/

Declare @CompanyKey int
Declare @DepositKey int
Declare @Cleared tinyint

if exists(Select 1 from tCheck (nolock) Where ReferenceNumber = @ReferenceNumber and ClientKey = @ClientKey)
	return -1
	
Select @CompanyKey = OwnerCompanyKey from tCompany (nolock) Where CompanyKey = @ClientKey

if @CashAccountKey is null
	Select @DepositID = NULL
	
if not @DepositID is null
BEGIN

	
	Select @DepositKey = DepositKey, @Cleared = Cleared from tDeposit (nolock) 
		Where CompanyKey = @CompanyKey and DepositID = @DepositID and ISNULL(GLAccountKey, 0) = ISNULL(@CashAccountKey, 0) and ISNULL(@GLCompanyKey, 0) = ISNULL(GLCompanyKey, 0)

	if @DepositKey is null
		BEGIN
		Insert tDeposit 
		(	
		CompanyKey,
		DepositID,
		GLAccountKey,
		DepositDate,
		GLCompanyKey
		)
		VALUES
		(
		@CompanyKey,
		@DepositID,
		@CashAccountKey,
		@CheckDate,
		@GLCompanyKey
		)
		
		Select @DepositKey = @@Identity
		END
	else
		BEGIN
		if ISNULL(@Cleared, 0) = 1
			return -2
		END
		
end

 INSERT tCheck
  (
  ClientKey,
  CompanyKey,
  CheckAmount,
  CheckDate,
  PostingDate,
  ReferenceNumber,
  Description,
  CashAccountKey,
  ClassKey,
  PrepayAccountKey,
  Posted,
  DepositKey,
  CheckMethodKey,
  GLCompanyKey,
  OpeningTransaction
  )
 VALUES
  (
  @ClientKey,
  @CompanyKey,
  @CheckAmount,
  @CheckDate,
  @PostingDate,
  @ReferenceNumber,
  @Description,
  @CashAccountKey,
  @ClassKey,
  @PrepayAccountKey,
  0,
  @DepositKey,
  @CheckMethodKey,
  @GLCompanyKey,
  @OpeningTransaction
  )
 
 SELECT @oIdentity = @@IDENTITY
 
 
 RETURN 1
GO
