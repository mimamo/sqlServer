USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStringCompanyInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptStringCompanyInsert]
	 @CompanyKey int
	,@StringID varchar(50)
	,@StringSingular varchar(500)
	,@StringPlural varchar(500)
	,@StringDropDown varchar(4000)

AS --Encrypt
	insert tStringCompany (CompanyKey, StringID, StringSingular, StringPlural, StringDropDown)
	values (
	        @CompanyKey
	       ,@StringID
	       ,@StringSingular
	       ,@StringPlural
	       ,@StringDropDown
	       )

 	update tStringCompany
	   set tStringCompany.StringSingular = tString.StringSingular
	  from tString
     where tStringCompany.CompanyKey = @CompanyKey	     
       and tStringCompany.StringSingular is null
       and tStringCompany.StringID = tString.StringID
       
 	update tStringCompany
	   set tStringCompany.StringPlural = tString.StringPlural
	  from tString
     where tStringCompany.CompanyKey = @CompanyKey	     
       and tStringCompany.StringPlural is null
       and tStringCompany.StringID = tString.StringID
       
	return 1
GO
