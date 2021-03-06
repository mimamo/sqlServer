USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityReply]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityReply]
 @ParentActivityKey int,  
 @UserKey int,  
 @Notes text  
AS  
  
/*  
|| When      Who Rel      What  
|| 12/14/10  CRG 10.5.3.9 Created to reply to Diaries and To Dos  
|| 12/27/10  CRG 10.5.3.9 Now adding any "auto-subscribers" to the Email To list when a reply is submitted  
|| 2/15/2011 GWG 10.5.4.1 Custom field key should get copied in as a 0  
|| 6/24/11   RLB 10.5.4.5 (114999) Check if the Originator was added to ActvityEmail if not add them  
|| 12/13/11  CRG 10.5.5.1 Now returning -1 if no activity was added  
|| 01/20/12  QMD 10.5.5.2 Commented out the "auto-subscirbers" per GG because we were getting timeouts from the TaskManager code
|| 06/22/12  GHL 10.5.5.7 Added GL company update
|| 10/23/12  RLB 10.5.6.1 Added OriginalUser change for diary email tracking
|| 06/17/14  GWG 10.5.8.1 Modified the activity date to be the current date, not the date of the original activity
|| 09/02/14  GWG 10.5.8.3 Changed the reply so that it will use the user key passed in, not the person assigned to the original
|| 10/17/14  RLB 10.5.8.5 Marking read for the person who created the reply
*/  
  
 DECLARE @ActivityKey int   
  
 INSERT tActivity  
   (CompanyKey,  
   ParentActivityKey,  
   RootActivityKey,  
   Type,  
   Priority,  
   Subject,  
   ContactCompanyKey,  
   ContactKey,  
   UserLeadKey,  
   LeadKey,  
   ProjectKey,  
   StandardActivityKey,  
   AssignedUserKey,  
   OriginatorUserKey,  
   Outcome,  
   ActivityDate,  
   StartTime,  
   EndTime,  
   ReminderMinutes,  
   ActivityTime,  
   Completed,  
   DateCompleted,  
   Notes,  
   DateAdded,  
   DateUpdated,  
   Private,  
   CustomFieldKey,  
   AddedByKey,  
   UpdatedByKey,  
   VisibleToClient,  
   OldNoteKey,  
   OldParentNoteKey,  
   CMFolderKey,  
   TaskKey,  
   ActivityTypeKey,  
   SubjectIndex,  
   UID,  
   Sequence,  
   ActivityEntity,
   GLCompanyKey)  
 SELECT CompanyKey,  
   @ParentActivityKey,  
   RootActivityKey,  
   Type,  
   Priority,  
   Subject,  
   ContactCompanyKey,  
   ContactKey,  
   UserLeadKey,  
   LeadKey,  
   ProjectKey,  
   StandardActivityKey,  
   @UserKey,  
   OriginatorUserKey,  
   Outcome,  
   dbo.fFormatDateNoTime(GETDATE()),  
   StartTime,  
   EndTime,  
   ReminderMinutes,  
   ActivityTime,  
   Completed,  
   DateCompleted,  
   @Notes,  
   GETUTCDATE(),  
   GETUTCDATE(),  
   Private,  
   0,  
   @UserKey,  
   @UserKey,  
   VisibleToClient,  
   OldNoteKey,  
   OldParentNoteKey,  
   CMFolderKey,  
   TaskKey,  
   ActivityTypeKey,  
   SubjectIndex,  
   NEWID(),  
   0,  
   ActivityEntity,
   GLCompanyKey  
 FROM tActivity (nolock)  
 WHERE ActivityKey = @ParentActivityKey  
  
 SELECT @ActivityKey = @@IDENTITY  
  
 IF @ActivityKey IS NULL  
  RETURN -1  
  
 INSERT tActivityEmail  
   (ActivityKey,  
   UserKey,  
   UserLeadKey,
   OriginalUser)  
 SELECT @ActivityKey,  
   UserKey,  
   UserLeadKey,
   OriginalUser  
 FROM tActivityEmail (nolock)  
 WHERE ActivityKey = @ParentActivityKey  
  
 INSERT tActivityLink  
   (ActivityKey,  
   Entity,  
   EntityKey)  
 SELECT @ActivityKey,  
   Entity,  
   EntityKey  
 FROM tActivityLink (nolock)  
 WHERE ActivityKey = @ParentActivityKey  
  
 DECLARE @ProjectKey int,  
   @RootActivityKey int,  
   @ActivityEntity varchar(50),  
   @OriginatorUserKey int  
  
 SELECT @ProjectKey = ProjectKey,  
   @RootActivityKey = RootActivityKey,  
   @ActivityEntity = ActivityEntity,  
   @OriginatorUserKey = OriginatorUserKey  
 FROM tActivity (nolock)  
 WHERE ActivityKey = @ParentActivityKey  
  
  --mark the new activity as read for the person who created it
	exec sptAppReadMarkRead @UserKey, 'tActivity', @ActivityKey

 IF @ProjectKey > 0  
 BEGIN  
  
 if not exists(Select 1 from tActivityEmail (nolock) where ActivityKey = @ActivityKey  and UserKey = @OriginatorUserKey)  
  begin  
  
   INSERT tActivityEmail  
     (ActivityKey,  
     UserKey,  
     UserLeadKey,
	 OriginalUser)  
   SELECT @ActivityKey,  
     @OriginatorUserKey,  
     null,
	 0  
  
  end  
  
  --Loop through all activities in the thread and add any "auto-subscirbers" to the Email To list, if they're not already there  
  --DECLARE @LoopActivityKey int  
  --SELECT @LoopActivityKey = 0  
  
  --WHILE (1=1)  
  --BEGIN  
  -- SELECT @LoopActivityKey = MIN(ActivityKey)  
  -- FROM tActivity (nolock)  
  -- WHERE RootActivityKey = @RootActivityKey  
  -- AND  ActivityKey > @LoopActivityKey  
  
  -- IF @LoopActivityKey IS NULL  
  --  BREAK  
  
  -- INSERT tActivityEmail  
  --   (ActivityKey,  
  --   UserKey)  
  -- SELECT @LoopActivityKey,  
  --   UserKey  
  -- FROM tAssignment (nolock)  
  -- WHERE ProjectKey = @ProjectKey  
  -- AND  ((@ActivityEntity = 'Diary' AND SubscribeDiary = 1)  
  --   OR  
  --   (@ActivityEntity = 'ToDo' AND SubscribeToDo = 1))  
  -- AND  UserKey NOT IN (SELECT UserKey FROM tActivityEmail (nolock) WHERE ActivityKey = @LoopActivityKey)  
  --END  
 END  
  
 RETURN @ActivityKey
GO
