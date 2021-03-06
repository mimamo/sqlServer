USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectGetJacket]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectGetJacket]
 @ProjectKey int

AS --Encrypt

/*
|| When     Who Rel   What
|| 08/31/07 GHL 8.435 (12495) Added description 9 to 12 
|| 12/1/09	RLB 10514 (69264) Added Cell Phone from contact since the field was on the print out but not passed in.
|| 11/2/10  RLB 10537 (91984) Added Campaign name
*/

  SELECT pr.*
	,o.OfficeName
	,cl.CustomerID
	,cl.CompanyName
	,cl.CustomerID + ' ' + cl.CompanyName as ClientFullName
	,a.Address1
	,a.Address2
	,a.Address3
	,a.City
	,a.State
	,a.PostalCode
	,a.Country
	,pc.FirstName + ' ' + pc.LastName as BillingContactName
	,pc.Email
	,cp.CampaignName
	,ISNULL(pc.Phone1, cl.Phone) as Phone
	,pc.Cell as Cell
	,ISNULL(pc.Fax, cl.Fax) as Fax
	,am.FirstName + ' ' + am.LastName as AccountManagerName
	,ps.ProjectStatus
	,cb.Subject1
	,cb.Description1
	,cb.Subject2
	,cb.Description2
	,cb.Subject3
	,cb.Description3
	,cb.Subject4
	,cb.Description4
	,cb.Subject5
	,cb.Description5
	,cb.Subject6
	,cb.Description6
	,cb.Subject7
	,cb.Description7
	,cb.Subject8
	,cb.Description8
	,cb.Subject9
	,cb.Description9
	,cb.Subject10
	,cb.Description10
	,cb.Subject11
	,cb.Description11
	,cb.Subject12
	,cb.Description12
	,pt.ProjectTypeName
    FROM tProject pr (nolock)
	left outer join tCompany cl (nolock) on pr.ClientKey = cl.CompanyKey
	left outer join tAddress a (nolock) on cl.DefaultAddressKey = a.AddressKey
	left outer join tUser am (nolock) on pr.AccountManager = am.UserKey
	left outer join tUser pc (nolock) on pr.BillingContact = pc.UserKey
	inner join tProjectStatus ps (nolock) on pr.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tProjectCreativeBrief cb (nolock) on pr.ProjectKey = cb.ProjectKey
	left outer join tOffice o (nolock) on pr.OfficeKey = o.OfficeKey
	left outer join tProjectType pt (nolock) on pr.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCampaign cp (nolock) on pr.CampaignKey = cp.CampaignKey
  WHERE
   pr.ProjectKey = @ProjectKey
GO
