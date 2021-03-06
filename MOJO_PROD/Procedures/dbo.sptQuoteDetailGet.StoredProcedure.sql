USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteDetailGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteDetailGet]
	@QuoteDetailKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 07/06/07 BSH 8.5     (9659)Get OfficeName, DepartmentName
*/

		SELECT 
			qd.*, 
			q.Status, 
			t.TaskID,
			c.ClassID,
			p.ProjectNumber,
			i.ItemID,
			o.OfficeName,
			d.DepartmentName,
			(select fs.FieldSetName 
			 from
				tFieldSet fs (nolock),
				tObjectFieldSet ofs (nolock)
			where
				fs.FieldSetKey = ofs.FieldSetKey and
				ofs.ObjectFieldSetKey = qd.CustomFieldKey) as FieldSetName
		FROM 
			tQuoteDetail qd (nolock) 
			inner join tQuote q (nolock) on qd.QuoteKey = q.QuoteKey
			left outer join tTask t (nolock) on qd.TaskKey = t.TaskKey
			left outer join tClass c (nolock) on qd.ClassKey = c.ClassKey
			left join tProject p (nolock) on qd.ProjectKey = p.ProjectKey
			left join tItem i (nolock) on qd.ItemKey = i.ItemKey
			left outer join tOffice o (nolock) on qd.OfficeKey = o.OfficeKey
			left outer join tDepartment d (nolock) on qd.DepartmentKey = d.DepartmentKey
		WHERE
			QuoteDetailKey = @QuoteDetailKey

	RETURN 1
GO
