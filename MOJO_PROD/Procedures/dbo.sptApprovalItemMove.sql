USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalItemMove]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalItemMove]
 @ApprovalItemKey int,
 @Direction smallint

AS --Encrypt

Declare @Order int, @OtherKey int, @ApprovalKey int

Select @Order = DisplayOrder, @ApprovalKey = ApprovalKey from tApprovalItem (nolock) Where ApprovalItemKey = @ApprovalItemKey
Select @OtherKey = ApprovalItemKey from tApprovalItem (nolock) Where ApprovalKey = @ApprovalKey and DisplayOrder = @Order + @Direction

if @OtherKey is Null
	return

Update tApprovalItem Set DisplayOrder = @Order + @Direction Where ApprovalItemKey = @ApprovalItemKey
Update tApprovalItem Set DisplayOrder = @Order Where ApprovalItemKey = @OtherKey
	
RETURN 1
GO
