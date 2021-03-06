USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyDelete]
 @CompanyKey int
 ,@DeleteRestrictOnly int = 0
AS --Encrypt

Declare @UserKey int
Declare @ReturnVal int

  /*
  || When     Who Rel     What
  || 01/25/07 GHL 8.4     Added check of campaign before deletion. Bug 7958
  || 03/27/07 RTC 8.4.1   (8693) Prevent deletion of a vendor when Publications or Stations are tied to it
  || 10/26/07 CRG 8.4.3.9 (15136) Modified to not allow deletion if Company is a client directly on the Campaign (rather than going through tProject)
  || 07/31/08 GHL 10.5    Removed deletion of users, contact activities, leads for new contact management 
  ||                      Added unlinkage of calendar events
  || 11/1/10  GWG 10.537  Added a restriction to not delete if tied to opportunities
  || 12/22/10 GHL 10.539  (97815) do not delete if tied to a retainer
  || 10/28/13 GHL 10.573  (194458) do not delete if tied to a GL transaction
  || 09/02/14 RLB 10.584  Remove any tAppFavorite or tAppHistory data
  || 01/02/15 GAR 10.587  (240591) Delete tGLBudgetDetail record when company deleted
  */

  
--Note: return -1 was deletion of users 

-- Deletion Restricts
  
if exists(select 1 from tCheck tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -2
	end
if exists(select 1 from tInvoice tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -3
	end
if exists(select 1 from tProject tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -4
	end
if exists(select 1 from tPurchaseOrder tbl (nolock) where tbl.VendorKey = @CompanyKey)
	begin
		Return -5
	end
if exists(select 1 from tVoucher tbl (nolock) where tbl.VendorKey = @CompanyKey)
	begin
		Return -6
	end
if exists(select 1 from tPayment tbl (nolock) where tbl.VendorKey = @CompanyKey)
	begin
		Return -7
	end
if exists(select 1 from tVoucherDetail tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -8
	end
if exists(select 1 from tRequest tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -9
	end
if exists(select 1 from tMediaEstimate tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -10
	end
if exists(select 1 from tCampaign tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -11
	end
if exists(select 1 from tCompanyMedia tbl (nolock) where tbl.VendorKey = @CompanyKey)
	begin
		Return -12
	end
if exists(select 1 from tLead tbl (nolock) where tbl.ContactCompanyKey = @CompanyKey)
	begin
		Return -13
	end
if exists(select 1 from tRetainer tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -14
	end
if exists(select 1 from tTransaction tbl (nolock) where tbl.ClientKey = @CompanyKey)
	begin
		Return -15
	end

if @DeleteRestrictOnly = 1
	Return 1
	
Begin tran

declare @CustomFieldKey int
Select @CustomFieldKey = CustomFieldKey from tCompany (nolock) Where CompanyKey = @CompanyKey
exec spCF_tObjectFieldSetDelete @CustomFieldKey
	
-- Cascade Deletes
 			
DELETE FROM tClientProduct WHERE ClientKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE FROM tClientDivision WHERE ClientKey = @CompanyKey		
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE FROM tCampaign WHERE ClientKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE FROM tCompanyMedia WHERE VendorKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE FROM tAddress WHERE CompanyKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE FROM tGLBudgetDetail WHERE ClientKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

-- Cascade Unlinks
UPDATE tCalendar SET ContactCompanyKey = NULL WHERE  ContactCompanyKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

-- could be removed when managers are ready
UPDATE tUser SET CompanyKey = NULL WHERE CompanyKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

UPDATE tLead SET ContactCompanyKey = NULL WHERE ContactCompanyKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE tLevelHistory WHERE Entity = 'tCompany' AND EntityKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE tAppFavorite WHERE ActionID = 'cm.companies' AND ActionKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

DELETE tAppHistory WHERE ActionID = 'cm.companies' AND ActionKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

-- Record deletion
DELETE FROM tCompany WHERE CompanyKey = @CompanyKey
if @@ERROR <> 0 
begin
	rollback tran
	return -20					   	
end

commit tran 

 RETURN 1
GO
