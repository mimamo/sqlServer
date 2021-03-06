USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutGetDetail]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutGetDetail]
	@LayoutKey int,
	@Entity varchar(50)
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/15/10  MFT 10.5.2.0 Created
*/

SELECT
	*
FROM
	tLayout (nolock)
WHERE
	LayoutKey = @LayoutKey

SELECT
	*
FROM
	tLayoutReport (nolock)
WHERE
	LayoutKey = @LayoutKey AND
	Entity = @Entity

SELECT
	ls.*
FROM
	tLayoutSection ls (nolock)
	INNER JOIN tLayoutReport lr (nolock)
		ON ls.LayoutReportKey = lr.LayoutReportKey
WHERE
	lr.LayoutKey = @LayoutKey AND
	lr.Entity = @Entity

SELECT
	li.*
FROM
	tLayoutItems li (nolock)
	INNER JOIN tLayoutReport lr (nolock)
		ON li.LayoutReportKey = lr.LayoutReportKey
WHERE
	lr.LayoutKey = @LayoutKey AND
	lr.Entity = @Entity
GO
