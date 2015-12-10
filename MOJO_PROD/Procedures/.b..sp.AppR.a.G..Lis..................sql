USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppReadGetList]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppReadGetList]
(
	@CompanyKey int,
	@UserKey int,
	@Area varchar(50),
	@AreaKey int
)
as

Declare @ProjectKey int


if @Area = 'DiaryThread'
BEGIN
	select 'Conversations' as GroupName, 'tActivity' as Entity, ActivityKey as EntityKey, a.Subject as Label, a.DateUpdated, ar.IsRead 
	from tActivity a (nolock)
	left outer join (Select * from tAppRead (nolock) Where UserKey = @UserKey) as ar on a.ActivityKey = ar.EntityKey and ar.Entity = 'tActivity'
	Where a.ActivityEntity = 'Diary' 
	and (a.RootActivityKey = @AreaKey or a.RootActivityKey = @AreaKey) 
	and ISNULL(ar.IsRead, 0) = 0 
END
GO
