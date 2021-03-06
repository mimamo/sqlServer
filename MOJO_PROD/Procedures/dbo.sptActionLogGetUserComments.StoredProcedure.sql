USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActionLogGetUserComments]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptActionLogGetUserComments]
     @CompanyKey INT
	,@Entity VARCHAR(50)
	,@EntityKey INT
	
AS --Encrypt

/*
|| When     Who Rel       What
|| 07/10/14 WDF 10.8.5.2  New (217609) - Pull User supplied Comments for 'Expense Report'
*/

DECLARE @RejectedMsg varchar(35), @ApprovedMsg varchar(35), @UnapprovedMsg varchar(35)

SET @RejectedMsg = 'was rejected with comment:'
SET @ApprovedMsg = 'was approved with comment:'
SET @UnapprovedMsg = 'was unapproved with comment:'

	SELECT UserKey, Action, ActionBy, ActionDate, Reference, Comments
		,CASE  
			 WHEN Comments like '%' + @RejectedMsg + '%'
			  or  Comments like '%' + @ApprovedMsg + '%'
			  or  Comments like '%' + @UnapprovedMsg + '%'
			     THEN
					 CASE Action
						 WHEN 'Rejected' THEN RTRIM(LTRIM(SUBSTRING(Comments, CHARINDEX(@RejectedMsg, Comments) + LEN(@RejectedMsg) + 1, LEN(Comments))))
						 WHEN 'Approved' THEN RTRIM(LTRIM(SUBSTRING(Comments, CHARINDEX(@ApprovedMsg, Comments) + LEN(@ApprovedMsg) + 1, LEN(Comments))))
						 WHEN 'Unapproved' THEN RTRIM(LTRIM(SUBSTRING(Comments, CHARINDEX(@UnapprovedMsg, Comments) + LEN(@UnapprovedMsg) + 1, LEN(Comments))))
						 ELSE Action
				     END
             ELSE NULL
         END AS UserComments
	  FROM tActionLog (NOLOCK)
     WHERE CompanyKey = @CompanyKey 
       AND Entity = @Entity 
       AND EntityKey = @EntityKey
    ORDER BY ActionDate
GO
