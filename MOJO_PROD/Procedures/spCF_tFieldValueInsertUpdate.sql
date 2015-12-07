Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

/*
|| When      Who Rel     What
|| 01/14/08  GHL 10.5    Added tLead or opportunity custom fields
|| 01/14/08  QMD 10.5    Added tUserLeadOpportunity custom fields
|| 2/3/09    GWG 10.5    Added tActivity Support and a check to verify the custom field exists
|| 2/11/09   QMD 10.5    Added tProject custom field
|| 04/21/15  WDF 10.591 (250962) Added @UserKey; UpdatedByKey/DateUpdated to tSpecSheet
*/


declare @CustomFieldKey int
		
	if @Entity = 'tActivity'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tActivity (nolock) Where ActivityKey = @EntityKey
	if @Entity = 'tCampaign'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tCampaign (nolock) Where CampaignKey = @EntityKey
	if @Entity = 'tCompany'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tCompany (nolock) Where CompanyKey = @EntityKey
	if @Entity = 'tUser'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tUser (nolock) Where UserKey = @EntityKey
	if @Entity = 'tLead'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tLead (nolock) Where LeadKey = @EntityKey
	if @Entity = 'tProject'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tProject (nolock) Where ProjectKey = @EntityKey
	if @Entity = 'tForm'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tForm (nolock) Where FormKey = @EntityKey
	if @Entity = 'tPurchaseOrderDetail'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tPurchaseOrderDetail (nolock) Where PurchaseOrderDetailKey = @EntityKey
	if @Entity = 'tPurchaseOrder'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tPurchaseOrder (nolock) Where PurchaseOrderKey = @EntityKey
	if @Entity = 'tRequest'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tRequest (nolock) Where RequestKey = @EntityKey
	if @Entity = 'tSpecSheet'
		Select @CustomFieldKey = ISNULL(CustomFieldKey, 0) From tSpecSheet (nolock) Where SpecSheetKey = @EntityKey
		
	if @Entity = 'tUserLeadContact'
		Select @CustomFieldKey = ISNULL(UserCustomFieldKey, 0) From tUserLead (nolock) Where UserLeadKey = @EntityKey
	if @Entity = 'tUserLeadCompany'
		Select @CustomFieldKey = ISNULL(CompanyCustomFieldKey, 0) From tUserLead (nolock) Where UserLeadKey = @EntityKey
	if @Entity = 'tUserLeadOpportunity'
		Select @CustomFieldKey = ISNULL(OppCustomFieldKey, 0) From tUserLead (nolock) Where UserLeadKey = @EntityKey


	
	
	if ISNULL(@CustomFieldKey, 0) > 0
		if not exists(Select 1 from tObjectFieldSet (nolock) Where ObjectFieldSetKey = @CustomFieldKey)
			Select @CustomFieldKey = null
		
		
if ISNULL(@CustomFieldKey, 0) = 0
BEGIN
	INSERT tObjectFieldSet ( FieldSetKey ) VALUES ( @FieldSetKey )
	Select @CustomFieldKey = @@IDENTITY

		
	if @Entity = 'tActivity'
		Update tActivity Set CustomFieldKey = @CustomFieldKey Where ActivityKey = @EntityKey
	if @Entity = 'tCampaign'
		Update tCampaign Set CustomFieldKey = @CustomFieldKey Where CampaignKey = @EntityKey
	if @Entity = 'tCompany'
		Update tCompany Set CustomFieldKey = @CustomFieldKey Where CompanyKey = @EntityKey
	if @Entity = 'tUser'
		Update tUser Set CustomFieldKey = @CustomFieldKey Where UserKey = @EntityKey
	if @Entity = 'tLead'
		Update tLead Set CustomFieldKey = @CustomFieldKey Where LeadKey = @EntityKey
	if @Entity = 'tProject'
		Update tProject Set CustomFieldKey = @CustomFieldKey Where ProjectKey = @EntityKey
	if @Entity = 'tForm'
		Update tForm Set CustomFieldKey = @CustomFieldKey Where FormKey = @EntityKey
	if @Entity = 'tPurchaseOrderDetail'
		Update tPurchaseOrderDetail Set CustomFieldKey = @CustomFieldKey Where PurchaseOrderDetailKey = @EntityKey
	if @Entity = 'tPurchaseOrder'
		Update tPurchaseOrder Set CustomFieldKey = @CustomFieldKey Where PurchaseOrderKey = @EntityKey
	if @Entity = 'tRequest'
		Update tRequest Set CustomFieldKey = @CustomFieldKey Where RequestKey = @EntityKey
	if @Entity = 'tSpecSheet'
		Update tSpecSheet Set CustomFieldKey = @CustomFieldKey
		                     ,UpdatedByKey = @UserKey
		                     ,DateUpdated = GETUTCDate()
		 Where SpecSheetKey = @EntityKey
		
	if @Entity = 'tUserLeadContact'
		Update tUserLead Set UserCustomFieldKey = @CustomFieldKey Where UserLeadKey = @EntityKey
	if @Entity = 'tUserLeadCompany'
		Update tUserLead Set CompanyCustomFieldKey = @CustomFieldKey Where UserLeadKey = @EntityKey
	if @Entity = 'tUserLeadOpportunity'
		Update tUserLead Set OppCustomFieldKey = @CustomFieldKey Where UserLeadKey = @EntityKey
		
END


Declare @FieldValueKey as uniqueidentifier
  
	SELECT 
		@FieldValueKey = FieldValueKey
	FROM 
		tFieldValue (NOLOCK)
	WHERE 
		FieldDefKey = @FieldDefKey AND
		ObjectFieldSetKey = @CustomFieldKey

	IF @FieldValueKey IS NULL
		INSERT tFieldValue
		(
			FieldValueKey,
			FieldDefKey,
			ObjectFieldSetKey,
			FieldValue
		)
		VALUES
		(
			NEWID(),
			@FieldDefKey,
			@CustomFieldKey,
			@FieldValue
		) 
	ELSE
	UPDATE
		tFieldValue
	SET
		FieldDefKey = @FieldDefKey,
		ObjectFieldSetKey = @CustomFieldKey,
		FieldValue = @FieldValue
	WHERE
		FieldValueKey = @FieldValueKey 
