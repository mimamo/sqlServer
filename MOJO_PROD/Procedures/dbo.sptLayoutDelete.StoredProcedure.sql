USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutDelete]
	@LayoutKey int
AS

/*
|| When      Who Rel      What
|| 1/5/10    CRG 10.5.1.6 Created
|| 03/23/10  MFT 10.5.2.0 Added tLayoutItems and tLayoutReport
|| 4/23/10   CRG 10.5.2.2 Added check for tLead
|| 11/04/11  GHL 10.5.4.9 (125627) Blanking now layout on tEstimate and tInvoice
||                        instead of preventing deletion
*/

	IF EXISTS (SELECT NULL FROM tProject (nolock) WHERE LayoutKey = @LayoutKey)
		RETURN -1
		
	IF EXISTS (SELECT NULL FROM tCompany (nolock) WHERE LayoutKey = @LayoutKey)
		RETURN -2

	IF EXISTS (SELECT NULL FROM tCampaign (nolock) WHERE LayoutKey = @LayoutKey)
		RETURN -3

	IF EXISTS (SELECT NULL FROM tPreference (nolock) WHERE DefaultLayoutKey = @LayoutKey)
		RETURN -4

	--IF EXISTS (SELECT NULL FROM tInvoice (nolock) WHERE LayoutKey = @LayoutKey)
	--	RETURN -5
	
	IF EXISTS (SELECT NULL FROM tLead (nolock) WHERE LayoutKey = @LayoutKey)
		RETURN -6
		
	--IF EXISTS (SELECT NULL FROM tEstimate (nolock) WHERE LayoutKey = @LayoutKey)
	--	RETURN -7

	DECLARE	@Entity varchar(50), @CompanyKey int
	
	SELECT	@Entity = Entity
	       ,@CompanyKey = CompanyKey
	FROM	tLayout (nolock)
	WHERE	LayoutKey = @LayoutKey
	
	IF @Entity = 'billing'
		DELETE	tLayoutBilling
		WHERE	LayoutKey = @LayoutKey
	
	DELETE tLayoutItems
	FROM tLayoutItems li (nolock)
	INNER JOIN tLayoutReport lr (nolock) ON li.LayoutReportKey = lr.LayoutReportKey
	WHERE LayoutKey = @LayoutKey
	
	DELETE tLayoutSection
	FROM tLayoutSection ls (nolock)
	INNER JOIN tLayoutReport lr (nolock) ON ls.LayoutReportKey = lr.LayoutReportKey
	WHERE LayoutKey = @LayoutKey
	
	DELETE tLayoutReport
	WHERE LayoutKey = @LayoutKey
	
	update tEstimate set LayoutKey = null where CompanyKey = @CompanyKey and LayoutKey = @LayoutKey
	update tInvoice set LayoutKey = null where CompanyKey = @CompanyKey and LayoutKey = @LayoutKey

	DELETE tLayout
	WHERE	LayoutKey = @LayoutKey
GO
