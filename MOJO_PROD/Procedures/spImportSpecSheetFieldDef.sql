CREATE PROCEDURE [dbo].[spImportSpecSheetFieldDef]
	@FieldSetKey int,
	@DisplayOrder int,
	@OwnerEntityKey int,
	@FieldName varchar(75),
	@Description varchar(300),
	@DisplayType smallint,
	@Caption varchar(75),
	@Hint varchar(100),
	@Size int,
	@MinSize int,
	@MaxSize int,
	@TextRows int,
	@ValueList text,
	@Required tinyint,
	@Active tinyint,
	@OnlyAuthorEdit tinyint
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/21/07   CRG 8.4.3   (7087) Created to import the new Spec Sheet FieldDef.
|| 7/23/10   GHL 10.532  Added param MapTo to spCF_tFieldDefInsert
|| 06/22/11  GHL 10.545  (114355) Changed @ValueList from varchar(4000) to text
*/

	DECLARE	@FieldDefKey int

	--Check to see if a FieldDef already exists with the same name, if so use it.
	SELECT	@FieldDefKey = FieldDefKey
	FROM	tFieldDef (nolock) 
	WHERE	OwnerEntityKey = @OwnerEntityKey
	AND		AssociatedEntity = 'Spec'
	AND		FieldName = @FieldName
		
	IF @FieldDefKey IS NULL
		--Insert a new FieldDef
		EXEC spCF_tFieldDefInsert	@OwnerEntityKey,
									'Spec',
									@FieldName,
									@Description,
									@DisplayType,
									@Caption,
									@Hint,
									@Size,
									@MinSize,
									@MaxSize,
									@TextRows,
									@ValueList,
									@Required,
									@Active,
									@OnlyAuthorEdit,
									null,
									@FieldDefKey OUTPUT

	--Insert the FieldSetField row
	EXEC spCF_tFieldSetFieldInsert @FieldSetKey, @FieldDefKey, @DisplayOrder	