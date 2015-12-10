USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGetProjectList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptApprovalGetProjectList]
 (
  @ProjectKey int
 )
AS --Encrypt

/*
|| When      Who Rel     What
|| 2/20/08   CRG 1.0.0.0 Added StatusName
|| 10/20/08  GWG 10.0.1  Added active approver name
|| 12/1/09   GWG 10.5.1.4 (69246) Changed the sort order
|| 5/6/10    RLB 10.5.2.2 (80032) Added View other and approve order type.
|| 07/30/10  RLB 10.5.3.3  Corrected Approval Order Type
*/

	SELECT	a.*, u.FirstName + ' ' + u.LastName as ActiveApproverName,
		CASE Status
			WHEN 0 THEN 'Unsent'
			WHEN 1 THEN 'Pending Approvals'
			ELSE 'All Reviews Complete'
		END AS StatusName,
		Case ViewOtherComments
			WHEN 1 Then 'YES' ELSE 'NO'
		 END as ViewOtherCommentsName,
		case ApprovalOrderType
			WHEN 1 THEN 'To Everyone At Once'
			ELSE 'In The Selected Order'
		END as ApprovalOrderTypeName
	FROM	tApproval a (nolock)
		left outer join tUser u (nolock) on a.ActiveApprover = u.UserKey
	WHERE  ProjectKey = @ProjectKey
	ORDER BY DateCreated DESC
GO
