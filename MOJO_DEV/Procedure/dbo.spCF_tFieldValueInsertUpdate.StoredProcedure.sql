USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldValueInsertUpdate]    Script Date: 04/29/2016 15:30:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'spCF_tFieldValueInsertUpdate'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[spCF_tFieldValueInsertUpdate]
GO

CREATE PROCEDURE [dbo].[spCF_tFieldValueInsertUpdate] 
(
	@Entity varchar(50),
	@EntityKey int,
	@FieldSetKey int,
	@FieldDefKey int,
	@FieldValue varchar(8000),
	@UserKey int
)
AS --Encrypt


/*******************************************************************************************************
*   MOJo_dev.dbo.spCF_tFieldValueInsertUpdate
*
*   Creator:	WMJ  
*   Date:		          
*   
*          
*   Notes: 
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.mojoDevPopulate 
	

|| When      Who Rel     What
|| 01/14/08  GHL 10.5    Added tLead or opportunity custom fields
|| 01/14/08  QMD 10.5    Added tUserLeadOpportunity custom fields
|| 02/03/09  GWG 10.5    Added tActivity Support and a check to verify the custom field exists
|| 02/11/09  QMD 10.5    Added tProject custom field
|| 04/21/15  WDF 10.591 (250962) Added @UserKey; UpdatedByKey/DateUpdated to tSpecSheet
|| 10/28/15  GAR 10.597  Added tQuote and tQuoteDetail custom field
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @CustomFieldKey int
declare @FieldValueKey as uniqueidentifier
---------------------------------------------
-- create temp tables
---------------------------------------------
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
	
if @Entity = 'tActivity'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tActivity (nolock) Where ActivityKey = @EntityKey
if @Entity = 'tCampaign'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tCampaign (nolock) Where CampaignKey = @EntityKey
if @Entity = 'tCompany'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tCompany (nolock) Where CompanyKey = @EntityKey
if @Entity = 'tUser'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tUser (nolock) Where UserKey = @EntityKey
if @Entity = 'tLead'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tLead (nolock) Where LeadKey = @EntityKey
if @Entity = 'tProject'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tProject (nolock) Where ProjectKey = @EntityKey
if @Entity = 'tForm'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tForm (nolock) Where FormKey = @EntityKey
if @Entity = 'tPurchaseOrderDetail'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tPurchaseOrderDetail (nolock) Where PurchaseOrderDetailKey = @EntityKey
if @Entity = 'tPurchaseOrder'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tPurchaseOrder (nolock) Where PurchaseOrderKey = @EntityKey
if @Entity = 'tQuoteDetail'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tQuoteDetail (nolock) Where QuoteDetailKey = @EntityKey
if @Entity = 'tQuote'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tQuote (nolock) Where QuoteKey = @EntityKey
if @Entity = 'tRequest'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tRequest (nolock) Where RequestKey = @EntityKey
if @Entity = 'tSpecSheet'
	Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From mojo_dev.dbo.tSpecSheet (nolock) Where SpecSheetKey = @EntityKey
	
if @Entity = 'tUserLeadContact'
	Select @CustomFieldKey = ISNULL(UserCustomFieldKey, 0) From mojo_dev.dbo.tUserLead (nolock) Where UserLeadKey = @EntityKey
if @Entity = 'tUserLeadCompany'
	Select @CustomFieldKey = ISNULL(CompanyCustomFieldKey, 0) From mojo_dev.dbo.tUserLead (nolock) Where UserLeadKey = @EntityKey
if @Entity = 'tUserLeadOpportunity'
	Select @CustomFieldKey = ISNULL(OppCustomFieldKey, 0) From mojo_dev.dbo.tUserLead (nolock) Where UserLeadKey = @EntityKey


	
	
if ISNULL(@CustomFieldKey, 0) > 0

	if not exists(Select 1 
					from mojo_dev.dbo.tObjectFieldSet (nolock) 
					Where ObjectFieldSetKey = @CustomFieldKey)
	begin	
		
		Select @CustomFieldKey = null
	
	end
		
	if ISNULL(@CustomFieldKey, 0) = 0
	BEGIN

		INSERT tObjectFieldSet ( FieldSetKey ) 
		VALUES ( @FieldSetKey )
		
		Select @CustomFieldKey = @@IDENTITY
			
		if @Entity = 'tActivity'
			Update mojo_dev.dbo.tActivity Set CustomFieldKey = @CustomFieldKey Where ActivityKey = @EntityKey
		if @Entity = 'tCampaign'
			Update mojo_dev.dbo.tCampaign Set CustomFieldKey = @CustomFieldKey Where CampaignKey = @EntityKey
		if @Entity = 'tCompany'
			Update mojo_dev.dbo.tCompany Set CustomFieldKey = @CustomFieldKey Where CompanyKey = @EntityKey
		if @Entity = 'tUser'
			Update mojo_dev.dbo.tUser Set CustomFieldKey = @CustomFieldKey Where UserKey = @EntityKey
		if @Entity = 'tLead'
			Update mojo_dev.dbo.tLead Set CustomFieldKey = @CustomFieldKey Where LeadKey = @EntityKey
		if @Entity = 'tProject'
			Update mojo_dev.dbo.tProject Set CustomFieldKey = @CustomFieldKey Where ProjectKey = @EntityKey
		if @Entity = 'tForm'
			Update mojo_dev.dbo.tForm Set CustomFieldKey = @CustomFieldKey Where FormKey = @EntityKey
		if @Entity = 'tPurchaseOrderDetail'
			Update mojo_dev.dbo.tPurchaseOrderDetail Set CustomFieldKey = @CustomFieldKey Where PurchaseOrderDetailKey = @EntityKey
		if @Entity = 'tPurchaseOrder'
			Update mojo_dev.dbo.tPurchaseOrder Set CustomFieldKey = @CustomFieldKey Where PurchaseOrderKey = @EntityKey
		if @Entity = 'tQuoteDetail'
			Update mojo_dev.dbo.tQuoteDetail Set CustomFieldKey = @CustomFieldKey Where QuoteDetailKey = @EntityKey
		if @Entity = 'tQuote'
			Update mojo_dev.dbo.tQuote Set CustomFieldKey = @CustomFieldKey Where QuoteKey = @EntityKey
		if @Entity = 'tRequest'
			Update mojo_dev.dbo.tRequest Set CustomFieldKey = @CustomFieldKey Where RequestKey = @EntityKey
		if @Entity = 'tSpecSheet'
			Update mojo_dev.dbo.tSpecSheet 
				Set CustomFieldKey = @CustomFieldKey
								 ,UpdatedByKey = @UserKey
								 ,DateUpdated = GETUTCDate()
			 Where SpecSheetKey = @EntityKey
			
		if @Entity = 'tUserLeadContact'
			Update mojo_dev.dbo.tUserLead Set UserCustomFieldKey = @CustomFieldKey Where UserLeadKey = @EntityKey
		if @Entity = 'tUserLeadCompany'
			Update mojo_dev.dbo.tUserLead Set CompanyCustomFieldKey = @CustomFieldKey Where UserLeadKey = @EntityKey
		if @Entity = 'tUserLeadOpportunity'
			Update mojo_dev.dbo.tUserLead Set OppCustomFieldKey = @CustomFieldKey Where UserLeadKey = @EntityKey
			
	END

SELECT @FieldValueKey = FieldValueKey
FROM mojo_dev.dbo.tFieldValue (NOLOCK)
WHERE FieldDefKey = @FieldDefKey 
	AND	ObjectFieldSetKey = @CustomFieldKey

IF @FieldValueKey IS NULL
begin

	INSERT tFieldValue
	(
		FieldValueKey,
		FieldDefKey,
		ObjectFieldSetKey,
		FieldValue
	)
	select	NEWID(),
		@FieldDefKey,
		@CustomFieldKey,
		@FieldValue

end
ELSE
begin

	UPDATE mojo_dev.dbo.tFieldValue
		SET	FieldDefKey = @FieldDefKey,
			ObjectFieldSetKey = @CustomFieldKey,
			FieldValue = @FieldValue
	WHERE FieldValueKey = @FieldValueKey 

end