USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReadMarkAllRead]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptReadMarkAllRead]
(
	@UserKey int,
	@CompanyKey int
)

as


delete tAppRead Where UserKey = @UserKey

--all activities
Insert tAppRead(UserKey, Entity, EntityKey, IsRead)
Select @UserKey, 'tActivity', ActivityKey, 1 
From tActivity (nolock) Where CompanyKey = @CompanyKey


-- link to spec sheets through projects
Insert tAppRead(UserKey, Entity, EntityKey, IsRead)
Select @UserKey, 'tSpecSheet', SpecSheetKey, 1 
From tSpecSheet ss (nolock) 
inner join tProject p (nolock) on ss.EntityKey = p.ProjectKey and ss.Entity = 'Project'
Where p.CompanyKey = @CompanyKey

-- link to spec sheets through ProjectRequest
Insert tAppRead(UserKey, Entity, EntityKey, IsRead)
Select @UserKey, 'tSpecSheet', SpecSheetKey, 1 
From tSpecSheet ss (nolock) 
inner join tProjectRequest p (nolock) on ss.EntityKey = p.tProjectRequestKey and ss.Entity = 'ProjectRequest'
Where p.CompanyKey = @CompanyKey

-- link to spec sheets through Opportunities
Insert tAppRead(UserKey, Entity, EntityKey, IsRead)
Select @UserKey, 'tSpecSheet', SpecSheetKey, 1 
From tSpecSheet ss (nolock) 
inner join tLead p (nolock) on ss.EntityKey = p.LeadKey and ss.Entity = 'Lead'
Where p.CompanyKey = @CompanyKey
GO
