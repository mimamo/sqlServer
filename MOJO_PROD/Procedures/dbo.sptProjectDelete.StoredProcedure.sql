USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectDelete]
 @ProjectKey int
AS --Encrypt

/*
|| When     Who Rel    What
|| 01/18/07 RTC 8.401  Added validation to prevent deletion when Project is specified on a Media Estimate
|| 03/01/07 GHL 8.404  Added project rollup
|| 10/22/07 CRG 8.5    (13583) Added delete of tProjectSplitBilling
|| 12/22/09 GHL 10.515 (70569) Only prevent project deletion if transactions are billed or in WIP 
|| 01/04/10 GHL 10.515 (70569) Only prevent project deletion if transactions are not transferred 
|| 01/08/10 GHL 10.516 Added check of wip status
|| 1/14/10  CRG 10.5.1.7 Added delete of tWorkTypeCustom
|| 4/7/10   GWG  10.251   Added null of convert entity on lead
|| 02/27/12 GHL 10.553  Replaced sptBillingDelete by delete tBilling + details statements
|| 04/30/13 QMD 10.567  Added delete of Art reviews
|| 06/11/13 RLB 10.569  Removed delete of deliverables because it is getting done before this SP and Added a check to see if there are any
|| 08/16/13 RLB 10.571  I moved delete of deliverables to after this SP so i removed the check for them so there is no error.
|| 07/31/15 WDF 10.582 (215641) Remove delete of tActionLog Project records
|| 
*/
  
    if isnull(@ProjectKey, 0) = 0
        return -1
	if exists(select 1 from tCalendar tbl (nolock) Where ProjectKey = @ProjectKey)
		return -2
	if exists(select 1 from tContactActivity tbl (nolock) Where ProjectKey = @ProjectKey)
		return -4
	if exists(select 1 from tExpenseReceipt tbl (nolock) Where ProjectKey = @ProjectKey
	          and TransferToKey is null )
		return -5
	if exists(select 1 from tExpenseReceipt tbl (nolock) Where ProjectKey = @ProjectKey
	          and TransferToKey is not null and WIPPostingInKey > 0)
		return -5
	if exists(select 1 from tForm tbl (nolock) Where ProjectKey = @ProjectKey)
		return -6
	if exists(select 1 from tInvoiceLine tbl (nolock) Where ProjectKey = @ProjectKey)
		return -7
	if exists(select 1 from tLead tbl (nolock) Where ProjectKey = @ProjectKey)
		return -8
	if exists(select 1 from tPurchaseOrderDetail tbl (nolock) Where ProjectKey = @ProjectKey
			 and TransferToKey is null )
		return -9
	if exists(select 1 from tQuote tbl (nolock) Where ProjectKey = @ProjectKey)
		return -10
	if exists(select 1 from tTime tbl (nolock) Where ProjectKey = @ProjectKey 
	          and TransferToKey is null )
		return -11
	if exists(select 1 from tTime tbl (nolock) Where ProjectKey = @ProjectKey 
	          and TransferToKey is not null and WIPPostingInKey > 0 )
		return -11
	if exists(select 1 from tVoucherDetail tbl (nolock) Where ProjectKey = @ProjectKey
			  and TransferToKey is null )
		return -12		
	if exists(select 1 from tVoucherDetail tbl (nolock) Where ProjectKey = @ProjectKey
			  and TransferToKey is not null and WIPPostingInKey > 0)
		return -12		
	if exists(select 1 from tMiscCost tbl (nolock) Where ProjectKey = @ProjectKey
		      and TransferToKey is null )
		return -13
	if exists(select 1 from tMiscCost tbl (nolock) Where ProjectKey = @ProjectKey
		      and TransferToKey is not null and WIPPostingInKey > 0)
		return -13
	if exists(select 1 from tBilling tbl (nolock) Where ProjectKey = @ProjectKey and Status = 5)
		return -14
	if exists(select 1 from tMediaEstimate tbl (nolock) Where ProjectKey = @ProjectKey)
		return -15
      
