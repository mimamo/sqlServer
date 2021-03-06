USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCheckAccess]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckAccess]
  @UserKey INT,
  @CompanyKey INT,
  @Entity VARCHAR(20),
  @EntityKey INT,
  @Guest INT = 0

  /*
  || When       Who Rel        What
  || 03/15/14   QMD 10.5.7.8   Check access based on key
  || 07/11/14   QMD 10.5.8.2   If client vendor login return false for now
  || 07/31/14   MFT 10.5.8.2   Added Contact check
  || 08/12/14   MAS 10.5.8.3   Added @Action param - default to null.  Actions types = get, update, delete
  || 08/29/14   RLB 10.5.8.3   Added company  check and removed Action parm per MAS's request
  || 08/29/14   MFT 10.5.8.3   Removed admin and right check from Contact; Changed Entity to tUser_Contact
  || 09/18/14   RLB 10.5.8.4   Removed all right checks 
  || 09/26/14   QMD 10.5.8.4   Added tLead for opportunities
  || 09/29/14   RLB 10.5.8.4   Fixed Company Restrict GL Access
  || 10/07/14   RLB 10.5.8.4   changed Contact Company Restict GL Access
  || 10/27/14   GWG 10.5.8.5   Added check for listings and custom reports
  || 10/30/14   MAS 10.5.8.5   Added check for credit card voucher (vPayment)
  || 12/19/14   CRG 10.5.8.7   Added tTimesheet entity
  || 01/07/15   CRG 10.5.8.8   Added tUser_Employee entity
  || 02/05/15   MAS 10.5.8.9   Added tCCEntry entity
  || 02/13/15   CRG 10.5.8.9   Now verifying that the user is active and belongs to the company
  || 03/02/15	MAS 10.5.9.0   Added Guest flag 
  || 03/15/15   GWG 10.5.9.0   Added checks for folders

  If you add a section make sure to add the Public Const section of rights.vb

  */

AS --Encrypt

