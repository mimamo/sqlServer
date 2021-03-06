USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityLogActivity]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityLogActivity]
	@UserKey int
   ,@CompanyKey int
	
AS --Encrypt

/*
|| When     Who	Rel			What
|| 03/25/14 WDF 10.5.7.8	(202059) Added Logging for Security changes
*/
	DECLARE @ActionBy varchar(201)
	 
	CREATE TABLE #LogTable (RowNumber  int IDENTITY(1,1) not null
                           ,Activity varchar(3) null
                           ,Type varchar(15) null
                           ,Description varchar(1000) null
                           ,GroupName varchar(100) null
                           ,GroupKey int null
                           ,EntityKey int null)
	
	CREATE TABLE #SecurityAfterChanges (Type varchar(10) NULL, GroupKey INT NULL, EntityKey INT NULL)

--
--  Get all records after changes were made thru the Security Screen 
--
--  Get Rights info
--
	INSERT INTO #SecurityAfterChanges
	SELECT 'RIGHT' AS Type, EntityKey AS GroupKey, RightKey AS EntityKey FROM tRightAssigned WHERE EntityType = 'Security Group'
--
-- Get Dataset info
--
	INSERT INTO #SecurityAfterChanges
	SELECT 'DATASET' AS Type, SecurityGroupKey AS GroupKey, ViewKey AS EntityKey FROM tViewSecurityGroup
--
-- Get Project Request Form info
--
	INSERT INTO #SecurityAfterChanges
	SELECT 'REQUESTDEF' AS Type, SecurityGroupKey AS GroupKey, EntityKey FROM tSecurityAccess WHERE Entity = 'tRequestDef' and CompanyKey = @CompanyKey
--
-- Get Tracking Form info
--
	INSERT INTO #SecurityAfterChanges
	SELECT 'FORMDEF' AS Type, SecurityGroupKey AS GroupKey, EntityKey FROM tSecurityAccess WHERE Entity = 'tFormDef' and CompanyKey = @CompanyKey

--
--  This table contains the Security changes after the save
--  Rows inserted into the #LogTable after the left join will indicate records than have been Added
--
    INSERT INTO #LogTable
	SELECT  'ADD' AS Activity, af.Type
		   ,CASE af.Type
			   WHEN 'RIGHT' THEN (select ISNULL(Description, '') from tRight where RightKey = af.EntityKey)
			   WHEN 'DATASET' THEN (select ISNULL(Description, '') from #DataSetDesc where EntityKey = af.EntityKey)
			   WHEN 'REQUESTDEF' THEN (select ISNULL(RequestName, '') from tRequestDef where CompanyKey = @CompanyKey and RequestDefKey = af.EntityKey)
			   WHEN 'FORMDEF' THEN (select ISNULL(FormName, '') from tFormDef where CompanyKey = @CompanyKey AND FormDefKey = af.EntityKey)
			   ELSE 'Unknown'
			 END as Description
		   , sg.GroupName, af.GroupKey, af.EntityKey 
	  FROM #SecurityAfterChanges af LEFT JOIN #SecurityBeforeChanges bc ON (af.Type = bc.Type AND
																			af.GroupKey = bc.GroupKey AND
																			af.EntityKey = bc.EntityKey)
									LEFT JOIN tSecurityGroup sg ON (sg.SecurityGroupKey = af.GroupKey)                                                                        
	 WHERE bc.GroupKey IS NULL

