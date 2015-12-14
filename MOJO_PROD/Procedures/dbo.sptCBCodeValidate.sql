USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeValidate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeValidate]
	(
		@ProjectNumber varchar(100),
		@TaskNumber varchar(100),
		@CompanyKey int,
		@Active tinyint
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 03/07/08  GHL 8.5.0.6 LLNL 2008 CBCode to Project/Task conversion
*/

Declare @CBCodeKey int

Select @CBCodeKey = CBCodeKey from tCBCode (nolock) 
Where CompanyKey = @CompanyKey 
And LTRIM(RTRIM(UPPER(ProjectNumber))) = LTRIM(RTRIM(UPPER(@ProjectNumber)))
And LTRIM(RTRIM(UPPER(TaskNumber))) = LTRIM(RTRIM(UPPER(@TaskNumber)))

if @CBCodeKey is null
BEGIN

	INSERT tCBCode
		(
		CompanyKey,
		ProjectNumber,
		TaskNumber,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@ProjectNumber,
		@TaskNumber,
		@Active
		)
		
		Select @CBCodeKey = @@Identity


END
ELSE
BEGIN

	Update tCBCode
	Set Active = @Active
	Where CBCodeKey = @CBCodeKey

END

Return @CBCodeKey
GO
