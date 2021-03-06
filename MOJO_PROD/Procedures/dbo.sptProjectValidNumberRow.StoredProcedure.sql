USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectValidNumberRow]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectValidNumberRow]

	(
		@CompanyKey int,
		@ProjectNumber varchar(50),
		@UserKey int
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 06/11/08 GWG 10.004   Added fields for schedule direction, project type and description and modified where clause to always return a row if the number exists regardless
||						 of if the user is assigned. 
|| 11/02/08 GHL 10.012   Changed the way UserAssigned is calculated. Was getting Subquery returned more 1 value
||                       This in theory should not happen because there is one tAssignment rec per proj/user
||                       But we could have data corruption in tAssignment 	
|| 1/26/09  CRG 10.0.1.7 Added FlightInterval
|| 2/1/09   GWG 10.0.1.8 Added the work days
|| 02/10/10 MFT 10.5.1.8 Added OfficeKey & GLCompanyKey
|| 3/2/10   CRG 10.5.1.9 Added AutoIDTask and SimpleSchedule to query
|| 3/11/10  CRG 10.5.1.9 Added ClientKey to query
|| 12/16/11 GHL 10.5.5.1 Added Billable to query, in order to use it in the ItemRateManager
|| 11/05/14  RLB 10.5.8.6 Added changes for Abelson Taylor Enhancement AnyoneChargeTime
*/

	select p.ProjectKey
		  ,p.ProjectName
		  ,p.ProjectNumber
		  ,p.Closed
		  ,c.CustomerID
		  ,c.CompanyName
		  ,p.GetRateFrom
		  ,p.TimeRateSheetKey
		  ,p.GetMarkupFrom
		  ,p.ItemRateSheetKey
		  ,p.ItemMarkup as ProjectItemMarkup
		  ,p.IOCommission as ProjectIOCommission
		  ,p.BCCommission as ProjectBCCommission
		  ,p.ProjectStatusKey
		  ,p.ProjectTypeKey
			,p.OfficeKey
			,p.GLCompanyKey
		  ,p.Description
		  ,p.Template
		  ,p.ScheduleDirection
		  ,p.FlightInterval
		  ,p.WorkMon
		  ,p.WorkTue
		  ,p.WorkWed
		  ,p.WorkThur
		  ,p.WorkFri
		  ,p.WorkSat
		  ,p.WorkSun
		  ,c.HourlyRate
		  ,c.ItemMarkup as ClientItemMarkup
		  ,c.IOCommission as ClientIOCommission
		  ,c.BCCommission as ClientBCCommission
	      ,ps.ProjectStatusID
	      ,ps.ProjectStatus
	      ,ps.StatusCategory
	      ,ps.TimeActive
	      ,ps.ExpenseActive
	      ,ps.IsActive
	      ,ps.Locked
	      ,ps.OnHold
	      ,p.AutoIDTask
	      ,p.SimpleSchedule
	      ,p.ClientKey
		  ,p.AnyoneChargeTime
	      --,(ISNULL((Select 1 from tAssignment (nolock) Where ProjectKey = p.ProjectKey and UserKey = @UserKey), 0)) as UserAssigned
          , case when 
		  (select count(*) from tAssignment (nolock) Where ProjectKey = p.ProjectKey and UserKey = @UserKey) > 0 
		  then 1
          else 0 
		  end as UserAssigned 
		  ,case when p.NonBillable = 1 then 0 else 1 end as Billable

	from tProject p (nolock) 
		inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
		left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	where p.CompanyKey = @CompanyKey
	
	and	upper(p.ProjectNumber) = upper(@ProjectNumber)

	--return 1
GO