DECLARE @ProjectKey INT, @GLCompanyKey INT, @TaskKey INT, @Status INT, @SecurityGroupKey INT, @RightKey INT, @HasRight INT, @UseFolders TINYINT, @FolderKey INT

	IF (EXISTS 
			(SELECT  1
			 FROM	tUser (nolock)
			 WHERE	((CompanyKey = @CompanyKey OR OwnerCompanyKey = @CompanyKey)
				AND	UserKey = @UserKey
				AND	Active = 1
				AND	ISNULL(ClientVendorLogin, 0) = 0
			))
			OR @Guest = 1 )
	BEGIN	
		IF @Entity = 'tReviewRound'
			BEGIN

				IF EXISTS(	SELECT *
							FROM tReviewRound rr (NOLOCK) INNER JOIN tReviewDeliverable rd (NOLOCK) ON rr.ReviewDeliverableKey = rd.ReviewDeliverableKey
								INNER JOIN tUser u (NOLOCK) ON u.CompanyKey = rd.CompanyKey
							WHERE rr.ReviewRoundKey = @EntityKey
								AND rd.CompanyKey = @CompanyKey
								AND u.UserKey = @UserKey )
					RETURN 1
				ELSE
					RETURN -1

			END

		IF @Entity = 'tReviewDeliverable'
			BEGIN

				IF EXISTS(	SELECT *
							FROM tReviewDeliverable rd (NOLOCK) INNER JOIN tUser u (NOLOCK) ON u.CompanyKey = rd.CompanyKey
							WHERE rd.ReviewDeliverableKey = @EntityKey
								AND rd.CompanyKey = @CompanyKey
								AND u.UserKey = @UserKey )
					RETURN 1

				ELSE
					RETURN -1

			END

		IF @Entity = 'tProject'
			BEGIN
				IF EXISTS(SELECT 1  FROM tProject (nolock) WHERE CompanyKey = @CompanyKey AND ProjectKey = @EntityKey)
				begin
					SELECT @GLCompanyKey = GLCompanyKey
					FROM tProject (nolock)
					WHERE CompanyKey = @CompanyKey 
					AND ProjectKey = @EntityKey

					IF EXISTS(SELECT * FROM tPreference (NOLOCK) WHERE CompanyKey = @CompanyKey AND ISNULL(RestrictToGLCompany,0) = 1)
						IF NOT EXISTS (SELECT * FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey AND GLCompanyKey = @GLCompanyKey)
											RETURN -1
					RETURN 1
				end
				ELSE

					RETURN -1

			END


		IF @Entity = 'tTaskUser'
			BEGIN

				IF EXISTS ( SELECT	*
							FROM	tTaskUser tu (NOLOCK) INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
										INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
							WHERE	tu.TaskUserKey = @EntityKey
									AND p.CompanyKey = @CompanyKey)
					RETURN 1
				ELSE
					RETURN -1

			END

		IF @Entity = 'tActivity'
			BEGIN

				IF EXISTS ( SELECT	*
							FROM	tActivity a (NOLOCK)
							WHERE	a.ActivityKey = @EntityKey
									AND a.CompanyKey = @CompanyKey)
					BEGIN
							-- GL restriction
						IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(RestrictToGLCompany,0) = 1)
							begin
								SELECT	@GLCompanyKey = a.GLCompanyKey
								FROM	tActivity a (NOLOCK)
								WHERE	a.ActivityKey = @EntityKey
						
								IF NOT EXISTS (SELECT * FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey AND GLCompanyKey = @GLCompanyKey)
									RETURN -1
							end
							
						IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(UseActivityFolders,0) = 1)
							begin
								SELECT	@FolderKey = ISNULL(a.CMFolderKey, 0)
								FROM	tActivity a (NOLOCK)
								WHERE	a.ActivityKey = @EntityKey
								
								if @FolderKey = 0
									return 1
								
								Select @SecurityGroupKey = SecurityGroupKey from tUser (NOLOCK) Where UserKey = @UserKey
						
								IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @SecurityGroupKey AND Entity = 'tSecurityGroup' and CMFolderKey = @FolderKey and CanView = 1)
									IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @UserKey AND Entity = 'tUser' and CMFolderKey = @FolderKey and CanView = 1)
										RETURN -2
							end
				
						RETURN 1									
					END
				ELSE
					RETURN -1

			END

		IF @Entity = 'tTask'
			BEGIN

				IF EXISTS ( SELECT	*
							FROM	tTask t (NOLOCK) INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
							WHERE	t.TaskKey = @EntityKey
									AND p.CompanyKey = @CompanyKey)
					RETURN 1
				ELSE
					RETURN -1

			END
		
		IF @Entity = 'tUser_Contact'
			IF EXISTS(SELECT 1 FROM tUser (nolock) WHERE UserKey = @EntityKey AND OwnerCompanyKey = @CompanyKey)
				BEGIN
					SELECT
						@GLCompanyKey = GLCompanyKey
					FROM tUser (nolock)
					WHERE UserKey = @EntityKey
				
					-- GL restriction
					IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(RestrictToGLCompany,0) = 1)
						BEGIN
							IF NOT EXISTS (SELECT * FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey AND GLCompanyKey in
											(select GLCompanyKey from tGLCompanyAccess where Entity = 'tUser' and EntityKey = @EntityKey and CompanyKey = @CompanyKey)
										)
								RETURN -1
						END
						
					IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(UseContactFolders,0) = 1)
							begin
								SELECT	@FolderKey = ISNULL(a.CMFolderKey, 0)
								FROM	tUser a (NOLOCK)
								WHERE	a.UserKey = @EntityKey
								
								if @FolderKey = 0
									return 1
									
								Select @SecurityGroupKey = SecurityGroupKey from tUser (NOLOCK) Where UserKey = @UserKey
						
								IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @SecurityGroupKey AND Entity = 'tSecurityGroup' and CMFolderKey = @FolderKey and CanView = 1)
									IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @UserKey AND Entity = 'tUser' and CMFolderKey = @FolderKey and CanView = 1)
										RETURN -1
							end
				
					RETURN 1
				END
			ELSE 
				RETURN -1

		IF @Entity = 'tUser_Employee'
			BEGIN
				IF EXISTS
						(SELECT	1 
						FROM	tUser (nolock) 
						WHERE	UserKey = @EntityKey 
						AND		
							(CompanyKey = @CompanyKey
							OR
							(OwnerCompanyKey = @CompanyKey
							AND		UserID is not null 
							AND		Password is not null 
							AND		Active = 1))
						)
					BEGIN
						-- GL restriction
						IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(RestrictToGLCompany,0) = 1)
							BEGIN
								IF NOT EXISTS 
										(SELECT	1 
										FROM	tUser (nolock) 
										WHERE	UserKey = @EntityKey 
										AND		GLCompanyKey in
													(select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
										)
									RETURN -1
							END
					
						RETURN 1
					END
					ELSE 
						RETURN -1
			END

		IF @Entity = 'tExpenseEnvelope'
			BEGIN			
				--  Does this ExpenseEnvelope belong to this company?
				IF EXISTS ( SELECT 1 FROM tExpenseEnvelope e (NOLOCK) WHERE	e.ExpenseEnvelopeKey = @EntityKey AND e.CompanyKey = @CompanyKey)
					RETURN 1
				ELSE
					RETURN -1 -- Default to no access
			END	

		IF @Entity = 'tCompany'
			BEGIN
				--  Does this company belong to this ownercompany?
				IF EXISTS ( SELECT 1 FROM tCompany c (NOLOCK) WHERE	c.CompanyKey = @EntityKey AND c.OwnerCompanyKey = @CompanyKey)
					begin					


						IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(RestrictToGLCompany,0) = 1)
							begin
								-- since there is no GL Company on a company check GLCompanyAccess
								IF NOT EXISTS (SELECT * FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey AND GLCompanyKey in 
												  (select GLCompanyKey from tGLCompanyAccess where Entity = 'tCompany' and EntityKey = @EntityKey and CompanyKey = @CompanyKey)
											)
									RETURN -1
							end

						
						IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(UseCompanyFolders,0) = 1)
							begin
								SELECT	@FolderKey = ISNULL(a.CMFolderKey, 0)
								FROM	tCompany a (NOLOCK)
								WHERE	a.CompanyKey = @EntityKey
								
								if @FolderKey = 0
									return 1
									
								Select @SecurityGroupKey = SecurityGroupKey from tUser (NOLOCK) Where UserKey = @UserKey
						
								IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @SecurityGroupKey AND Entity = 'tSecurityGroup' and CMFolderKey = @FolderKey and CanView = 1)
									IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @UserKey AND Entity = 'tUser' and CMFolderKey = @FolderKey and CanView = 1)
										RETURN -1
							end
							
						return 1
					end
				ELSE
					RETURN -1
			END

		IF @Entity = 'tLead'
			BEGIN	
				--  Does this opportunity belong to this company?		
				IF EXISTS ( SELECT 1 FROM tLead (NOLOCK) WHERE LeadKey = @EntityKey AND CompanyKey = @CompanyKey )	
				BEGIN
					IF EXISTS(SELECT * FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(UseActivityFolders,0) = 1)
						begin
							SELECT	@FolderKey = ISNULL(a.CMFolderKey, 0)
							FROM	tLead a (NOLOCK)
							WHERE	a.LeadKey = @EntityKey
							
							if @FolderKey = 0
								return 1
									
							Select @SecurityGroupKey = SecurityGroupKey from tUser (NOLOCK) Where UserKey = @UserKey
					
							IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @SecurityGroupKey AND Entity = 'tSecurityGroup' and CMFolderKey = @FolderKey and CanView = 1)
								IF NOT EXISTS (SELECT 1 FROM tCMFolderSecurity (nolock) WHERE EntityKey = @UserKey AND Entity = 'tUser' and CMFolderKey = @FolderKey and CanView = 1)
									RETURN -1
						end	
						RETURN 1
				END
				ELSE
					RETURN -1 -- Default to no access
			END		
			
			
		IF @Entity = 'tReport'
			BEGIN
				if @EntityKey <=0
					return 1
			
				IF EXISTS ( SELECT 1 FROM tReport (NOLOCK) WHERE ReportKey = @EntityKey AND CompanyKey = @CompanyKey )
					BEGIN				
						IF EXISTS ( SELECT 1 FROM tUser (NOLOCK) WHERE UserKey = @UserKey AND Administrator = 1 )
							RETURN 1
							
						IF EXISTS ( SELECT 1 FROM tReport (NOLOCK) WHERE ReportKey = @EntityKey AND Private = 1 AND UserKey = @UserKey )
							RETURN 1
							
						IF EXISTS ( SELECT 1 FROM tRptSecurityGroup rsg (NOLOCK) 
										INNER JOIN tUser u (NOLOCK) on rsg.SecurityGroupKey = u.SecurityGroupKey
										WHERE rsg.ReportKey = @EntityKey AND u.UserKey = @UserKey )
							RETURN 1
					
						RETURN 1
					END

					RETURN -1 -- Default to no access
			END
			
		IF @Entity = 'vPayment'
			BEGIN

				IF EXISTS(	SELECT 1
							FROM tVoucher v (NOLOCK)
							WHERE v.VoucherKey = @EntityKey	AND v.CompanyKey = @CompanyKey )
					RETURN 1
				ELSE
					RETURN -1
			END
			
		IF @Entity = 'tTimesheet'
			BEGIN
				IF EXISTS ( SELECT	1
							FROM	tTimeSheet (nolock)
							WHERE	TimeSheetKey = @EntityKey AND CompanyKey = @CompanyKey)
					RETURN 1
				ELSE
					RETURN -1
			END

		IF @Entity = 'tCCEntry'
			BEGIN
				IF EXISTS(	SELECT *
							FROM  tGLAccount (NOLOCK) 
							WHERE GLAccountKey = @EntityKey	AND  CompanyKey = @CompanyKey)
					RETURN 1
				ELSE
					RETURN -1

			END		
	END
	ELSE
	BEGIN
		--Invalid user
		RETURN -1
	END
GO
