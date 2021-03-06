USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBEmployeeInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBEmployeeInsert]
(	
	@OwnerCompanyKey int,
	@SystemID varchar(500),
	/*
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	*/
	@Phone1 varchar(50),
	@Phone2 varchar(50),
	@Email varchar(100),
	@FirstName varchar(100),
	@LastName varchar(100),
	@LinkID varchar(100)
)


AS --Encrypt

/*
|| When     Who Rel			What
|| 02/21/11 QMD 10.5.4.1	Updated parms for sptUserInsert
*/

declare @RetVal integer
declare @UserKey int

	select @UserKey = UserKey
	  from tUser(nolock)
	 where LinkID = @LinkID
	   and OwnerCompanyKey = @OwnerCompanyKey
	   
if @UserKey is null
  begin
	exec @RetVal = sptUserInsert
		 @OwnerCompanyKey,
		 @FirstName,
		 null,
		 @LastName,
		 null,
		 @Phone1,
		 @Phone2,
		 null, -- @Cell
		 null, -- @Fax
		 null, -- @Pager
		 null, -- @Title
		 @Email,
		 @SystemID,
		 null, -- @OwnerCompanyKey
		 null, -- @ContactMethod
		 null, -- @DepartmentKey
		 null, -- @OfficeKey
		 null, -- @TimeZoneIndex
		 null, -- @Supervisor
		 null, -- @DefaultCalendarColor
		 @UserKey output 
				
	if @RetVal < 0 
		return -1
		
	update tUser
	   set LinkID = @LinkID
	 where UserKey = @UserKey 
  end
else
	update tUser
	   set FirstName = @FirstName,
	       LastName = @LastName,
	       Phone1 = @Phone1,
	       Phone2 = @Phone2,
	       Email = @Email,
	       SystemID = @SystemID
	 where UserKey = @UserKey
	 
	 
	return @UserKey
GO
