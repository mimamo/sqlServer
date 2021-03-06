USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_DocProcessUpdatesMultiple]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_DocProcessUpdatesMultiple]

AS

/*
|| When      Who Rel      What
|| 5/7/10    CRG 10.5.2.2 (80079) Added protection in case the @CustomFieldKey value is not in tObjectFieldSet
||                        Also fixed bug where the Entity table was not being updated with the ObjectFieldSetKey if its CustomFieldKey had never been set before
|| 11/15/12  RLB 10.5.6.2 (158280) Since the first selected field is 0 it was not getting in the insert loop. Starting loop at -1 instead of 0
*/

	
declare @CustomFieldKey int
declare @NewCustomFieldKey int
declare @FieldSetKey int
declare @FieldDefKey int
declare @FieldValue varchar(8000)
declare @RetVal int
declare @EntityKey int

	--update #tCFDocSaveData for existing CustomFieldKeys
	update #tCFDocSaveData
	set CustomFieldKey = NewCustomFieldKey
	from #tCFDocSaveKeys
	where #tCFDocSaveData.CustomFieldKey = #tCFDocSaveKeys.CustomFieldKey
	and NewCustomFieldKey is not null
	
	--insert new field sets
	select @CustomFieldKey = -1
	while (1=1)
		begin
			select @CustomFieldKey = min(CustomFieldKey)
			from #tCFDocSaveKeys
			where Action = 'insertOFS'
			and CustomFieldKey > @CustomFieldKey
			
			if @CustomFieldKey is null
				break 
				
			select @FieldSetKey = FieldSetKey from #tCFDocSaveKeys where CustomFieldKey = @CustomFieldKey
			exec @RetVal = spCF_tObjectFieldSetInsert @FieldSetKey, @NewCustomFieldKey output
			if @RetVal = 1
				begin
					update #tCFDocSaveKeys
					set NewCustomFieldKey = @NewCustomFieldKey
					where CustomFieldKey = @CustomFieldKey
					
					SELECT	@EntityKey = EntityKey
					FROM	#tCFDocSaveKeys
					WHERE	CustomFieldKey = @CustomFieldKey
					
					update #tCFDocSaveData
					set CustomFieldKey = @NewCustomFieldKey
					where EntityKey = @EntityKey
				end
		end
	
	--insert field values
	select @CustomFieldKey = -1
	while (1=1)
		begin
			select @CustomFieldKey = min(CustomFieldKey)
			from #tCFDocSaveData
			where CustomFieldKey > @CustomFieldKey
			
			if @CustomFieldKey is null
				break
				
			select @FieldDefKey = 0
			while (1=1)
				begin
					select @FieldDefKey = min(FieldDefKey)
					from #tCFDocSaveData
					where FieldDefKey > @FieldDefKey
					
					if @FieldDefKey is null
						break	
						
					select @FieldValue = FieldValue from #tCFDocSaveData where CustomFieldKey = @CustomFieldKey and FieldDefKey = @FieldDefKey

					--Protection in case the @CustomFieldKey does not exist in the tObjectFieldSet table					
					IF EXISTS
							(SELECT NULL
							FROM	tObjectFieldSet (nolock)
							WHERE	ObjectFieldSetKey = @CustomFieldKey)
						exec spCF_tFieldValueUpdate @FieldDefKey, @CustomFieldKey, @FieldValue
				end
		end		     	 
							
	return 1
GO
