USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserCompanyGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserCompanyGet]

	 @CompanyKey int
	,@SearchOption tinyint
	,@SearchPhrase varchar(20)
	
AS

declare @ParentCompanyKey int

	select @ParentCompanyKey = ParentCompanyKey	
	from tCompany(nolock)
	where CompanyKey = @CompanyKey
	
	--this company does not have a parent company, just get users from this company
	if @ParentCompanyKey is null
		--no criteria specified return all users
		if @SearchOption is null
			select * from tUser (nolock)
			where CompanyKey = @CompanyKey
			and Active = 1
		else
			--search by last name
			if @SearchOption = 1
				select * from tUser (nolock)
				where CompanyKey = @CompanyKey
				and Active = 1
				and upper(LastName) like upper(@SearchPhrase) + '%'
			else
				--search by first name
				select * from tUser (nolock)
				where CompanyKey = @CompanyKey
				and Active = 1
				and upper(FirstName) like upper(@SearchPhrase) + '%'
	else
		--this company has a parent company, get users for the parent and all child companies
		begin
			if @SearchOption is null
				select * from tUser (nolock)
				where (CompanyKey = @ParentCompanyKey or CompanyKey in (select distinct(CompanyKey) 
																		from tCompany (nolock) 
																		where ParentCompanyKey = @ParentCompanyKey)) 
				and Active = 1
			else
				--search by last name
				if @SearchOption = 1
					select * from tUser (nolock)
					where (CompanyKey = @ParentCompanyKey or CompanyKey in (select distinct(CompanyKey) 
																			from tCompany (nolock) 
																			where ParentCompanyKey = @ParentCompanyKey))
					and Active = 1
					and upper(LastName) like upper(@SearchPhrase) + '%'
				else
					select * from tUser (nolock)
					where (CompanyKey = @ParentCompanyKey or CompanyKey in (select distinct(CompanyKey) 
																			from tCompany (nolock) 
																			where ParentCompanyKey = @ParentCompanyKey))
					and Active = 1
					and upper(FirstName) like upper(@SearchPhrase) + '%'
		end
	
	
	return 1
GO
