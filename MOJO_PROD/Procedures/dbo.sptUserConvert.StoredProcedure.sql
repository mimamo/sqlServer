USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserConvert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserConvert]
 @UserKey int,
 @UpdatedBy int,
 @CompanyKey int,
 @ConvertToEmployee tinyint = 0
 
AS --Encrypt

/*
  || When     Who Rel    What
  || 06/28/11 RLB 10.545 (115163) Created to Convert  a Contact to Employee or Employee to a Contact
  || 08/08/11 RLB 10.547 (118181) Added Updated by and DateUpdated
  || 08/15/11 GWG 10.547 blank the user id and client login 
  || 05/08/13 WDF 10.568 (177487) Added SystemMessage defaults

*/

if @ConvertToEmployee = 1
	begin
		
		if exists(Select 1 from tCompany (nolock) where PrimaryContact = @UserKey)
			begin

				UPDATE tCompany set PrimaryContact = null where PrimaryContact = @UserKey

			end

		UPDATE tUser set CompanyKey = @CompanyKey, OwnerCompanyKey = null, SystemMessage = 1, UpdatedByKey = @UpdatedBy, DateUpdated = GETUTCDATE(), UserCompanyName = null WHERE UserKey = @UserKey
		if exists(Select 1 from tUser (nolock) Where UserKey = @UserKey and ClientVendorLogin = 1)
			Update tUser Set ClientVendorLogin = 0, UserID = NULL Where UserKey = @UserKey
	END
ELSE
	begin

		UPDATE tUser set OwnerCompanyKey = @CompanyKey, CompanyKey = null, SystemMessage = 0, UpdatedByKey = @UpdatedBy, DateUpdated = GETUTCDATE() where UserKey = @UserKey
 
	end


 RETURN 1
GO
