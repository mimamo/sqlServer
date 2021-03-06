USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBoyScoutsProjectData]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBoyScoutsProjectData]
	@StartDate smalldatetime,
	@EndDate smalldatetime
AS

/*
|| When      Who Rel      What
|| 4/17/13   CRG 10.5.6.7 (169622) Created for customization
*/

	--Custom Field logic copied from Custom Report code
	create table #cf1 
			(CustomFieldKey int null, 
			[CF_ItemNumber] varchar(8000) null)

	create index tempcfidx1 on #cf1(CustomFieldKey)

	Insert Into #cf1 (CustomFieldKey) 
	Select	CustomFieldKey 
	from	tProject (nolock) 
	Where	CustomFieldKey > 0 
	and		CompanyKey = 104940

	update	#cf1 
	set		[CF_ItemNumber] = FieldValue 
	From	vCFValues 
	Where	vCFValues.FieldName = 'ItemNumber' 
	and		EntityKey = 104940 
	and		Entity = 'General' 
	and		#cf1.CustomFieldKey = vCFValues.CustomFieldKey 
	AND		LEN(ISNULL(FieldValue, '')) > 0

	SELECT	ProjectNumber, 
			ISNULL(#cf1.CF_ItemNumber, '') AS CF_ItemNumber
	FROM	tProject (nolock)
	LEFT OUTER JOIN #cf1 ON tProject.CustomFieldKey = #cf1.CustomFieldKey 
	WHERE	CompanyKey = 104940
	AND		ProjectStatusKey <> 1622 --TEMPLATE
	AND		CreatedDate BETWEEN @StartDate AND @EndDate
	ORDER BY ProjectNumber
GO
