USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportContactHistory]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportContactHistory]

	(
		@CompanyKey int,
		@CompanyName varchar(200),
		@Address1 varchar(100),
		@FirstName varchar(100),
		@LastName varchar(100),
		@Type varchar(50),
		@Priority varchar(20),
		@Subject varchar(200),
		@AssignedTo varchar(100),
		@Status varchar(50),
		@Outcome varchar(50),
		@ActivityDate smalldatetime,
		@ActivityTime varchar(50),
		@DateCompleted smalldatetime,
		@Notes varchar(4000)
	)

AS --Encrypt


/*
|| When      Who Rel      What
|| 10/22/08  CRG 10.0.1.1 (37416) If Outcome is not passed in, default it to NULL.
||                        Note- I also commented out the clause with tCompany.Address1 because it's not in the table anymore.
||                        I assume that this SP will need to be modified further at some point for the contact management changes going into 10.5.
*/

Declare @CCompanyKey int, @CUserKey int, @AssignedToKey int


SELECT @CCompanyKey = MIN(CompanyKey)
FROM   tCompany (NOLOCK)
WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
--AND    UPPER(LTRIM(RTRIM(Address1))) = UPPER(LTRIM(RTRIM(@Address1)))
AND    OwnerCompanyKey = @CompanyKey 

IF @CCompanyKey IS NULL
	SELECT @CCompanyKey = MIN(CompanyKey)
	FROM   tCompany (NOLOCK)
	WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
	AND    OwnerCompanyKey = @CompanyKey

if @CCompanyKey is null
	return -1
		
if @FirstName is not null and @LastName is not null
BEGIN
	Select @CUserKey = MIN(UserKey)
	From tUser (nolock)
	Where CompanyKey = @CCompanyKey and
	UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName))) and
	UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))
	
	if @CUserKey is null
		return -2
END

if @AssignedTo is not null
BEGIN
	Select @AssignedToKey = MIN(UserKey)
	From tUser (nolock)
	Where CompanyKey = @CompanyKey and
	(UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@AssignedTo))) OR UPPER(LTRIM(RTRIM(SystemID))) = UPPER(LTRIM(RTRIM(@AssignedTo))))
	
	if @AssignedToKey is null
		return -3
		
END

INSERT tContactActivity
	(
	CompanyKey,
	Type,
	Priority,
	Subject,
	ContactCompanyKey,
	ContactKey,
	AssignedUserKey,
	Status,
	Outcome,
	ActivityDate,
	ActivityTime,
	DateCompleted,
	LeadKey,
	ProjectKey,
	Notes,
	DateAdded,
	DateUpdated
	)

VALUES
	(
	@CompanyKey,
	@Type,
	@Priority,
	@Subject,
	@CCompanyKey,
	@CUserKey,
	@AssignedToKey,
	Case UPPER(@Status) When 'OPEN' Then 1 When 'COMPLETED' then 2 else 1 END,
	Case UPPER(@Outcome) When 'SUCCESSFUL' Then 1 When 'UNSUCCESSFUL' then 2 else NULL END,
	@ActivityDate,
	@ActivityTime,
	@DateCompleted,
	NULL,
	NULL,
	@Notes,
	GETDATE(),
	GETDATE()
	)
GO
