USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserServiceGetList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserServiceGetList]

	(
		@UserKey int,
		@Mode smallint = 1
	)

AS --Encrypt

  /*
  || When      Who Rel    What
  || 12/6/10   RLB 10.539 (94833) Changed to just pull User Default Service
  || 1/15/14  GWG 10.576 Added a second mode
   */


if @Mode = 1

	Select 
		u.UserKey,
		u.DefaultServiceKey as ServiceKey,
		s.Description
	from tUser u (nolock)
	inner Join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
	Where
		u.UserKey = @UserKey
	Order By
		s.ServiceCode



if @Mode = 2
	-- this mode is used to get the keys for a person's assigned services
	Select 
		s.*
	from tUserService u (nolock)
	inner Join tService s (nolock) on u.ServiceKey = s.ServiceKey
	Where
		u.UserKey = @UserKey
GO
