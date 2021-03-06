USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGetMaintList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteGetMaintList]

	(
		@AssociatedEntity varchar(50),
		@EntityKey int
	)

AS --Encrypt

Select
	ng.NoteGroupKey,
	ng.GroupName,
	ng.DisplayOrder as ngDisplayOrder,
	n.NoteKey,
	n.Subject,
	n.NoteField,
	n.DisplayOrder as nDisplayOrder,
	n.DateUpdated,
	u.FirstName + ' ' + u.LastName as UpdatedByName
From
	tNoteGroup ng (nolock)
	left outer join tNote n (nolock) on ng.NoteGroupKey = n.NoteGroupKey
	left outer join tUser u (nolock) on n.UpdatedBy = u.UserKey
Where
	ng.AssociatedEntity = @AssociatedEntity and
	ng.EntityKey = @EntityKey
Order By
	ng.DisplayOrder, n.DisplayOrder
GO
