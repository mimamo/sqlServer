USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNoteGetWidgetLinks]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNoteGetWidgetLinks]
 (
  @Entity varchar(50),
  @EntityKey int
 )
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/25/12   CRG 10.5.6.0 (154738) Added ProjectKey, WebDavPath, WebDavFileName. Also added Project and Client fields for use by WebDAV
*/

SELECT 
	n.NoteKey,
	l.LinkKey, 
	l.AssociatedEntity, 
    l.EntityKey, 
    l.Type, 
    case 
		when l.Type = 1 then
			case 
				when l.WebDavFileName is not null then l.WebDavFileName
				else fi.FileName
			end
		when l.Type = 2 then l.URLName
		when l.Type = 3 then fo.Subject end as LinkName,
    l.AddedBy, 
    l.FileKey, 
    l.FormKey, 
    l.URL, 
    l.URLName, 
    l.URLDescription, 
	l.ProjectKey,
	l.WebDavPath,
	l.WebDavFileName,
    fi.FileName,
    fd.FormName, 
    fd.FormPrefix, 
    fo.FormNumber, 
    fo.FormDefKey,
    fo.Subject,
	p.ProjectNumber,
	p.ProjectName,
	c.CustomerID as ClientID,
	c.CompanyName as ClientName,
	p.FilesArchived,
	p.OfficeKey
FROM tLink l (nolock)
	INNER JOIN tNote n on n.NoteKey = l.EntityKey and l.AssociatedEntity = 'Note'
	LEFT OUTER JOIN tDAFile fi (nolock) on l.FileKey = fi.FileKey
	LEFT OUTER JOIN tForm fo (nolock) ON l.FormKey = fo.FormKey
	Left OUTER JOIN tFormDef fd (nolock) on fo.FormDefKey = fd.FormDefKey
	LEFT OUTER JOIN tProject p (nolock) on l.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey
Where
	n.Entity = @Entity AND
	n.EntityKey = @EntityKey
Order By
	l.Type, l.LinkKey
GO
