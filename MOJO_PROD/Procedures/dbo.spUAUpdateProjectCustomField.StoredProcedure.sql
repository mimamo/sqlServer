USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUAUpdateProjectCustomField]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUAUpdateProjectCustomField]
	(
	@ProjectNumber varchar(50)
	,@FieldName varchar(75)
	,@FieldValue varchar(8000)
	)
	
AS 

	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 10/23/08 GHL 10.011  Creation for University of Alberta 
||                      Update a custom field on a project
*/

declare @CompanyKey int
select @CompanyKey = 1

-- error constants
declare @kErrNoProj int				select @kErrNoProj = -1
declare @kErrNoCF int				select @kErrNoCF = -2
declare @kErrInvalidField int		select @kErrInvalidField = -3
declare @kErrUnexpected int			select @kErrUnexpected = -4

declare @ProjectKey int
declare @ObjectFieldSetKey int
declare @FieldDefKey int
declare @RetVal int

select @ProjectKey = ProjectKey
      ,@ObjectFieldSetKey = CustomFieldKey
from   tProject (nolock)
where  CompanyKey = @CompanyKey
and    ProjectNumber = @ProjectNumber

-- No project?
if @@ROWCOUNT = 0
	return @kErrNoProj
	
-- no custom field?	
if isnull(@ObjectFieldSetKey, 0) = 0
	return @kErrNoCF
	
select @FieldDefKey = tFieldDef.FieldDefKey
FROM 
	tObjectFieldSet (NOLOCK)
INNER JOIN tFieldSetField (NOLOCK) ON tObjectFieldSet.FieldSetKey = tFieldSetField.FieldSetKey	
INNER JOIN tFieldDef (NOLOCK) ON tFieldSetField.FieldDefKey = tFieldDef.FieldDefKey
WHERE tObjectFieldSet.ObjectFieldSetKey = @ObjectFieldSetKey
AND   tFieldDef.FieldName = @FieldName

-- field name not part of the field set?
if @@ROWCOUNT = 0
	return @kErrInvalidField

-- we do not do any validation on the field size or type	
exec @RetVal = spCF_tFieldValueUpdate @FieldDefKey, @ObjectFieldSetKey, @FieldValue		
 
RETURN 1
GO