--
--  The '#SecurityBeforeChanges' table was generated in SecurityGroup.vb and contains the Security changes before the save
--  Rows inserted into the #LogTable after the left join will indicate records than have been Deleted
--
    INSERT INTO #LogTable
	SELECT  'DEL' AS Activity, bc.Type
		   ,CASE bc.Type
			   WHEN 'RIGHT' THEN (select ISNULL(Description, '') from tRight where RightKey = bc.EntityKey)
			   WHEN 'DATASET' THEN (select ISNULL(Description, '') from #DataSetDesc where EntityKey = bc.EntityKey)
			   WHEN 'REQUESTDEF' THEN (select ISNULL(RequestName, '') from tRequestDef where CompanyKey = @CompanyKey and RequestDefKey = bc.EntityKey)
			   WHEN 'FORMDEF' THEN (select ISNULL(FormName, '') from tFormDef where CompanyKey = @CompanyKey and FormDefKey = bc.EntityKey)
			   ELSE 'Unknown'
			 END as Description
			, sg.GroupName, bc.GroupKey, bc.EntityKey
	  FROM #SecurityBeforeChanges bc LEFT JOIN #SecurityAfterChanges af ON (bc.Type = af.Type AND
																			bc.GroupKey = af.GroupKey AND
																			bc.EntityKey = af.EntityKey)
									 LEFT JOIN tSecurityGroup sg ON (sg.SecurityGroupKey = bc.GroupKey)
	  WHERE af.GroupKey IS NULL  
                   
--
--  Insert activity into tActionLog
--
	SELECT @ActionBy = FirstName + ' ' + LastName from tUser where UserKey = @UserKey

	INSERT INTO tActionLog (Entity
							,EntityKey
							,CompanyKey
							,ProjectKey
							,Action
							,ActionDate
							,ActionBy
							,Comments
							,Reference
							,SourceCompanyID
							,UserKey)
				
	SELECT  'Security' AS [Entity]
	       ,EntityKey
	       ,@CompanyKey
	       ,0 AS [ProjectKey]
           ,CASE Activity
              WHEN 'DEL' 
                 THEN
				   CASE Type
					 WHEN 'DATASET' THEN 'Security Data Set Removed' 
					 WHEN 'FORMDEF' THEN 'Security Tracking Form Removed' 
					 WHEN 'REQUESTDEF' THEN 'Security Project Request Form Removed' 
					 WHEN 'RIGHT' THEN 'Security Right Removed' 
		             ELSE ''
			       END
			  WHEN 'ADD'
			     THEN
				   CASE Type
					 WHEN 'DATASET' THEN 'Security Data Set Added' 
					 WHEN 'FORMDEF' THEN 'Security Tracking Form Added' 
					 WHEN 'REQUESTDEF' THEN 'Security Project Request Form Added' 
					 WHEN 'RIGHT' THEN 'Security Right Added' 
			         ELSE ''
				   END
		    END AS [Action]
		    ,GETUTCDATE() AS [ActionDate]
		    ,@ActionBy
            ,CASE Activity
              WHEN 'DEL' 
                 THEN
				   CASE Type
					 WHEN 'DATASET' THEN 'Data Set ''' + ISNULL(Description, EntityKey) + ''' was removed from Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
					 WHEN 'FORMDEF' THEN 'Tracking Form ''' + ISNULL(Description, EntityKey) + ''' was removed from Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
					 WHEN 'REQUESTDEF' THEN 'Project Request Form ''' + ISNULL(Description, EntityKey) + ''' was removed from Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
					 WHEN 'RIGHT' THEN 'Right ''' + ISNULL(Description, EntityKey) + ''' was removed from Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
		             ELSE ''
			       END
			  WHEN 'ADD'
			     THEN
				   CASE Type
					 WHEN 'DATASET' THEN 'Data Set ''' + ISNULL(Description, EntityKey) + ''' was added to Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
					 WHEN 'FORMDEF' THEN 'Tracking Form ''' + ISNULL(Description, EntityKey) + ''' was added to Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
					 WHEN 'REQUESTDEF' THEN 'Project Request Form ''' + ISNULL(Description, EntityKey) + ''' was added to Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
					 WHEN 'RIGHT' THEN 'Right ''' + ISNULL(Description, EntityKey) + ''' was added to Security Group ''' + ISNULL(GroupName, GroupKey) + ''''
			         ELSE ''
				   END
		    END AS [Comments]
		   ,GroupKey AS [Reference]
		   ,NULL as [SourceCompanyID]
		   ,@UserKey
	  FROM #LogTable

	RETURN 1
GO
