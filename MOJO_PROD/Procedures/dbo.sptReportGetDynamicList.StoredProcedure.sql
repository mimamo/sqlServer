USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReportGetDynamicList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReportGetDynamicList]

	 @ReportID varchar(50)
	,@UserKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 3/31/08   CRG 1.0.0.0 Added fields to select list instead of * because there are more columns in tReport now
*/

declare	@CompanyKey int
	
	select @CompanyKey = CompanyKey
	from tUser (nolock) 
	where UserKey = @UserKey

	create table #tRptTemp
				(
				ReportKey int null
				,ViewKey int null
				,Name varchar(255) null
				,ReportType smallint null
				,ReportFilter varchar(50) null
				,Definition text null
				,FieldDefinition text null
				,ConditionDefinition text null
				,Private int null
				,UserKey int null
				,CompanyKey int null
				,ReportGroupKey int null
				,ReportHeading1 varchar(200) null
				,ReportHeading1Align smallint null
				,ReportHeading2 varchar(200) null
				,ReportHeading2Align smallint null
				,Orientation smallint null
				,GroupBy smallint null
				,ShowConditions tinyint null
				,ReportID varchar(50) null
				,GroupByDefinition text null
				,LockedColumns int null
				,DefaultReportKey int null
				)
				
				
	--get any reports where the user is the owner, private and public
	insert #tRptTemp
	select	ReportKey
			,ViewKey
			,Name
			,ReportType
			,ReportFilter
			,Definition
			,FieldDefinition
			,ConditionDefinition
			,Private 
			,UserKey
			,CompanyKey
			,ReportGroupKey
			,ReportHeading1
			,ReportHeading1Align
			,ReportHeading2
			,ReportHeading2Align
			,Orientation
			,GroupBy
			,ShowConditions
			,ReportID 
			,GroupByDefinition
			,LockedColumns
			,DefaultReportKey
	from tReport r (nolock) 
	where CompanyKey = @CompanyKey
	and ReportID = @ReportID
	and ReportType = 2
	and UserKey = @UserKey
	
	--get any reports where the user has access through a security group
	insert #tRptTemp
	select	r.ReportKey
			,ViewKey
			,Name
			,ReportType
			,ReportFilter
			,Definition
			,FieldDefinition
			,ConditionDefinition
			,Private 
			,r.UserKey
			,r.CompanyKey
			,ReportGroupKey
			,ReportHeading1
			,ReportHeading1Align
			,ReportHeading2
			,ReportHeading2Align
			,Orientation
			,GroupBy
			,ShowConditions
			,ReportID 
			,GroupByDefinition
			,LockedColumns
			,DefaultReportKey
	from tReport r (nolock) inner join tRptSecurityGroup rsg (nolock) on r.ReportKey = rsg.ReportKey
	inner join tUser u (nolock) on rsg.SecurityGroupKey = u.SecurityGroupKey
	where r.CompanyKey = @CompanyKey
	and r.ReportID = @ReportID
	and r.ReportType = 2
	and u.UserKey = @UserKey
	and r.ReportKey not in (select ReportKey
							from tReport r (nolock) 
							where CompanyKey = @CompanyKey
							and ReportID = @ReportID
							and ReportType = 2
							and UserKey = @UserKey)
	
	
	select * 
	from #tRptTemp
	order by Name
GO
