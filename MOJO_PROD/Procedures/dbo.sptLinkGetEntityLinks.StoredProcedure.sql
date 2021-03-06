USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLinkGetEntityLinks]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptLinkGetEntityLinks]
 (
  @AssociatedEntity varchar(50),
  @EntityKey int
 )
AS --Encrypt

/*
|| When      Who Rel      What
|| 03/26/08  CRG 1.0.0.0  Added LinkName
|| 9/25/12   CRG 10.5.6.0 (154738) Added ProjectKey, WebDavPath, WebDavFileName
*/

SELECT 
	l.LinkKey, 
	l.AssociatedEntity, 
    l.EntityKey, 
    l.Type, 
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
    case 
		when l.Type = 1 then
			case 
				when l.WebDavFileName is not null then l.WebDavFileName
				else fi.FileName
			end
		when l.Type = 2 then l.URLName
		when l.Type = 3 then fo.Subject end as LinkName
FROM tLink l (nolock)
	LEFT OUTER JOIN tDAFile fi (nolock) on l.FileKey = fi.FileKey
	LEFT OUTER JOIN tForm fo (nolock) ON l.FormKey = fo.FormKey
	Left OUTER JOIN tFormDef fd (nolock) on fo.FormDefKey = fd.FormDefKey
Where
	l.AssociatedEntity = @AssociatedEntity AND
	l.EntityKey = @EntityKey
Order By
	l.Type, l.LinkKey
 
return
GO
