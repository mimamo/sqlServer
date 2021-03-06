USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestGetList]

	@CompanyKey int,
	@Status int,
	@ClientKey int,
	@RequestDefKey int,
	@RequestKey int = null
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/14/08   CRG 1.0.0.0  Added default sorting by RequestID
|| 9/5/08    CRG 10.0.0.8 Added optional RequestID parameter for use when a project is created from a Request.
|| 9/22/08   CRG 10.0.0.9 Changed RequestID to RequestKey
|| 6/13/13   WDF 10.5.6.9 (181051) Added 'Cancelled' to Status Case Statement
*/

If @RequestDefKey = 0
	If @Status = 0
		if @ClientKey = 0
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then 
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE tRequest.CompanyKey = @CompanyKey
			ORDER BY RequestID
		else
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.ClientKey = @ClientKey
			ORDER BY RequestID
	else If @Status = 5
		if @ClientKey = 0
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.DateCompleted is not null
			ORDER BY RequestID
		else
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.ClientKey = @ClientKey and
			tRequest.DateCompleted is not null
			ORDER BY RequestID
	else
		if @ClientKey = 0
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.Status = @Status and
			tRequest.DateCompleted is null
			ORDER BY RequestID
		else
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			(tRequest.CompanyKey = @CompanyKey and
			tRequest.ClientKey = @ClientKey and
			tRequest.Status = @Status and
			tRequest.DateCompleted is null)
			OR tRequest.RequestKey = @RequestKey
			ORDER BY RequestID
else
	If @Status = 0
		if @ClientKey = 0
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.RequestDefKey = @RequestDefKey
			ORDER BY RequestID
		else
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.ClientKey = @ClientKey and
			tRequest.RequestDefKey = @RequestDefKey
			ORDER BY RequestID
	else If @Status = 5
		if @ClientKey = 0
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.RequestDefKey = @RequestDefKey and
			tRequest.DateCompleted is not null
			ORDER BY RequestID
		else
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.ClientKey = @ClientKey and
			tRequest.RequestDefKey = @RequestDefKey and
			tRequest.DateCompleted is not null
			ORDER BY RequestID
	else
		if @ClientKey = 0
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.Status = @Status and
			tRequest.RequestDefKey = @RequestDefKey and
			tRequest.DateCompleted is null
			ORDER BY RequestID
		else
			SELECT tRequest.*
				,c.CustomerID
				,c.CompanyName
				,rd.RequestName
				,Case When tRequest.DateCompleted is null then
					Case Status 
					When 1 then
						Case tRequest.Cancelled
							When 0 then 'Not Sent For Approval'
							When 1 then 'Cancelled'
							else 'Not Sent For Approval'
						end
					When 2 then 'Sent For Approval'
					When 3 then 'Rejected'
					When 4 then 'Approved'
					end
				else
					'Completed' end as StatusText
			FROM tRequest (NOLOCK) 
				inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
				inner join tRequestDef rd (NOLOCK) on tRequest.RequestDefKey = rd.RequestDefKey
			WHERE
			tRequest.CompanyKey = @CompanyKey and
			tRequest.ClientKey = @ClientKey and
			tRequest.Status = @Status and
			tRequest.RequestDefKey = @RequestDefKey and
			tRequest.DateCompleted is null
			ORDER BY RequestID			
			
	RETURN 1
GO
