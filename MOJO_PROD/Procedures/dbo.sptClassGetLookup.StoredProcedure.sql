USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassGetLookup]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassGetLookup]

	(
		@CompanyKey int,
		@ClassID varchar(50),
		@ShowAll tinyint
	)

AS --Encrypt

declare @Count int

if @ClassID is null
	Select
		ClassKey,
		ClassID,
		ClassName
	From tClass (nolock)
	Where
		CompanyKey = @CompanyKey and
		Active = 1
	Order By ClassID
else
begin
	select @Count = count(*)
	from   tClass (nolock)
	Where
		CompanyKey = @CompanyKey and
		ClassID like @ClassID + '%' and
		Active = 1
	
	if (@Count <= 1) and (@ShowAll = 1)
		Select
			ClassKey,
			ClassID,
			ClassName
		From tClass (nolock)
		Where
			CompanyKey = @CompanyKey and
			Active = 1
		Order By ClassID
	else			
		Select
			ClassKey,
			ClassID,
			ClassName
		From tClass (nolock)
		Where
			CompanyKey = @CompanyKey and
			ClassID like @ClassID + '%' and
			Active = 1
		Order By ClassID

end
GO
