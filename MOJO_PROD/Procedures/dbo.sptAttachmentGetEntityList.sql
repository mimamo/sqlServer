USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentGetEntityList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAttachmentGetEntityList]
 (
  @AssociatedEntity varchar(50),
  @EntityKey int
 )
AS --Encrypt


/*
|| When      Who Rel     What
|| 5/26/10   GWG 10.530  Added Added by name to eliminate sql on client
*/


Select
 a.*, isnull(u.FirstName + ' ', '') + isnull(u.LastName, '') as AddedByName 
From
 tAttachment a (nolock) left outer join tUser u (nolock) on a.AddedBy = u.UserKey
Where
 AssociatedEntity = @AssociatedEntity AND
 EntityKey = @EntityKey
Order By
 FileName
 
 return 1
GO
