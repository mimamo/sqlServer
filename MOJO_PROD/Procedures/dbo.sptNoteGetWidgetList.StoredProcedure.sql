USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGetWidgetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteGetWidgetList]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt

Select
	n.*
From
	tNote n (nolock)
Where
	Entity = @Entity and
	EntityKey = @EntityKey
Order By
	NoteOrder
GO
