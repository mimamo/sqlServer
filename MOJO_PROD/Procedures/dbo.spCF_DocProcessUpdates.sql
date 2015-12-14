USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_DocProcessUpdates]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_DocProcessUpdates]

AS
	
declare @CustomFieldKey int
declare @NewCustomFieldKey int
declare @FieldSetKey int
declare @FieldDefKey int
declare @FieldValue varchar(8000)
declare @RetVal int


	--insert new field sets
	select @CustomFieldKey = 0
	while (1=1)
		begin
			select @CustomFieldKey = max(CustomFieldKey)
			from #tCFDocSaveKeys
			where (Action = 'insertEntity' or Action = 'insertOFS')
			and CustomFieldKey < @CustomFieldKey
			
			if @CustomFieldKey is null
				break 
				
			select @FieldSetKey = FieldSetKey from #tCFDocSaveKeys where CustomFieldKey = @CustomFieldKey
			exec @RetVal = spCF_tObjectFieldSetInsert @FieldSetKey, @NewCustomFieldKey output
			if @RetVal = 1
				begin
					update #tCFDocSaveKeys
					set NewCustomFieldKey = @NewCustomFieldKey
					where CustomFieldKey = @CustomFieldKey
					
					update #tCFDocSaveData
					set CustomFieldKey = @NewCustomFieldKey
					where CustomFieldKey = @CustomFieldKey
				end
		end
	
	--insert field values
	select @CustomFieldKey = 0
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
					exec spCF_tFieldValueUpdate @FieldDefKey, @CustomFieldKey, @FieldValue		
				end
		end		     
			
	--delete field sets
	select @CustomFieldKey = 0
	while (1=1)
		begin
			select @CustomFieldKey = min(CustomFieldKey)
			from #tCFDocSaveKeys
			where Action = 'deleteOFS'
			and CustomFieldKey > @CustomFieldKey
			
			if @CustomFieldKey is null
				break 
				
			exec spCF_tObjectFieldSetDelete @CustomFieldKey
		end		 
						
	return 1
GO
