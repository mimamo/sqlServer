USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderAddValid]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderAddValid]
	@UserKey int,
	@FolderName varchar(200),
	@Entity varchar(50)
AS

  /*
  || When     Who Rel    		What
  || 11/11/09 MFT 10.5.013  Added @Entity param, @CompanyKey filter, altered final select to allow add to personal folder by owner
  */

declare	@SecurityGroupKey int
declare @CMFolderKey int
declare @CanAdd smallint
declare @CompanyKey int

select @SecurityGroupKey = SecurityGroupKey,
	@CompanyKey = CompanyKey
from tUser (nolock)
where UserKey = @UserKey

	
select @CMFolderKey = CMFolderKey
from tCMFolder (nolock)
where upper(FolderName) = upper(@FolderName)
and Entity = @Entity
and CompanyKey = @CompanyKey

if @CMFolderKey is null
	return -2
	
select @CanAdd = max(isnull(cast(CanAdd as smallint), -1))
from tCMFolder f (nolock)
	left join tCMFolderSecurity s (nolock) on f.CMFolderKey = s.CMFolderKey
where f.CMFolderKey = @CMFolderKey
and ((s.Entity = 'tUser' and s.EntityKey = @UserKey) or
	(s.Entity = 'tSecurityGroup' and s.EntityKey = @SecurityGroupKey) or
	(f.Entity = 'tUser' and f.UserKey = @UserKey))

if isnull(@CanAdd, 0) = 0 
	return -3
	
return @CMFolderKey
GO
