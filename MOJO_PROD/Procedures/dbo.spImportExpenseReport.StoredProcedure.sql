USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportExpenseReport]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportExpenseReport]
 @SystemID varchar(500),
 @CompanyKey int,
 @EnvelopeNumber varchar(30),
 @StartDate smalldatetime,
 @EndDate smalldatetime,
 @oIdentity INT OUTPUT
AS --Encrypt

declare @UserKey int, @RetVal INTEGER, @NextTranNo VARCHAR(100)

Select @UserKey = UserKey from tUser (nolock) Where SystemID = @SystemID and ISNULL(OwnerCompanyKey, CompanyKey) = @CompanyKey and Active = 1 and Len(UserID) > 0
	if @UserKey is null
		return -1

if not @EnvelopeNumber is null
BEGIN
	IF EXISTS(
		SELECT 1 FROM tExpenseEnvelope (nolock) WHERE
			CompanyKey = @CompanyKey AND
			EnvelopeNumber = @EnvelopeNumber)
		RETURN -2
END
ELSE
BEGIN
	EXEC spGetNextTranNo
		@CompanyKey,
		'Expense',		-- TranType
		@RetVal	OUTPUT,
		@NextTranNo OUTPUT
	
		IF @RetVal <> 1
			RETURN -3
			
		SELECT @EnvelopeNumber = RTRIM(LTRIM(@NextTranNo))
END


 INSERT tExpenseEnvelope
  (
  UserKey,
  CompanyKey,
  EnvelopeNumber,
  StartDate,
  EndDate,
  Status,
  DateCreated,
  DateSubmitted,
  DateApproved,
  ApprovalComments
  )
 VALUES
  (
  @UserKey,
  @CompanyKey,
  @EnvelopeNumber,
  @StartDate,
  @EndDate,
  4, --@Status,
  GETDATE(),  --@DateCreated,
  GETDATE(), -- @DateSubmitted,
  GETDATE(), --@DateApproved,
  null --@ApprovalComments
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
