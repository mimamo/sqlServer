USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepSetupNextStep]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepSetupNextStep]
  
 (  
  @ApprovalStepKey int,  
  @NextApprovalStepKey int,  
  @DateActivated smalldatetime,  
  @DueDate smalldatetime  
 )  
  
AS  
  
  
/* Who Rel       When  What   
|| GWG  10.5.5.2  1/20/12   Added handling for the pause check box  
|| CRG  10.5.5.3  2/13/12   Added logic to pause the step if the next step does not have any users  
|| QMD  10.5.5.6  5/17/12   Tweaked logic to keep the review paused if there are no approvers on the next step  
|| GWG  10.5.6.0  09/25/12  Added in a call to rollup status label  
|| QMD  10.5.7.4  12/11/13  changed @Return datatype from tinyint to smallint
*/  
  
-- Close down the prior step  
  
Declare @Pause tinyint, @Paused tinyint, @Return smallint  
  
Select @Pause = ISNULL(Pause, 0), @Paused = ISNULL(Paused, 0), @Return = NULL from tApprovalStep (nolock) Where ApprovalStepKey = @ApprovalStepKey  
  
  
IF ISNULL(@NextApprovalStepKey, 0) > 0  
BEGIN  
 --If the next step does not have any users yet, pause it  
 IF NOT EXISTS  
   (SELECT 1  
   FROM tApprovalStepUser (nolock)  
   WHERE ApprovalStepKey = @NextApprovalStepKey)  
  BEGIN   
   SELECT @Pause = 1    
   SELECT @Paused = 0  
   SELECT @Return = -2  
  END  
END  
  
  
Update tApprovalStep Set Completed = 1, ActiveStep = 0, Paused = 0 Where ApprovalStepKey = @ApprovalStepKey  
Update tApprovalStepUser  
Set   
 ActiveUser = 0,  
 CompletedUser = 1  
Where  
 ApprovalStepKey = @ApprovalStepKey  
    
if @Pause = 1 and @Paused = 0  
BEGIN  
 --Setting Pasue = 1 here just in case this is being paused because the next step does not have any approval users  
 Update tApprovalStep Set Completed = 1, ActiveStep = 1, Paused = 1, Pause = 1 Where ApprovalStepKey = @ApprovalStepKey   
 return ISNULL(@Return,1)  
END    
  
Declare @Action int, @EnableRouting tinyint  
Select @Action = Action, @EnableRouting = EnableRouting from tApprovalStep (nolock) Where ApprovalStepKey = @NextApprovalStepKey  
  
Update tApprovalStep Set Completed = 0, ActiveStep = 1, Paused = 0 Where ApprovalStepKey = @NextApprovalStepKey  
  
if @Action = 3  
 Update tApprovalStepUser  
 Set   
  ActiveUser = 1,  
  CompletedUser = 0,  
  DateActivated = NULL,  
  DueDate = NULL  
 Where  
  ApprovalStepKey = @NextApprovalStepKey   
else  
 if @EnableRouting = 0  
  Update tApprovalStepUser  
  Set   
   ActiveUser = 1,  
   CompletedUser = 0,  
   DateActivated = @DateActivated,  
   DueDate = @DueDate  
  Where  
   ApprovalStepKey = @NextApprovalStepKey  
 else  
  Update tApprovalStepUser  
  Set   
   ActiveUser = 1,  
   CompletedUser = 0,  
   DateActivated = @DateActivated,  
   DueDate = @DueDate  
  Where  
   ApprovalStepKey = @NextApprovalStepKey and  
   DisplayOrder = 1  
  
exec sptApprovalStepUpdateStatusNames @ApprovalStepKey
GO
