USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetApproverList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderGetApproverList]

	(
		@CompanyKey int,
		@OrderAmount money,
		@Type smallint,
		@UserKey int = NULL,
		@PurchaseOrderKey int = 0,
		@GLCompanyKey int = NULL
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/16/07   CRG 8.4.3   (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 11/30/09  MFT 10.515  Added POLimit to result
|| 02/10/10	 RLB 10.518  (74320)IO's and BO's where pullng PO limit i change them to pull the correct IO and BO limits
|| 02/04/14  KMC 10.577  (205066) Added GL Company Restrictions to restrict approvers
|| 03/18/14  KMC 10.578  (209624) Added GLCompanyKey to be passed in for when initial PO/BO/IO is being created and there isn't a record
||                       on tPurchaseOrder yet
|| 01/08/15  RLB 10.588  (241564) Removed the limits of POLimit > 0, IOLimit > 0 and BOLimit > 0
*/

declare @RestrictToGLCompany int

select @RestrictToGLCompany = ISNULL(p.RestrictToGLCompany, 0)
  from tPreference p (nolock)
 where p.CompanyKey = @CompanyKey

select @RestrictToGLCompany = ISNULL(@RestrictToGLCompany, 0)

if @PurchaseOrderKey > 0
	select @GLCompanyKey = GLCompanyKey
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey


if @Type = 0
	Select 
		UserKey,
		FirstName + ' ' + LastName as UserName,
		Email,
		POLimit
	From tUser (NOLOCK) 
	Where CompanyKey = @CompanyKey
	  and POLimit >= @OrderAmount
	  and (Active = 1 OR UserKey = @UserKey)
	  and (@RestrictToGLCompany = 0 or
		  (@RestrictToGLCompany = 1 AND UserKey IN (SELECT UserKey FROM tUserGLCompanyAccess (NOLOCK) WHERE GLCompanyKey = @GLCompanyKey))
		  )
	Order By FirstName, LastName
		
if @Type = 1
	Select 
		UserKey,
		FirstName + ' ' + LastName as UserName,
		Email,
		IOLimit
	From tUser (NOLOCK) 
	Where CompanyKey = @CompanyKey
	  and IOLimit >= @OrderAmount
	  and (Active = 1 OR UserKey = @UserKey)
	  and (@RestrictToGLCompany = 0 or
		  (@RestrictToGLCompany = 1 AND UserKey IN (SELECT UserKey FROM tUserGLCompanyAccess (NOLOCK) WHERE GLCompanyKey = @GLCompanyKey))
		  )
	Order By FirstName, LastName
	
if @Type = 2
	Select 
		UserKey,
		FirstName + ' ' + LastName as UserName,
		Email,
		BCLimit
	From tUser (NOLOCK) 
	Where CompanyKey = @CompanyKey
	  and BCLimit >= @OrderAmount
	  and (Active = 1 OR UserKey = @UserKey)
	  and (@RestrictToGLCompany = 0 or
		  (@RestrictToGLCompany = 1 AND UserKey IN (SELECT UserKey FROM tUserGLCompanyAccess (NOLOCK) WHERE GLCompanyKey = @GLCompanyKey))
		  )
	Order By FirstName, LastName
GO
