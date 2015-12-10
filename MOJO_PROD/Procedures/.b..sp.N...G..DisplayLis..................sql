USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGetDisplayList]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteGetDisplayList]

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
	tNote n (nolock)
	Inner Join tNoteGroup ng (nolock) on n.NoteGroupKey = ng.NoteGroupKey
	Inner Join tUser u (nolock) on n.UpdatedBy = u.UserKey
Where
	ng.AssociatedEntity = @AssociatedEntity and
	ng.EntityKey = @EntityKey and
	ng.Active = 1 and
	(n.InactiveDate > GETDATE() or n.InactiveDate is null)
Order By
	ng.DisplayOrder, n.DisplayOrder
GO
