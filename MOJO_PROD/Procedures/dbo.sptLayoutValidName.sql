USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutValidName]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutValidName]
	(
		@CompanyKey int,
		@LayoutName varchar(500),
		@Entity varchar(50) = 'billing'
	)
AS --Encrypt

/*  Who When        Rel       What
||  MFT 02/21/2013  10.5.7.7  Defaulted @Entity to 'billing'
*/

	SET NOCOUNT ON 
	
	declare @LayoutKey int

	select @LayoutKey = LayoutKey
	from   tLayout (nolock)
	where  CompanyKey = @CompanyKey
	and    upper(Entity) = upper(@Entity)
	and    upper(LayoutName) = ltrim(rtrim(upper(@LayoutName)))

	return isnull(@LayoutKey, 0)
GO
