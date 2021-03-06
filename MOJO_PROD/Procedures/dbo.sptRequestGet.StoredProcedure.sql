USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestGet]
	@RequestKey int

AS --Encrypt

 /*
  || When     Who Rel       What
  || 05/29/12 QMD 10.5.5.6  (143615) Added tCampaign left join
  || 07/20/12 MFT 10.5.5.8  (105753) Added SendConfirmation & ConfirmationMessage
  || 08/28/12 KMC 10.5.5.9  (151486) Added PrintSpecOnSeparatePages
  || 03/25/15 WDF 10.5.9.0  (250961) Added CreatedBy and UpdatedBy
  || 04/23/15 GHL 10.5.9.1  (250967) Added Reject Reason for Kohl's enhancement
 */

		SELECT tRequest.*
			,u.FirstName + ' ' + u.LastName as CreatedBy
			,u2.FirstName + ' ' + u2.LastName as UpdatedBy
			,tRequestDef.RequestName
			,tRequestDef.DisplayProjectFields
			,ISNULL(tRequestDef.SendConfirmation, 0) AS SendConfirmation
			,tRequestDef.ConfirmationMessage
			,c.CustomerID
			,c.CompanyName
			,ca.CampaignKey
			,(Select count(*) from tSpecSheet (NOLOCK) Where Entity = 'ProjectRequest' and EntityKey = @RequestKey) as StepCount
			,tRequestDef.PrintSpecOnSeparatePages
			,rrr.ReasonName AS RejectReasonName
		FROM tRequest (NOLOCK) 
			inner join tRequestDef (NOLOCK) on tRequest.RequestDefKey = tRequestDef.RequestDefKey
			inner join tCompany c (NOLOCK) on tRequest.ClientKey = c.CompanyKey
			left join tCampaign ca (NOLOCK) on tRequest.CampaignID = ca.CampaignID AND tRequest.CompanyKey = ca.CompanyKey
			left join tUser u (nolock) on tRequest.EnteredByKey = u.UserKey
			left join tUser u2 (nolock) on tRequest.UpdatedByKey = u2.UserKey
			LEFT JOIN tRequestRejectReason rrr (NOLOCK) ON tRequest.RequestRejectReasonKey = rrr.RequestRejectReasonKey
		WHERE
			RequestKey = @RequestKey

	RETURN 1
GO
