USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetAvailUsers]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetAvailUsers]
  @ProjectKey int
 ,@AssignedOnly int
 ,@BeginsWith varchar(10)
AS --Encrypt
--only assigned people
--AssignedOnly always = 1 now
  if @BeginsWith = ''
   begin
   -- all names
     select u.*, c.CompanyName
      from tUser       u (NOLOCK)
          ,tAssignment a (NOLOCK)
          ,tCompany c (NOLOCK)
     where u.Active = 1
       and a.UserKey = u.UserKey
       and a.ProjectKey = @ProjectKey
       and u.UserKey not in (select * from #tPeopleSelected)
       and u.CompanyKey = c.CompanyKey
    order by u.LastName ASC, u.FirstName ASC   
   end
  else
   begin
   --only last names beginning with
     select u.*, c.CompanyName
      from tUser       u (NOLOCK)
          ,tAssignment a (NOLOCK)
          ,tCompany c (NOLOCK)
     where u.Active = 1
       and (UPPER(u.LastName) like UPPER(ltrim(rtrim(@BeginsWith))) + '%'
       or UPPER(c.CompanyName) like UPPER(ltrim(rtrim(@BeginsWith))) + '%')
       and a.UserKey = u.UserKey
       and a.ProjectKey = @ProjectKey
       and u.UserKey not in (select * from #tPeopleSelected)
       and u.CompanyKey = c.CompanyKey
    order by u.LastName ASC, u.FirstName ASC    
   end
 RETURN 1
GO