Begin Transaction

	UPDATE tLead
		SET ConvertEntity = NULL, ConvertEntityKey = NULL
	WHERE  ConvertEntity = 'tProject' and ConvertEntityKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -150		   	
	end

	DELETE tPurchaseOrderDetail
	WHERE  ProjectKey = @ProjectKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -122		   	
	end

	DELETE tVoucherDetail
	WHERE  ProjectKey = @ProjectKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -122		   	
	end

	DELETE tExpenseReceipt
	WHERE  ProjectKey = @ProjectKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -122		   	
	end

	DELETE tMiscCost
	WHERE  ProjectKey = @ProjectKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -122		   	
	end

	DELETE tTime
	WHERE  ProjectKey = @ProjectKey
	AND    TransferToKey is not null
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -122		   	
	end
	
	DELETE tBillingDetail
	from   tBilling b (nolock)
	where  b.ProjectKey = @ProjectKey
	and    b.BillingKey = tBillingDetail.BillingKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -121		   	
	end

	DELETE tBillingFixedFee
	from   tBilling b (nolock)
	where  b.ProjectKey = @ProjectKey
	and    b.BillingKey = tBillingFixedFee.BillingKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -121		   	
	end

	DELETE tBillingPayment
	from   tBilling b (nolock)
	where  b.ProjectKey = @ProjectKey
	and    b.BillingKey = tBillingPayment.BillingKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -121		   	
	end

	DELETE tBilling
	where ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -121		   	
	end

	DELETE tTaskUser from tTask Where
		tTaskUser.TaskKey = tTask.TaskKey and tTask.ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -118				   	
	end

	DELETE tTaskPredecessor from tTask Where
		tTaskPredecessor.TaskKey = tTask.TaskKey and tTask.ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -102					   	
	end
	DELETE tEstimateUser FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateUser.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -103					   	
	end
	DELETE tEstimateTaskExpense FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateTaskExpense.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -103					   	
	end
	DELETE tEstimateTaskAssignmentLabor FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateTaskAssignmentLabor.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -103					   	
	end
	DELETE tEstimateTaskLabor FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateTaskLabor.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -104			   	
	end
	DELETE tEstimateService FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateService.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -103					   	
	end
	DELETE tEstimateTask FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateTask.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -105		   	
	end
	DELETE tEstimateNotify FROM tEstimate WHERE 
		tEstimate.EstimateKey = tEstimateNotify.EstimateKey AND
		ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -120		   	
	end

	DELETE tEstimate WHERE  ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -106					   	
	end
	DELETE tTask WHERE  ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -107					   	
	end
	DELETE tAssignment WHERE  ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -108					   	
	end
	DELETE tProjectUserServices WHERE  ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -108					   	
	end
	DELETE tNote
	FROM
		tNoteGroup
	Where
		tNote.NoteGroupKey = tNoteGroup.NoteGroupKey and
		tNoteGroup.AssociatedEntity = 'Project' and
		tNoteGroup.EntityKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -109					   	
	end	
	DELETE tNoteGroup
	Where
		tNoteGroup.AssociatedEntity = 'Project' and
		tNoteGroup.EntityKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -109					   	
	end	

	DELETE tProjectCreativeBrief WHERE  ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -113					   	
	end

	Declare @CurKey int
	Declare @CurCKey int
	Select @CurKey = -1
	While 1=1
	BEGIN
		Select @CurKey = Min(SpecSheetKey) from tSpecSheet (NOLOCK) Where Entity = 'Project' and EntityKey = @ProjectKey and SpecSheetKey > @CurKey
		if @CurKey is null
			break
			
		Select @CurCKey = CustomFieldKey from tSpecSheet (NOLOCK) Where SpecSheetKey = @CurKey
		exec spCF_tObjectFieldSetDelete @CurCKey
		if @@ERROR <> 0 
		begin
			rollback transaction
			return -114					   	
		end
		
		Delete tSpecSheet Where SpecSheetKey = @CurKey
		if @@ERROR <> 0 
		begin
			rollback transaction
			return -115					   	
		end
		
	END

	Delete tApprovalItemReply Where ApprovalItemKey in 
		(Select ApprovalItemKey from tApprovalItem (NOLOCK) inner join tApproval (NOLOCK) on tApprovalItem.ApprovalKey = tApproval.ApprovalKey
			Where tApproval.ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -116					   	
	end
	Delete tApprovalItem Where ApprovalKey in (Select ApprovalKey From tApproval (NOLOCK) Where ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -116					   	
	end
	Delete tApprovalList Where ApprovalKey in (Select ApprovalKey From tApproval (NOLOCK) Where ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -116					   	
	end
	Delete tApprovalUpdateList Where ApprovalKey in (Select ApprovalKey From tApproval (NOLOCK) Where ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -116					   	
	end
	Delete tApproval Where ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -116					   	
	end
	
	Delete tDAFileVersion Where FileKey in (select FileKey from tDAFile (NOLOCK) inner join tDAFolder (NOLOCK) on tDAFile.FolderKey = tDAFolder.FolderKey Where tDAFolder.ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end
	Delete tDAFileRight Where FileKey in (select FileKey from tDAFile (NOLOCK) inner join tDAFolder (NOLOCK) on tDAFile.FolderKey = tDAFolder.FolderKey Where tDAFolder.ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end
	Delete tDAFile Where FolderKey in (select FolderKey from tDAFolder (NOLOCK) Where ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end
	Delete tDAFolderRight Where FolderKey in (select FolderKey from tDAFolder (NOLOCK) Where ProjectKey = @ProjectKey)
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end
	Delete tDAClientFolder Where ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end
	Delete tDAFolder Where ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end

	Delete tProjectRollup Where ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -117					   	
	end
	
	DELETE tProjectSplitBilling WHERE ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -119
	end
	
	DELETE	tWorkTypeCustom
	WHERE	Entity = 'tProject'
	AND		EntityKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -123
	end


	DELETE tProject WHERE  ProjectKey = @ProjectKey
	if @@ERROR <> 0 
	begin
		rollback transaction
		return -200				   	
	end

commit transaction

return 1
GO
